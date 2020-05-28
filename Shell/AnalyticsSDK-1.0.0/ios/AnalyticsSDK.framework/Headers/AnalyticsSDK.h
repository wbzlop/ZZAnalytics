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
/// @param debug 是否调试
/// @param isCN 是否国内
+(void)initWithAppkey:(NSString *)appkey andIsDebug:(BOOL )debug andIsCN:(BOOL)isCN;


/// 设置uk
/// @param uk <#uk description#>
+(void)setUK:(NSString *)uk;


/// 设置渠道
/// @param channel <#channel description#>
+(void)setChannel:(NSString *)channel;

@end

