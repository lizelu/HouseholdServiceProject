//
//  ViewController.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/11.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "ViewController.h"
#import "HSQRCodeViewController.h"
#import "HSCalendarViewController.h"
#import "HSTools.h"
@interface ViewController ()<HSQRCodeViewControllerDelegate>
@property (nonatomic, strong) UITextField *hideTextField;
@property (nonatomic, strong) HSCalendarViewController * calendarViewController;
@property (strong, nonatomic) IBOutlet UIImageView *QRImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hideTextField = [[UITextField alloc] init];
    [self.view addSubview:_hideTextField];
    
    _calendarViewController = [[HSCalendarViewController alloc] init];
    [self addChildViewController:_calendarViewController];
    _hideTextField.inputView = _calendarViewController.view;
    _calendarViewController.view.frame = CGRectMake(0, 0, 1000, 300);
    [_calendarViewController didMoveToParentViewController:self];
    _QRImageView.image = [HSTools createQRCode:@"Hello QR"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapGestureRecognize:(id)sender {
    [self.view endEditing:YES];
    NSLog(@"%@", _calendarViewController.selectDateArray);
}

- (IBAction)tapButton:(id)sender {
    HSQRCodeViewController *vc = [[HSQRCodeViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)tapCalendar:(id)sender {
    [self.navigationController pushViewController:_calendarViewController animated:YES];
}
- (IBAction)tapDatePicker:(id)sender {
    [_hideTextField becomeFirstResponder];
}

#pragma mark - HSQRCodeViewControllerDelegate
- (void)QRCodeViewController:(UIViewController *)vc readResult:(NSString *)result
{
    if (result){
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@", result);
    }
}



@end
