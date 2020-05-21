//
//  ZZBodyHelper.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/19.
//  Copyright © 2020 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZBodyHelper : NSObject


+(instancetype)defaultBodyHelper;



/// 创建90-4请求数据
/// http://wiki.batcloud.cn/pages/viewpage.action?pageId=16680486
/// @param configVersion 策略版本ID
/// @param name 事件名
/// @param value 事件值
/// @param Id 事件ID
/// @param status 事件状态 0：未成功，1：成功 （默认成功）
/// @param info 事件信息（json）
-(NSString *)creatUserBody:(NSString *)configVersion
              withName:(NSString *)name
             withValue:(NSString *)value withId:(NSString *)Id
            withStatus:(NSUInteger)status
               withMsg:(NSString *)msg
              withInfo:(NSDictionary *)info;

///创建90-4请求数据
///http://wiki.batcloud.cn/pages/viewpage.action?pageId=16680484
-(NSString *)creatBaseBody;

@end

NS_ASSUME_NONNULL_END
