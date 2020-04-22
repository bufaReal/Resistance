//
//  AppDelegate.m
//  Resistance
//
//  Created by 孙树港 on 2020/3/14.
//  Copyright © 2020 ClassroomM. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //创建主束
     NSBundle *bundle=[NSBundle mainBundle];
    //读取plist文件路径
     NSString *path=[bundle pathForResource:@"colorHSVvalue" ofType:@"plist"];
    //读取数据到 NsDictionary字典中
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    path = [paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"colorHSVvalue.plist"];
    
    //判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        if ([dict writeToFile:filename atomically:YES]) {
            NSLog(@"转移文件成功");
        }
    }
        
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
