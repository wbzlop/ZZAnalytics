//
//  ZZBaseHelper.m
//  ZZStrategySDK
//
//  Created by zhouhaoran on 2018/8/21.
//  Copyright © 2018年 zhouhaoran. All rights reserved.
//

#import "ZZBaseHelper.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTCarrier.h>
#import "ZZAutoCodingObject.h"
#import "ZZReachability.h"
#import <sys/utsname.h>
@interface ZZBaseHelper()
@property(nonatomic)NSString *signKey;
@end

@implementation ZZBaseHelper

+ (instancetype)defaultBaseHelper {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(dispatch_queue_t)workQueue{
    
    static dispatch_once_t onceToken;
    static dispatch_queue_t queue;
    dispatch_once(&onceToken, ^{
        
        queue=dispatch_queue_create([@"ZZAD_WORK_QUEUE" UTF8String],NULL);
    });
    
    
    return queue;
}





- (NSString *)getCurrentTime {
    
    return [[NSNumber numberWithLong:[[NSDate new] timeIntervalSince1970]] stringValue];
}



-(NSInteger)appBuildNumber {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSInteger app_build = [[infoDictionary objectForKey:@"CFBundleVersion"]  integerValue];
    if(app_build==0){
        app_build = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
    }
    return app_build;
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}


-(NSError *)getError:(NSString *)desc
{
    NSString *domain = @"com.zz.sdk.ErrorDomain";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    
    NSError *error = [NSError errorWithDomain:domain
                                         code:-101
                                     userInfo:userInfo];
    return error;
}


-(__kindof ZZAutoCodingObject *)getLocalStrategy:(NSString *)archiveKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *userInfoData = [userDefaults objectForKey:archiveKey];
    
    ZZAutoCodingObject *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
    
    return userInfo;
}




+ (NSString *)getNetconnType{
    
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


+(NSString *)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    return model;
}


-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;

}


-(NSDate *)getLocalTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date dateByAddingTimeInterval: interval];
}


@end
