//
//  HSTools.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/11.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "HSTools.h"

#define RegularExpression_TelNumber @"^(1)[0-9]{10}$"
#define RegularExpression_Password @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"

#define RegularExpression_AuthCode @"^(\\d{4,8})"
#define RegularExpression_Email @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define RegularExpression_Money @"^[0-9]{0,11}((\\.)[0-9]{0,2})?$"



@implementation HSTools

#pragma mark 正则匹配金额，最多保留两位小数
+ (BOOL)verifyMoney:(NSString *)money {
    NSString *pattern = RegularExpression_Money;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:money];
    return isMatch;
}

#pragma mark 验证手机号
+ (BOOL)verifyTelNumber:(NSString *)telNumber {
    NSString *pattern = RegularExpression_TelNumber;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

#pragma mark 正则匹配用户密码（6-18位数字和字母组合）
+ (BOOL)verifyPassword:(NSString *)password {
    NSString *pattern = RegularExpression_Password;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

#pragma mark 验证身份证号码
+ (BOOL)verifyUserIdCard:(NSString *)idCard {
    NSString *newValue = [idCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!newValue) {
        return NO;
    } else {
        NSInteger length = newValue.length;
        if (length != 15 && length != 18) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 验证URL
+ (BOOL)verifyURL:(NSString *)url {
    NSString *pattern = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

#pragma mark 验证手机短信验证码
+ (BOOL)verifyAuthCode:(NSString *)authCode {
    NSString *pattern = RegularExpression_AuthCode;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:authCode];
    return isMatch;
}

#pragma mark 验证邮箱
+ (BOOL)verifyEmail:(NSString *)email {
    NSString *emailRegex = RegularExpression_Email;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 判断是否为null nil
+ (BOOL)isNull:(NSObject *)obj {
    if([[NSNull null] isEqual:obj] || !obj || [obj isEqual:Nil] || [obj isEqual:NULL] ) {
        return YES;
    }
    return NO;
}

#pragma mark AlertView
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (UIImage *)createQRCode: (NSString *) content {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];

    return [HSTools createNonInterpolatedUIImageFormCIImage:image withSize:100];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
