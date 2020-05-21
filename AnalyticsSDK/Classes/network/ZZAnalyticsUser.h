//
//  ZZAnalyticsUser.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/20.
//  Copyright © 2020 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZNetwork.h"
NS_ASSUME_NONNULL_BEGIN


/// 用户操作事件协议 http://wiki.batcloud.cn/pages/viewpage.action?pageId=16680486
/// 90-5
@interface ZZAnalyticsUser : NSObject<ZZNetworkDelegate>

@property (nonatomic,retain)ZZNetwork *network;

+(instancetype)shareInstance;

/// 统计用户操作
/// @param configVersion 策略版本ID
/// @param name 事件名
/// @param value 事件值
/// @param Id 事件ID
/// @param status 事件状态 0：未成功，1：成功 （默认成功）
/// @param msg 错误信息
/// @param info 事件信息（json）
-(void)track:(NSString *)configVersion
          withName:(NSString *)name
         withValue:(NSString *)value
            withId:(NSString *)Id
        withStatus:(NSUInteger)status
           withMsg:(NSString *)msg
          withInfo:(NSString *)info;


@end

NS_ASSUME_NONNULL_END
