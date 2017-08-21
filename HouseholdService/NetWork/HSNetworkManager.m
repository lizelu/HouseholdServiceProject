//
//  HSNetworkManager.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/12.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "HSNetworkManager.h"
#import "AFNetworking.h"
#define QUEST_TIME_OUT 30   //网络超时限时

@interface HSNetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@end

@implementation HSNetworkManager
static HSNetworkManager *manager;
+ (HSNetworkManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HSNetworkManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _afManager = [AFHTTPSessionManager manager];
        _afManager.requestSerializer.timeoutInterval = QUEST_TIME_OUT;
        _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return self;
}

-(void)postRequest:(NSMutableDictionary *)param
              path:(NSString *)url
             start:(HSRequestStart)start
           success:(HSRequestSuccess)success
           failure:(HSRequestFailure)failure {
   
    if (param == nil || start == nil || success == nil || failure == nil) {
        return;
    }
    
    start();
    
    [self.afManager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil) {
            failure([HSResponseFailureModel new]);
            return;
        }
        HSBaseModel *successModel = [HSResponseSuccessModel yy_modelWithDictionary:responseObject];
        success(successModel);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([HSResponseFailureModel new]);
    }];

    
}

@end
