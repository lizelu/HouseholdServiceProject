//
//  HSNetworkManager.h
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/12.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSResponseSuccessModel.h"
#import "HSResponseFailureModel.h"
typedef void (^HSRequestStart) ();
typedef void (^HSRequestSuccess) (HSBaseModel *modle);
typedef void (^HSRequestFailure) (HSBaseModel *modle);


@protocol HSRequestProtocol <NSObject>
-(void)postRequest:(NSMutableDictionary *) param
             start:(HSRequestStart) start
           success:(HSRequestSuccess) success
           failure:(HSRequestFailure) failure;
@end



@interface HSNetworkManager : NSObject
+ (HSNetworkManager *)sharedHTTPSession;
@end
