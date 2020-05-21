//
//  ZZBaseHelper.h
//  ZZStrategySDK
//
//  Created by zhouhaoran on 2018/8/21.
//  Copyright © 2018年 zhouhaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "ZZAutoCodingObject.h"
@interface ZZBaseHelper : NSObject
+ (instancetype)defaultBaseHelper;


/// odid 全局ID，从中台获取
@property (nonatomic,copy)NSString *odid;

/// appkey
@property (nonatomic,copy)NSString *appkey;

/// 用户uk，从umk登录获取
@property (nonatomic,copy)NSString *uk;

/// 渠道
@property (nonatomic,copy)NSString *channel;

/// 是否国内，用来区分域名
@property (nonatomic,assign)BOOL cn;

/// 是否调试
@property (nonatomic,assign)BOOL debug;
/**
 工作队列
 
 @return 一个队列
 */
-(dispatch_queue_t)workQueue;

/**
 内部生成随机的UUID
 
 @return 随机的UUID
 */
-(NSString *)generateUUID;




/**
 获取当前系统时间
 
 @return 时间
 */
- (NSString *)getCurrentTime;

/**
 获取客户端版本号

 @return 客户端版本号
 */
-(NSInteger)appBuildNumber;

/**
 是否是纯数字

 @param checkedNumString 待测字符串
 @return YES/NO
 */
- (BOOL)isNum:(NSString *)checkedNumString;



/**
 自定义错误
 
 @param desc 描述
 @return NSError
 */
-(NSError *)getError:(NSString *)desc;


/**
 获取本地缓存

 @param archiveKey key
 @return ZZAutoCodingObject
 */
-(__kindof ZZAutoCodingObject *)getLocalStrategy:(NSString *)archiveKey;


/// 字典转json 
/// @param dict <#dict description#>
-(NSString *)convertToJsonData:(NSDictionary *)dict;


/**
 获取首次响应时间

 @return time string
 */
-(NSString *)getLocalFirstResponseTime;

+ (NSString *)getNetconnType;

+(NSString *)getDeviceType;
@end
