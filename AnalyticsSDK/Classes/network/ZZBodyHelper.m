//
//  ZZBodyHelper.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/19.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ZZBodyHelper.h"
#import "TPDeviceHelper.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import "ZZReachability.h"

 NSString * const TIME_FORMAT = @"YYYY-MM-dd HH:MM:SS";

@implementation ZZBodyHelper
{
    NSString * productVersionNmae;
    NSString * productVersionCode;

    NSString * idfa;
    NSString * emptyStr;
    
    NSString * paramDelimiter;
    NSString * lineDelimiter;
}


+ (instancetype)defaultBodyHelper {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        [instance initBody];
    });
    
    return instance;
}

/**
 获取初始数据
 */
-(void)initBody
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    productVersionNmae = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    productVersionCode = [infoDictionary objectForKey:@"CFBundleVersion"];
    idfa = [[TPDeviceHelper defaultHelper] getIDFA];
    emptyStr = @"null";
    
    //https://stackoverflow.com/questions/17155210/universal-character-name-error-in-nsstring-when-using-unicode-character
    paramDelimiter = [NSString stringWithFormat:@"%C", 0x0001];
    lineDelimiter =[NSString stringWithFormat:@"%C", 0x0002];
}


/**
 创建请求数据
 
 */
-(NSString *)creatUserBody:(NSString *)configVersion
              withName:(NSString *)name
             withValue:(NSString *)value withId:(NSString *)Id
            withStatus:(NSUInteger)status
               withMsg:(NSString *)msg
              withInfo:(NSDictionary *)info

{
    NSString* log_time = [self getBJTime];
    NSString* create_date = [log_time substringToIndex:[log_time length] - 9];

    NSArray *componentArray = @[
     log_time,
     create_date,
     ZZSDK_VersionCode,
     ZZSDK_VersionString,
     productVersionCode,
     productVersionNmae,
     @(ZZSDK_ServiceVersion),
     @(ZZSDK_DataVersion),
     emptyStr,//imei
     emptyStr,//android
     emptyStr,//googleId
     emptyStr,//batId
     [ZZBaseHelper defaultBaseHelper].appkey,
     configVersion==nil?emptyStr:configVersion,
     name,
     info==nil?emptyStr:[[ZZBaseHelper defaultBaseHelper] convertToJsonData:info],
     value==nil?emptyStr:value,
     @(status),
     msg==nil?emptyStr:msg,//msg
     Id==nil?emptyStr:Id,
     [self serial],
     emptyStr,//oaid
     [ZZBaseHelper defaultBaseHelper].odid==nil?emptyStr:[ZZBaseHelper defaultBaseHelper].odid,//user_id
     idfa
    ];
    
    NSLog(@"======90-5=======\n%@",[componentArray componentsJoinedByString:@"--"]);

    return [componentArray componentsJoinedByString:paramDelimiter];
}


-(NSString *)creatBaseBody
{
    NSString* log_time = [self getBJTime];
    NSString* create_date =  [log_time substringToIndex:[log_time length] - 9];
    
    //国家代码（大写）
    NSString *country = [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] uppercaseString];
    //语言
    NSString *userLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
    
    UIDevice *device = [UIDevice currentDevice];
    //品牌
    NSString *brand = [device model];

    struct utsname systemInfo;
    uname(&systemInfo);
    //型号
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    NSInteger modelType = 1;
    if([model containsString:@"iPad"])
    {
        modelType = 2;
    }
    
    //运营商
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];

    

    NSArray *componentArray = @[
     log_time,
     create_date,
     ZZSDK_VersionCode,
     ZZSDK_VersionString,
     productVersionCode,
     productVersionNmae,
     @(ZZSDK_ServiceVersion),
     @(ZZSDK_DataVersion),
     emptyStr,//imei    无
     emptyStr,//android 无
     emptyStr,//googleId    无
     emptyStr,//batId       无
     [ZZBaseHelper defaultBaseHelper].appkey,
     emptyStr,//usr_id 即uk
     [ZZBaseHelper defaultBaseHelper].channel==nil?emptyStr:[ZZBaseHelper defaultBaseHelper].channel,//channel_code
     country,//国家
     emptyStr,//province    暂时不采集
     emptyStr,//city        暂时不采集
     emptyStr,//longitude   暂时不采集
     emptyStr,//latitude    暂时不采集
     userLang,//language
     brand,//brand
     model,//model
     @(modelType),//model_type
     [self getNetconnType],//network_type网络类型
     emptyStr,//resolution分辨率 无
     carrier.carrierName==nil?emptyStr:carrier.carrierName,//operator运营商
     @(2),//platform 1:Android 2:IOS 3:WEB
     device.systemVersion,//os_version_code
     device.systemVersion,//os_version_name
     emptyStr,//biz_sdk_version 无
     emptyStr,//fb_install      无
     emptyStr,//oaid            无
     [self serial],//request_id
     [ZZBaseHelper defaultBaseHelper].odid==nil?emptyStr:[ZZBaseHelper defaultBaseHelper].odid,//odid
     emptyStr,//installer       无
     emptyStr,//mac             暂时不采集
     idfa
    ];
    
    
    
    
    NSLog(@"======90-4=======\n%@",[componentArray componentsJoinedByString:@"--"]);

    return [componentArray componentsJoinedByString:paramDelimiter];
}


-(NSString *)getBJTime
{

    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TIME_FORMAT];

    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    // 北京时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*60*60];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [timeZone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    nowDate = [nowDate dateByAddingTimeInterval:interval];

    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
   
    NSString *nowDateString = [NSString stringWithFormat:@"%@",nowDate];

 
    
    return [[nowDateString substringToIndex:[nowDateString length] - 6] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    

    
}


// 生成字符串长度
#define kRandomLength 10
- (NSString *)serial
{
    //1.UUIDString
    NSString *string = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    //2.时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",time];
    
    //3.随机字符串kRandomLength位
    static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: kRandomLength];
    for (int i = 0; i < kRandomLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    
    //==> UUIDString去掉最后一项,再拼接上"时间戳"-"随机字符串kRandomLength位"
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"-"]];
    [array removeLastObject];
    [array addObject:timeStr];
    [array addObject:randomString];
    return [array componentsJoinedByString:@"-"];
}



- (NSString *)getNetconnType{
    
    NSString *netconnType = @"";
    
   ZZReachability *reach = [ZZReachability zzReachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}


@end
