//
//  StepViewController.m
//  Resistance
//
//  Created by 孙树港 on 2020/4/20.
//  Copyright © 2020 ClassroomM. All rights reserved.
//

#import "StepViewController.h"

@interface StepViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *curentImage;
@property (weak, nonatomic) IBOutlet UIStepper *stepperImage;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UILabel *imageNameLabel;

@property (strong, nonatomic) NSArray *imageName;

@end

@implementation StepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.stepperImage setIncrementImage:[UIImage systemImageNamed:@"chevron.down"] forState:UIControlStateNormal];
    [self.stepperImage setDecrementImage:[UIImage systemImageNamed:@"chevron.up"] forState:UIControlStateNormal];
    self.imageNameLabel.text = self.imageName[0];
    if (self.colorsImage.count > 0) {
        self.curentImage.image = self.colorsImage[0];
    }
    if (self.logString) {
        self.logTextView.text = self.logString;
    }
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.colorsImage removeAllObjects];
}

- (IBAction)switchImage:(UIStepper *)sender {
    self.imageNameLabel.text = self.imageName[(int)sender.value];
    if (self.colorsImage.count > 0) {
        self.curentImage.image = self.colorsImage[(int)sender.value];
    }
}
#pragma mark lazy load
- (NSArray *)imageName
{
    if (_imageName == nil && _imageName.count == 0) {
        _imageName = @[@"green", @"blue", @"yellow", @"red", @"black", @"gray", @"orange", @"purple", @"white", @"gold", @"silver", @"brown"];
    }
    return _imageName;
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
