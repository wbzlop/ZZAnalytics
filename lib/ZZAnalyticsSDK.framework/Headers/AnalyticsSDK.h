//
//  AnalyticsSDK.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/18.
//  Copyright © 2020年 GameGoing. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AnalyticsSDK : NSObject



/// 初始化sdk
/// @param appkey <#appkey description#>
/// @param printLog 是否打印日志
/// @param isCN 是否国内
+(void)initWithAppkey:(NSString *)appkey printLog:(BOOL )printLog andIsCN:(BOOL)isCN;


/// 设置uk
/// @param uk <#uk description#>
+(void)setUK:(NSString *)uk;


/// 设置odid
/// @param odid 从中台获取
+(void)setODID:(NSString *)odid;


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

/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
/// @param eventId 事件ID（可nil）
/// @param configVersion 策略版本（可nil）
/// @param status 状态（0）
/// @param errorMsg 错误信息（可nil）
/// @param infoStr 事件map（可nil）
+(void)trackWithName:(NSString *)name eventValue:(NSString *)value eventId:(NSString *)eventId eventConfigVersion:(NSString *)configVersion eventStatus:(NSUInteger)status errorMsg:(NSString *)errorMsg enentInfoStr:(NSString *)infoStr;


/// 是否无网络
+(BOOL)isNotReachable;

@end

