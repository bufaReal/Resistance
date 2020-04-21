//
//  SetterViewController.m
//  Resistance
//
//  Created by 孙树港 on 2020/4/20.
//  Copyright © 2020 ClassroomM. All rights reserved.
//

#import "SetterViewController.h"

@interface SetterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *switchColor;
@property (weak, nonatomic) IBOutlet UITextField *HLowField;
@property (weak, nonatomic) IBOutlet UITextField *SLowField;
@property (weak, nonatomic) IBOutlet UITextField *VLowField;
@property (weak, nonatomic) IBOutlet UITextField *HHighField;
@property (weak, nonatomic) IBOutlet UITextField *SHighField;
@property (weak, nonatomic) IBOutlet UITextField *VHighField;

@property (strong ,nonatomic) NSDictionary *colorMessage;

@end

@implementation SetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showColorMessage:0];
    
    // Do any additional setup after loading the view.
}

#pragma mark --- action
- (IBAction)switchColor:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择颜色" preferredStyle:UIAlertControllerStyleActionSheet];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    for (int i = 0; i < self.colorMessage.count; i ++) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", self.colorMessage.allKeys[i]]
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
            [self showColorMessage:i];
        }];
        [alertController addAction:otherAction];
    }
    
    
    // Add the actions.
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)HLow:(UITextField *)sender {
    NSInteger num = [sender.text integerValue];
    if (num > 180) {
        sender.text = @"";
    }
}
- (IBAction)SLow:(UITextField *)sender {
    NSInteger num = [sender.text integerValue];
    if (num > 255) {
        sender.text = @"";
    }
}
- (IBAction)VLow:(UITextField *)sender {
    NSInteger num = [sender.text integerValue];
    if (num > 255) {
        sender.text = @"";
    }
}
- (IBAction)HHigh:(UITextField *)sender {
    NSInteger num = [sender.text integerValue];
    if (num > 180) {
        sender.text = @"";
    }
}
- (IBAction)SHigh:(UITextField *)sender {
    NSInteger num = [sender.text integerValue];
    if (num > 255) {
        sender.text = @"";
    }
}

- (IBAction)VHigh:(UITextField *)sender {
    NSInteger num = [sender.text integerValue];
    if (num > 255) {
        sender.text = @"";
    }
}
- (IBAction)saveColor:(UIBarButtonItem *)sender {
    
}

#pragma mark --- self method
- (void)showColorMessage:(int)index
{
    NSString *colorName = [NSString stringWithFormat:@"%@", self.colorMessage.allKeys[index]];
    self.switchColor.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.switchColor.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.switchColor setTitle:[NSString stringWithFormat:@"颜色名称\n%@", colorName] forState:UIControlStateNormal];
    
    NSDictionary *colorValue = self.colorMessage.allValues[index];
    NSArray *highHSV = [colorValue objectForKey:@"high"];
    self.HHighField.text = [NSString stringWithFormat:@"%@", highHSV[0]];
    self.SHighField.text = [NSString stringWithFormat:@"%@", highHSV[1]];
    self.VHighField.text = [NSString stringWithFormat:@"%@", highHSV[2]];
    NSArray *lowHSV = [colorValue objectForKey:@"low"];
    self.HLowField.text = [NSString stringWithFormat:@"%@", lowHSV[0]];
    self.SLowField.text = [NSString stringWithFormat:@"%@", lowHSV[1]];
    self.VLowField.text = [NSString stringWithFormat:@"%@", lowHSV[2]];
}

#pragma mark --- lazy load
- (NSDictionary *)colorMessage
{
    if (!_colorMessage) {
//        _colorMessage = [NSDictionary dictionary];
        //创建主束
         NSBundle *bundle=[NSBundle mainBundle];
        //读取plist文件路径
         NSString *path=[bundle pathForResource:@"colorHSVvalue" ofType:@"plist"];
        //读取数据到 NsDictionary字典中
        _colorMessage=[[NSDictionary alloc]initWithContentsOfFile:path];
    }
    return _colorMessage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
