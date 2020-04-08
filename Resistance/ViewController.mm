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
#import <Masonry.h>


using namespace cv;
using namespace std;


@interface ViewController ()<CvVideoCameraDelegate>

@property (nonatomic, strong) CvVideoCamera *videoCamera;
@property (weak, nonatomic) IBOutlet UILabel *colorName;

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
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(352, 288));
    }];

    
    // Do any additional setup after loading the view.
}

- (void)processImage:(cv::Mat &)image
{
    //检测矩形部分
    //转化为灰度图像
    Mat greyPic;
    cvtColor(image, greyPic, COLOR_BGR2GRAY); //转化为灰度图
    medianBlur(greyPic, greyPic, 1);    //中值滤波
//    image = greyPic;
    
    Mat binPic;
//    threshold(greyPic, binPic, 0, 255, THRESH_BINARY | THRESH_OTSU);    //阈值化为二值图片
    const int maxVal = 255;
    int blockSize = 3;    //取值3、5、7....等
    int constValue = 10;
    int adaptiveMethod = 0;
    int thresholdType = 1;
    /*
           自适应阈值算法
           0:ADAPTIVE_THRESH_MEAN_C
           1:ADAPTIVE_THRESH_GAUSSIAN_C
           --------------------------------------
           阈值类型
           0:THRESH_BINARY
           1:THRESH_BINARY_INV
       */
       //---------------【4】图像自适应阈值操作-------------------------
    adaptiveThreshold(greyPic, binPic, maxVal, adaptiveMethod, thresholdType, blockSize, constValue);
    image = binPic;
    
    float cannyThr = 100, FACTOR = 2.5;
    Mat cannyPic;
    Canny(binPic, cannyPic, cannyThr, cannyThr*FACTOR);    //Canny边缘检测
//    image = cannyPic;
    vector<vector<cv::Point>> contours;    //储存轮廓
    vector<Vec4i> hierarchy;
    findContours(cannyPic, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);    //获取轮廓
    
    //现在找出矩形
    vector<vector<cv::Point>> contours_poly(contours.size());//用于存放折线点集
    Mat Rect = image.clone();
    //当查找到多个矩形后，而后计算中心距
    static int RectCount = 0;
    for (int i = 0; i < contours.size(); i++)
    {
        approxPolyDP(contours[i], contours_poly[i], arcLength(contours[i], true) * 0.01, true);
        if (contours_poly[i].size() % 4 == 0)
        {
            drawContours(Rect, contours_poly, i, Scalar(rand() & 255, rand() & 255, rand() & 255), 2, 8, Mat(), 0, cv::Point());//dst必须先初始化
            image = Rect;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.colorName.text = [NSString stringWithFormat:@"边的数目%lu 矩形数目%i", contours_poly[i].size(), ++RectCount];
            }];
        }
    }
    /// 计算矩
    vector<Moments> mu(contours.size());
    ///  计算中心矩:
    vector<Point2f> mc(contours.size());
    /// 计算矩
    for( int i = 0; i < contours.size(); i++ )
       { mu[i] = moments( contours[i], false ); }
    /// 计算矩
    for( int i = 0; i < contours.size(); i++ )
       { mc[i] = Point2f( mu[i].m10/mu[i].m00 , mu[i].m01/mu[i].m00 ); }

    RectCount = 0;
    //中心矩是一个容器，需要处理其中的点
    //遍历mc 容器
    for (int i = 0; i < mc.size(); i ++)
    {
        if (isnan(mc[i].x) || isnan(mc[i].y))
        {
            mc.erase(begin(mc) + i);
        }
    }
    
    //把中心矩 vector 转化成为 int
    vector<Point2f> mc_int(mc.size());
    transform(mc.begin(), mc.end(), mc_int.begin(), op);
    
    //删除重复元素
    vector<Point2f> mc_int_singal(1);
    for (int i = 0; i < mc_int.size(); i ++)
    {
        auto iter = std::find(std::begin(mc_int_singal), std::end(mc_int_singal), mc_int[i]);
        if (iter == std:: end (mc_int_singal))
        {
            mc_int_singal.push_back(mc_int[i]);
        }
    }
    mc_int_singal.erase(begin(mc_int_singal));
    
    
   // 画出图像
    
//    Mat linePic = Mat::zeros(cannyPic.rows, cannyPic.cols, CV_8UC3);
//    for (int index = 0; index < contours_poly.size(); index++){
//            drawContours(Rect, contours_poly[index], index, Scalar(rand() & 255, rand() & 255, rand() & 255), 1, 8/*, hierarchy*/);
//    }
//    image = Rect;
    
    
    
    
     //暂时不使用//计算最大面积矩形
//     vector<vector<cv::Point>> polyContours(contours.size());
//     int maxArea = 0;
//     for (int index = 0; index < contours.size(); index++){
//         if (contourArea(contours[index]) > contourArea(contours[maxArea]))
//             maxArea = index;
//         approxPolyDP(contours[index], polyContours[index], 10, true);
//     }
     //画出矩形
//    Mat polyPic = Mat::zeros(shrinkedPic.size(), CV_8UC3);
//    drawContours(polyPic, polyContours, maxArea, Scalar(0,0,255/*rand() & 255, rand() & 255, rand() & 255*/), 2);
    
//    Mat matHsv;
//    cvtColor(image,matHsv,COLOR_BGR2HSV);
//
//    vector<int> colorVec;
//    colorVec.push_back(matHsv.at<uchar>(0,0));
//    colorVec.push_back(matHsv.at<uchar>(0,1));
//    colorVec.push_back(matHsv.at<uchar>(0,2));
//
//    if((colorVec[0] >= 0 && colorVec[0] <= 180) && (colorVec[1] >= 0 && colorVec[1] <= 255) && (colorVec[2] >= 0 && colorVec[2] <= 46)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"黑";
//        }];
//    }
//    if((colorVec[0] >= 0 && colorVec[0] <= 180) && (colorVec[1] >= 0 && colorVec[1] <= 43) && (colorVec[2] >= 46 && colorVec[2] <= 220)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"灰";
//        }];
//    }
//    if((colorVec[0] >= 0 && colorVec[0] <= 180) && (colorVec[1] >= 0&&colorVec[1] <= 30) && (colorVec[2] >= 221 && colorVec[2] <= 255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"白";
//        }];
//    }
//    if(((colorVec[0] >= 0 && colorVec[0] <= 10) || (colorVec[0] >= 156 && colorVec[0] <= 180)) && (colorVec[1] >= 43 && colorVec[1] <= 255) && (colorVec[2] >= 46 && colorVec[2] <= 255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"红";
//        }];
//    }
//    if((colorVec[0] >= 11 && colorVec[0] <= 25) && (colorVec[1] >= 43 && colorVec[1] <= 255) && (colorVec[2] >= 46 && colorVec[2] <= 255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"橙";
//        }];
//    }
//    if((colorVec[0] >= 26 && colorVec[0] <= 34) && (colorVec[1] >= 43 && colorVec[1] <= 255) && (colorVec[2] >= 46 && colorVec[2] <= 255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"黄";
//        }];
//    }
//    if((colorVec[0] >= 35 && colorVec[0] <= 77) && (colorVec[1] >= 43 && colorVec[1] <= 255) && (colorVec[2] >= 46 && colorVec[2] <= 255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"绿";
//        }];
//    }
//    if((colorVec[0] >= 78 && colorVec[0] <= 99) && (colorVec[1] >= 43 && colorVec[1] <= 255) && (colorVec[2] >= 46 && colorVec[2] <= 255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"青";
//        }];
//    }
//    if((colorVec[0] >= 100 && colorVec[0] <= 124) && (colorVec[1] >= 43 && colorVec[1] <= 255) && (colorVec[2] >= 46 && colorVec[2] <= 255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"蓝";
//        }];
//    }
//    if((colorVec[0] >= 125 && colorVec[0] <= 155) && (colorVec[1] >= 43 && colorVec[1] <= 255) && (colorVec[2]>=46&&colorVec[2]<=255)){
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.colorName.text = @"紫";
//        }];
//    }
//    else{
//        cout<<"未知"<<endl;
//    }

   
}

Point2f op(Point2f ch)
{
    Point2f ponit((int)ch.x, (int)ch.y);
    return ponit;
}

//图形的中心点需要两个方面的计算
//一个是得到中心点颜色
//另外一个是得到几个中心点之间的距离
- (IBAction)StartAction:(UIButton *)sender {
    [self.videoCamera start];
}

@end
