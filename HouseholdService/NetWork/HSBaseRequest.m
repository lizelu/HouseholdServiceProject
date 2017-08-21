//
//  HSBaseRequest.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/12.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "HSBaseRequest.h"

@interface HSBaseRequest()
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) HSRequestStart requestStart;
@property (nonatomic, strong) HSRequestSuccess requestSuccess;
@property (nonatomic, strong) HSRequestFailure reqeustFailure;
@end

@implementation HSBaseRequest



-(void)postRequest:(NSMutableDictionary *)param
             start:(HSRequestStart)start
           success:(HSRequestSuccess)success
           failure:(HSRequestFailure)failure {
    self.param = param;
    if (self.param == nil) {
        self.param = [NSMutableDictionary dictionary];
    }
    
    self.requestStart = start;
    self.requestSuccess = success;
    self.reqeustFailure = failure;
    [self postRequest];
}

-(void)postRequest {
    if (_requestStart == nil || _requestSuccess == nil || _reqeustFailure == nil) {
        return;
    }
}

/**
 子类要重写的方法，用来话API地址

 @return 返回的是API地址
 */
-(NSString *)fetchAPIPath {
    return @"";
}

@end
