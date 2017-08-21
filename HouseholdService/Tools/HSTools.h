//
//  HSTools.h
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/11.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface HSTools : NSObject

/**
 *  验证手机号
 *
 *  @param telNumber 手机号
 *
 *  @return 验证成功返回YES，否则返回NO
 */
+ (BOOL)verifyTelNumber:(NSString *)telNumber;

/**
 *  验证用户密码（6-18位数字和字母组合）
 *
 *  @param password 密码
 *
 *  @return 验证成功返回YES，否则返回NO
 */
+ (BOOL)verifyPassword:(NSString *)password;

/**
 *  验证URL
 *
 *  @param url 要验证的url
 *
 *  @return 验证成功返回YES，否则返回NO
 */
+ (BOOL)verifyURL:(NSString *)url;

/**
 *  验证手机短信验证码
 *
 *  @param authCode 手机短信验证码
 *
 *  @return 验证成功返回YES，否则返回NO
 */
+ (BOOL)verifyAuthCode:(NSString *)authCode;

/**
 *  验证邮箱格式
 *
 *  @param email 要验证的邮箱
 *
 *  @return 验证成功返回YES，否则返回NO
 */
+ (BOOL)verifyEmail:(NSString *)email;


/**
 *  验证金额，不超过两位小数
 *
 *  @param money 要验证的金额
 *
 *  @return 验证成功返回YES，否则返回NO
 */
+ (BOOL)verifyMoney:(NSString *)money;


+ (UIImage *)createQRCode: (NSString *) content;

@end
