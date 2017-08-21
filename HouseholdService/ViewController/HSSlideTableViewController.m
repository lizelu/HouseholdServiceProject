//
//  HSSlideTableViewController.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/11.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "HSSlideTableViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#define MainStorybaord [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
@interface HSSlideTableViewController ()

@end

@implementation HSSlideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tap1:(id)sender {
    self.sidePanelController.centerPanel = [MainStorybaord instantiateViewControllerWithIdentifier:@"TestNav1"];
}
- (IBAction)tap2:(id)sender {
    self.sidePanelController.centerPanel = [MainStorybaord instantiateViewControllerWithIdentifier:@"TestNav2"];
}
- (IBAction)tap3:(id)sender {
    self.sidePanelController.centerPanel = [MainStorybaord instantiateInitialViewController];
}

@end
