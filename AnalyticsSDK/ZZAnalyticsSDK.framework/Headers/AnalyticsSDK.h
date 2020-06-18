//
//  AnalyticsSDK.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/18.
//  Copyright © 2020年 zhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AnalyticsSDK : NSObject


/// 初始化sdk
/// @param debug 是否打印日志
/// @param isCN 是否国内
+(void)initWithAppkey:(NSString *)appkey printLog:(BOOL )printLog andIsCN:(BOOL)isCN;


/// 设置uk
/// @param uk <#uk description#>
+(void)setUK:(NSString *)uk;


/// 设置渠道
/// @param channel <#channel description#>
+(void)setChannel:(NSString *)channel;


/// 统计事件
/// @param name  事件名
/// @param info 事件map（可nil）
+(void)trackWithName:(NSString *)name eventInfo:(NSDictionary *)info;


/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
+(void)trackWithName:(NSString *)name eventValue:(NSString *)value;



/// 统计事件
/// @param name 事件名
+(void)trackWithName:(NSString *)name;

/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
/// @param eventId 事件ID（可nil）
/// @param configVersion 策略版本（可nil）
/// @param info 事件map（可nil）
+(void)trackWithName:(NSString *)name eventValue:(NSString *)value eventId:(NSString *)eventId eventConfigVersion:(NSString *)configVersion enentInfo:(NSDictionary *)info;

/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
/// @param eventId 事件ID（可nil）
/// @param configVersion 策略版本（可nil）
/// @param infoStr 事件map（可nil）
+(void)trackWithName:(NSString *)name eventValue:(NSString *)value eventId:(NSString *)eventId eventConfigVersion:(NSString *)configVersion enentInfoStr:(NSString *)infoStr;

@end

