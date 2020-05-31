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

+(void)trackWithName:(NSString *)name eventInfo:(NSDictionary *)info;

+(void)trackWithName:(NSString *)name eventValue:(NSString *)value;

+(void)trackWithName:(NSString *)name;

+(void)trackWithName:(NSString *)name eventValue:(NSString *)value eventId:(NSString *)eventId eventConfigVersion:(NSString *)configVersion enentInfo:(NSDictionary *)info;

@end

