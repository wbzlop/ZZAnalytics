//
//  TPDeviceHelper.m
//  Unity-iPhone
//
//  Created by wbz on 2020/4/24.
//

#import "TPDeviceHelper.h"
#import <AdSupport/AdSupport.h>

#import "SAMKeychain.h"


const NSString * KEYCHAIN_ACCOUNT = @"com.djs.sdk";
const NSString * KEYCHAIN_UUID_SERVICE = @"com.djs.sdk_service";
 
@implementation TPDeviceHelper

+ (instancetype)defaultHelper {
    static id instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}


-(NSString *)getVersionCode
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
}


-(NSString *)getIDFA
{
    NSString *uuid = [SAMKeychain passwordForService:KEYCHAIN_UUID_SERVICE account:KEYCHAIN_ACCOUNT];
    if([self isBlankString:uuid])
    {
        Boolean on = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
        if (on==NO) {
            //随机uuid
            uuid =  [self generateRandomUUID];
        }else {
            //获取idfa
            uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
        //存储
        [SAMKeychain setPassword:uuid forService:KEYCHAIN_UUID_SERVICE account:KEYCHAIN_ACCOUNT];
       
    }
     return uuid;
}

-(NSString *)generateRandomUUID{
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);

    return [uuid lowercaseString];
    
}


-(NSString *)getCountry
{
    return [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] uppercaseString];
}

-(BOOL)isVPN
{
    BOOL flag = NO;
    NSString *version = [UIDevice currentDevice].systemVersion;
    // need two ways to judge this.
    if (version.doubleValue >= 9.0)
    {
        NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
        NSArray *keys = [dict[@"__SCOPED__"] allKeys];
        for (NSString *key in keys) {
            if ([key rangeOfString:@"tap"].location != NSNotFound ||
                [key rangeOfString:@"tun"].location != NSNotFound ||
                [key rangeOfString:@"ipsec"].location != NSNotFound ||
                [key rangeOfString:@"ppp"].location != NSNotFound){
                flag = YES;
                break;
            }
        }
    }

    return flag;
}

-(BOOL)isAgency
{
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        //没有设置代理
        return NO;
    }else{
        //设置代理了
        return YES;
    }
}

-(void)sendEmail:(NSString *)mail withTitle:(NSString *)title withContent:(NSString *)content
{
    //创建可变的地址字符串对象：
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    //添加收件人：
    NSArray *toRecipients = @[mail];
    // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
    [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
    //添加抄送人：
    NSArray *ccRecipients = @[@""];
    [mailUrl appendFormat:@"?cc=%@", ccRecipients[0]];
    // 添加密送人：
    NSArray *bccRecipients = @[@""];
    [mailUrl appendFormat:@"&bcc=%@", bccRecipients[0]];
    
    //添加邮件主题和邮件内容：
    [mailUrl appendString:[NSString stringWithFormat:@"&subject=%@",title]];
    [mailUrl appendString:[NSString stringWithFormat:@"&body=%@",content]];
    //打开地址，这里会跳转至邮件发送界面：
    NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
}




 - (BOOL) isBlankString:(NSString *)string {

    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


@end
