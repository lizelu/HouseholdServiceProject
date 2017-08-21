//
//  HSQRCodeViewController.h
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/11.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

@class HSQRCodeViewController;

@protocol HSQRCodeViewControllerDelegate <NSObject>

- (void)QRCodeViewController:(UIViewController *)vc readResult:(NSString *)result;

@end

@interface HSQRCodeViewController : UIViewController

@property (nonatomic, weak) id<HSQRCodeViewControllerDelegate> delegate;

@end
