//
//  HSBaseRequest.h
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/12.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSNetworkManager.h"

@interface HSBaseRequest : NSObject<HSRequestProtocol>
-(void)postRequest:(NSMutableDictionary *) param
             start:(HSRequestStart) start
           success:(HSRequestSuccess) success
           failure:(HSRequestFailure) failure;
/**
 子类要重写的方法，用来话API地址
 
 @return 返回的是API地址
 */
-(NSString *)fetchAPIPath;  //请求子类提供的方法，用来提供具体的API
@end

