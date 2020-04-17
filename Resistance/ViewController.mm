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
#include <MapKit/MapKit.h>


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
    
    UIButton *colorBand = [UIButton buttonWithType:UIButtonTypeSystem];
    [colorBand setTitle:@"电阻色环" forState:UIControlStateNormal];
    [colorBand addTarget:self action:@selector(selectedColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:colorBand];
    [colorBand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];

    
    // Do any additional setup after loading the view.
}

#pragma mark event
- (void)selectedColor
{
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"电阻色环"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                          }];
    UIAlertAction* deleteAction1 = [UIAlertAction actionWithTitle:@"三色环电阻" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //响应事件
                                                            NSLog(@"action = %@", action);
                                                        }];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"四色环电阻" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"五色环电阻" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    UIAlertAction* saveAction1 = [UIAlertAction actionWithTitle:@"六色环电阻" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //响应事件
                                                            NSLog(@"action = %@", action);
                                                        }];
    
    [alert addAction:deleteAction1];
    [alert addAction:deleteAction];
    [alert addAction:saveAction];
    
    [alert addAction:saveAction1];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark delegate
- (void)processImage:(cv::Mat &)image
{
    //检测全部颜色
    Mat hsvImg;
    cvtColor(image, hsvImg, COLOR_BGR2HSV);
    enum colorType{Red = 0, Green, Blue, ColorButt};
    
    const Scalar hsvBlackLo(0, 0, 0);
    const Scalar hsvBlackHi(180, 255, 46);
    
    const Scalar hsvGrayLo(0, 0, 46);
    const Scalar hsvGrayHi(180, 43, 220);
    
    const Scalar hsvOrangeLo(11, 43, 46);
    const Scalar hsvOrangeHi(24, 255, 255);
    
    const Scalar hsvPurpleLo(125, 43, 46);
    const Scalar hsvPurpleHi(155, 255, 255);
    
    const Scalar hsvWhiteLo(0, 0, 221);
    const Scalar hsvWhiteHi(180, 30, 255);
    
    const Scalar hsvGoldLo(125, 43, 46);
    const Scalar hsvGoldHi(0.1405 * 180 , 255, 255);
    
    const Scalar hsvSilverLo(125, 43, 46);
    const Scalar hsvSilverHi(0, 0, 0.9373);
    
    const Scalar hsvRedLo( 0,  40,  40);
    const Scalar hsvRedHi(40, 255, 255);
      
    const Scalar hsvGreenLo(41,  40,  40);
    const Scalar hsvGreenHi(90, 255, 255);
      
    const Scalar hsvBlueLo(100,  40,  40);
    const Scalar hsvBlueHi(140, 255, 255);
    
    const Scalar hsvYellowLo(26, 43, 46);
    const Scalar hsvYellowHi(34, 255, 255);
      
    vector<Scalar> hsvLo{hsvGreenLo, hsvBlueLo, hsvYellowLo, hsvRedLo, hsvBlackLo, hsvGrayLo, hsvOrangeLo, hsvPurpleLo, hsvWhiteLo, hsvSilverLo, hsvSilverLo};
    vector<Scalar> hsvHi{hsvGreenHi, hsvBlueHi, hsvYellowHi, hsvRedHi, hsvBlackHi, hsvGrayHi, hsvOrangeHi, hsvPurpleHi, hsvWhiteHi, hsvGoldHi, hsvSilverHi};
    
    //存储得到的颜色边框
    vector<string> colors = {"red", "green", "blue", "yellow", "red", "black", "gray", "orange", "perple", "white"};
    std:map<string, vector<vector<cv::Point>>> colorContours;
    //这里是个循环.重复步骤，直到所有颜色都识别完毕。
    for (int colorIdx = 0; colorIdx < hsvLo.size(); colorIdx ++) {
        Mat imgThresholded;
        // 查找指定范围内的颜色
        inRange(hsvImg, hsvLo[colorIdx], hsvHi[colorIdx], imgThresholded);
//        image = imgThresholded;
        Mat binPic;
//        threshold(imgThresholded, binPic, 1, 255, THRESH_BINARY | THRESH_OTSU);    //阈值化为二值图片
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
        adaptiveThreshold(imgThresholded, binPic, maxVal, adaptiveMethod, thresholdType, blockSize, constValue);
        float cannyThr = 100, FACTOR = 2.5;
        Mat cannyPic;
        Canny(binPic, cannyPic, cannyThr, cannyThr*FACTOR);    //Canny边缘检测
        vector<Vec4i> hierarchy;
        //这里数据结构是不对的。
        //应该把各个颜色的边框存储到一个map中，比如red：contours
        vector<vector<cv::Point>> contours;    //储存轮廓
        findContours(cannyPic, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);    //获取轮廓
        colorContours.insert(std::make_pair(colors[colorIdx], contours));
        contours.clear();
    }
    hsvLo.clear();
    hsvHi.clear();
    
    
    //检测矩形部分
    //转化为灰度图像
    Mat greyPic;
//    cvtColor(image, greyPic, COLOR_BGR2GRAY); //转化为灰度图
//    image = greyPic;
//    medianBlur(greyPic, greyPic, 1);    //中值滤波
//    image = greyPic;
    std::map<string, vector<Point2f>> shapeCenter;
    if (colorContours.size() > 100) {
        colorContours.clear();
    }
    for (int j = 0; j < colorContours.size(); j ++) {
        
        vector<vector<cv::Point>> contours = colorContours[colors[j]];
        //因为线条拉伸需要太多的CPU资源，所以过滤掉大部分
        if (contours.size() > 100) {
            contours.clear();
        }
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
//               drawContours(Rect, contours_poly, i, Scalar(rand() & 255, rand() & 255, rand() & 255), 2, 8, Mat(), 0, cv::Point());//dst必须先初始化
//               image = Rect;
//               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                   self.colorName.text = [NSString stringWithFormat:@"边的数目%lu 矩形数目%i", contours_poly[i].size(), ++RectCount];
//               }];
            }
//        }
            RectCount = 0;
            
            /// 计算矩
            vector<Moments> mu(contours_poly.size());
                
            ///  计算中心矩:
            vector<Point2f> mc(contours_poly.size());
            /// 计算矩
            for( int i = 0; i < contours_poly.size(); i++ )
               { mu[i] = moments( contours_poly[i], false ); }
            /// 计算矩
            for( int i = 0; i < contours_poly.size(); i++ )
               { mc[i] = Point2f( mu[i].m10/mu[i].m00 , mu[i].m01/mu[i].m00 ); }
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
            shapeCenter.insert(std::make_pair(colors[j], mc_int_singal));
            
            mu.clear();
            mc.clear();
            mc_int.clear();
            mc_int_singal.clear();
        }
//        NSLog(@"contours size %lu", contours.size());
//        contours.clear();
//        contours_poly.clear();
        
    }
    
    //现在是颜色对应点，只需要确定颜色的次序就可以算出阻值
    //先迭代输出一下
    map<string, vector<Point2f>>::iterator iter;
    for(iter = shapeCenter.begin(); iter != shapeCenter.end(); iter++)
    {
        cout<<iter->first<<' '<<iter->second<<endl;
    }
    
    //先排序。排序也需要讨论按照x排序还是y排序。显然使用两个。
    //求X/Y的平均值，找到间隔相等的点
    //先不区分X和Y排序试下
    //map所有的元素转化成为vector
    vector<Point2f> sortPoint;
    for(iter = shapeCenter.begin(); iter != shapeCenter.end(); iter++)
    {
        for(int i=0;i<iter->second.size();i++)
        {
            vector<Point2f> tmp = iter->second;
            sortPoint.push_back(tmp[i]);
        }
    }
    
    //（两点之间的颜色相等）
    Scalar flagColor;
    flagColor[0] = 0; flagColor[1] = 0; flagColor[2] = 0;
    for (int i = 0; i < sortPoint.size(); i ++) {
        //两点之间平均值
        float averageX = 0.0, averageY = 0.0;
        if (i + 1 < sortPoint.size()) {
            averageX = (sortPoint[i].x + sortPoint[i + 1].x) / 2;
            averageY = (sortPoint[i].y + sortPoint[i + 1].y) / 2;
            Point2f a;
            a.x = averageX; a.y = averageY;
            Scalar color = getMatColor(image, a);
            if (flagColor[0] != 0) {
                if (flagColor[0] != color[0] || flagColor[1] != color[1] || flagColor[2] != color[2]) {
                    flagColor[0] = 0; flagColor[1] = 0; flagColor[2] = 0;
                    sortPoint.erase(begin(sortPoint) + i);
                    i --;
                }
            }
        }
        
    }
    
    sort(sortPoint.begin(), sortPoint.end(), cmpX);
    //每个点之间间隔是否相同。
    //先得到每个点之间的距离，然后统计，找到符合要求的点
    map<float, float> statisticsMap;//统计X方向上之间的间距，存储到map中
    for(int i = 0; i < sortPoint.size(); i ++)
    {
        float front = sortPoint[i].x;
        float back = 0;
        if (i + 1 < sortPoint.size()) {
            back = sortPoint[i + 1].x;
            map<float, float>::iterator l_it;;
            l_it = statisticsMap.find(front - back);
            if(l_it == statisticsMap.end()){
                statisticsMap.insert(map<int, int>::value_type(front - back, 0));
                cout<<"we do not find 112"<<endl;
            }
            else{
                statisticsMap[front - back] ++;
                cout<<"wo find 112"<<endl;
            }
        }
        
        cout << "sortPoint" << sortPoint[i] << endl;
    }
    
    //当个数等于一就不要删了
    for(int i = 0; i < sortPoint.size(); i ++)
    {
        float front = sortPoint[i].x;
        float back = 0;
        if (i + 1 < sortPoint.size()) {
            back = sortPoint[i + 1].x;
            if (statisticsMap[front - back] <= 2 && statisticsMap[front - back] != 0) {
                sortPoint.erase(begin(sortPoint) + i);//不要将其删除，而是加入到另外一个vector
                i --;
            }
        }
    }
    
    sort(sortPoint.begin(), sortPoint.end(), cmpY);
    for(int i = 0; i < sortPoint.size(); i ++)
    {
        float front = sortPoint[i].y;
        float back = 0;
        if (i + 1 < sortPoint.size()) {
            back = sortPoint[i + 1].y;
            map<float, float>::iterator l_it;;
            l_it = statisticsMap.find(front - back);
            if(l_it == statisticsMap.end()){
                statisticsMap.insert(map<int, int>::value_type(front - back, 0));
                cout<<"we do not find 112"<<endl;
            }
            else{
                statisticsMap[front - back] ++;
                cout<<"wo find 112"<<endl;
            }
        }
        cout << "sortPoint" << sortPoint[i] << endl;
    }
    
    for(int i = 0; i < sortPoint.size(); i ++)
    {
        float front = sortPoint[i].y;
        float back = 0;
        if (i + 1 < sortPoint.size()) {
            back = sortPoint[i + 1].y;
            if (statisticsMap[front - back] <= 2 && statisticsMap[front - back] != 0) {
                sortPoint.erase(begin(sortPoint) + i);
                i --;
            }
        }
    }
    
    //锁定是哪几个点之后，需要找到电阻的色环的第一位和末位
    //找到第一位或者末位只需要比较，point x或者y之间的间距。如果第一个间距和第二个间距相等则反转。如果第一个间距大于第二个间距，则不用反转
    //先找x或者y都无所谓
    bool isReverseOrder = NO;
    float length, length1;
    if (sortPoint.size() >= 2) {
        length = sortPoint[0].x - sortPoint[1].x;
        length1 = sortPoint[1].x - sortPoint[2].x;
        if (fabs(length) > fabs(length1)) {
            isReverseOrder = YES;
            reverse(sortPoint.begin(), sortPoint.end());
        }
        if (!isReverseOrder) {
            length = sortPoint[0].y - sortPoint[1].y;
            length1 = sortPoint[1].y - sortPoint[2].y;
        }
        if (fabs(length) > fabs(length1)) {
            isReverseOrder = YES;
            reverse(sortPoint.begin(), sortPoint.end());
        }
    }
    
    //在map中查找,输出一串颜色名称次序
    
    //计算阻值
    
    
    
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
       
}

Scalar getMatColor(Mat image, Point2f point)
{
    Scalar color = image.at<Vec3b>(point.x, point.y);//读取原图像(150, 150)的BGR颜色值，如果是灰度图像，将Vec3b改为uchar
    return color;
}

Point2f op(Point2f ch)
{
    Point2f ponit((int)ch.x, (int)ch.y);
    return ponit;
}

bool cmpX(Point2f a,Point2f b) ///cmp函数传参的类型不是vector<int>型，是vector中元素类型,即int型
{
    return a.x > b.x;
}

bool cmpY(Point2f a,Point2f b) ///cmp函数传参的类型不是vector<int>型，是vector中元素类型,即int型
{
    return a.y > b.y;
}

//图形的中心点需要两个方面的计算
//一个是得到中心点颜色
//另外一个是得到几个中心点之间的距离
- (IBAction)StartAction:(UIButton *)sender {
    [self.videoCamera start];
}
- (IBAction)Pauseaction:(UIButton *)sender {
    [self.videoCamera stop];
}

@end
