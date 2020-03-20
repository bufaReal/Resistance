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
        cvtColor(image, hsv, COLOR_RGB2HSV);

        //h的范围是0~180，所以选取30个bin
        //s和v的范围都是0~255，那就选择51个bin
        int hbins = 30;
        int sbins = 51;
        int vbins = 51;
        int hHistSize[] = {hbins};
        int sHistSize[] = {sbins};
        int vHistSize[] = {vbins};

        float hranges[] = {0, 180};
        float sranges[] = {0, 255};
        float vranges[] = {0, 255};
        const float* hRanges[] = {hranges};
        const float* sRanges[] = {sranges};
        const float* vRanges[] = {vranges};
        vector<MatND> hist;

        int hChannels[] = {0};
        int sChannels[] = {1};
        int vChannels[] = {2};
        MatND hHist, sHist, vHist;
        calcHist(&hsv, 1, hChannels, Mat(), hHist, 1, hHistSize, hRanges);
        calcHist(&hsv, 1, sChannels, Mat(), sHist, 1, sHistSize, sRanges);
        calcHist(&hsv, 1, vChannels, Mat(), vHist, 1, vHistSize, vRanges);
        hist.push_back(hHist);
        hist.push_back(sHist);
        hist.push_back(vHist);
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
    } else {
        cv::Mat gray;
        cv::cvtColor(image, gray, COLOR_RGB2GRAY);
        cv::GaussianBlur(gray, gray, cv::Size(5,5), 1.2, 1.2);
        cv::Mat edges;
        cv::Canny(gray, edges, 0, 60);
        image.setTo(cv::Scalar::all(255));
        image.setTo(cv::Scalar(0,128,255,255), edges);
    }
    
    
}
- (IBAction)StartAction:(UIButton *)sender {
    [self.videoCamera start];
}

@end
