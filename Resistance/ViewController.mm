//
//  ViewController.m
//  Resistance
//
//  Created by 孙树港 on 2020/3/14.
//  Copyright © 2020 ClassroomM. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/video.hpp>
#import <opencv2/photo.hpp>
#import <opencv2/core.hpp>     // Basic OpenCV structures (cv::Mat, Scalar)
#import <opencv2/imgproc.hpp>  // Gaussian Blur
#import <opencv2/videoio.hpp>
#import <opencv2/highgui.hpp>  // OpenCV window I/O


using namespace cv;
using namespace std;


@interface ViewController ()<CvVideoCameraDelegate>

@property (nonatomic, strong) CvVideoCamera *videoCamera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2)];
    [self.view addSubview:imageView];
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;

    
    // Do any additional setup after loading the view.
}

- (void)processImage:(cv::Mat &)image
{
    //应该是别人用来处理图片，我这里是视频
//    IplImage* _myimage = cvCreateImage(cvGetSize(image), 8, 3);
//    cvGetImage(image, _myimage);
    //输入图片得是三通道彩色图片
//    assert (!image.empty() && image.channels() == 3);

    if (image.empty()) {
        return;
    }
    
    if (image.channels() == 4) {
        Mat hsv;
        //转化颜色空间的功能
        cvtColor(image, hsv, COLOR_RGB2HSV);

        //h的范围是0~180，所以选取30个bin
        //s和v的范围都是0~255，那就选择51个bin
        //bins：每个特征空间子区段的数目。
        int hbins = 30;
        int sbins = 51;
        int vbins = 51;
        //histSize, 直方图中每个维度级别数量，比如灰度值（0-255），如果级别数量为4，则灰度值直方图会按照[0, 63],[64,127,[128,191],[192,255]，也称为bin数目，这里是4个bin
        int hHistSize[] = {hbins};
        int sHistSize[] = {sbins};
        int vHistSize[] = {vbins};

        //range：每个特征空间的取值范围。
        float hranges[] = {0, 180};
        float sranges[] = {0, 255};
        float vranges[] = {0, 255};
        const float* hRanges[] = {hranges};
        const float* sRanges[] = {sranges};
        const float* vRanges[] = {vranges};
        //容器
        vector<MatND> hist;

        //通道
        int hChannels[] = {0};
        int sChannels[] = {1};
        int vChannels[] = {2};
        //typedef Mat MatND;
        MatND hHist, sHist, vHist;
        //它计算一组数组（通常是图像或图像平面）的直方图
        //&hsv 图像指针
        //1 要计算直方图的图像的个数
        //hChannels 图像的第一个通道，sChannels 图像的第二个通道，vChannels 图像的第三个通道
        //Mat() 空参数，表示哪些点参与计算
        //hHist 计算得到的直方图 sHist 计算得到的直方图 vHist 计算得到的直方图
        //1 得到的直方图的维数，灰度图像为1维，彩色图像为3维
        //hHistSize hHistSize  hHistSize直方图横坐标的区间数。如果是10，则它会横坐标分为10份，然后统计每个区间的像素点总和。
        //hRanges sRanges vRanges这是一个二维数组，用来指出每个区间的范围
        calcHist(&hsv, 1, hChannels, Mat(), hHist, 1, hHistSize, hRanges);
        calcHist(&hsv, 1, sChannels, Mat(), sHist, 1, sHistSize, sRanges);
        calcHist(&hsv, 1, vChannels, Mat(), vHist, 1, vHistSize, vRanges);
        hist.push_back(hHist);
        hist.push_back(sHist);
        hist.push_back(vHist);
        // 直方图归一化
        //b_hist：输入数组
        //b_hist：输出归一化数组（可以相同）
        //0和** histImage.rows：对于这个例子，它们是对r_hist **的值进行归一化的下限和上限
        //NORM_MINMAX：指示归一化类型的参数（如上所述，它调整之前设置的两个限制之间的值）
        //** - 1：**意味着输出归一化数组将与输入的类型相同
        //Mat（）：可选掩码
        //normalize(b_hist, b_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );
        normalize( hist[0], hist[0], 0, 1, NORM_MINMAX, -1, Mat() );
        normalize( hist[1], hist[1], 0, 1, NORM_MINMAX, -1, Mat() );
        normalize( hist[2], hist[2], 0, 1, NORM_MINMAX, -1, Mat() );

        int i;
        int start = -1, end = -1;
        for(i = 0; i < 30; i++)
        {
            float value = hist[0].at<float>(i);
            if (value  > 0)
            {
                if (start == -1)
                {
                    start = i;
                    end = i;
                }
                else
                    end = i;
                cout << "H Value" << i << ": " << value << endl;
            }
            else
            {
                if (start != -1)
                    cout <<"H:" <<start*6 <<"~"<<(end+1)*6-1<<endl;
                start = end = -1;
            }
        }
        if (start != -1)
            cout <<"H:" <<start*5 <<"~"<<(end+1)*5-1<<endl;

        start = -1, end = -1;
        for(i = 0; i < 51; i++)
        {
            float value = hist[1].at<float>(i);
            if (value  > 0)
            {
                if (start == -1)
                {
                    start = i;
                    end = i;
                }
                else
                    end = i;
                cout << "S Value" << i << ": " << value << endl;
            }
            else
            {
                if (start != -1)
                    cout <<"S:"<< start*5 <<"~"<<(end+1)*5-1<<endl;
                start = end = -1;
            }
        }
        if (start != -1)
            cout <<"S:" <<start*5 <<"~"<<(end+1)*5-1<<endl;

        start = -1, end = -1;
        for(i = 0; i < 51; i++)
        {
            float value = hist[2].at<float>(i);
            if (value  > 0)
            {
                if (start == -1)
                {
                    start = i;
                    end = i;
                }
                else
                    end = i;
                cout << "V Value" << i << ": " << value << endl;
            }
            else
            {
                if (start != -1)
                    cout <<"V:" <<start*5 <<"~"<<(end+1)*5-1<<endl;
                start = end = -1;
            }
        }
        if (start != -1)
            cout <<"V:" <<start*5 <<"~"<<(end+1)*5-1<<endl;
    }
}
- (IBAction)StartAction:(UIButton *)sender {
    [self.videoCamera start];
}

@end
