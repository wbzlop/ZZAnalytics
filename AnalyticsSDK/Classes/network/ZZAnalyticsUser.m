//
//  ZZAnalyticsUser.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/20.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ZZAnalyticsUser.h"
#import "ZZBodyHelper.h"
#import "NSString+AES.h"
@implementation ZZAnalyticsUser


+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

#pragma mark Public
-(void)track:(NSString *)configVersion withName:(NSString *)name withValue:(NSString *)value withId:(NSString *)Id withStatus:(NSUInteger)status withMsg:(nonnull NSString *)msg withInfo:(NSString *)info
{
    NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:configVersion withName:name withValue:value withId:Id withStatus:status withMsg:msg withInfo:info];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@"ods_common" forKey:@"dbName"];
    [postDict setValue:@"ods_common_user_event_1" forKey:@"tblName"];
    [postDict setValue:@(ZZSDK_DataVersion) forKey:@"tblVersion"];
    [postDict setValue:body forKey:@"logData"];
    
    [self.network postRequest:postDict withCompleteHandler:^(NSURLSessionDataTask *task, BOOL success, NSError *error, NSString *returnString) {
        
    }];
}

#pragma mark Private

-(ZZNetwork *)network
{
    if(_network == nil)
    {
        _network = [[ZZNetwork alloc] init];
        _network.delegate = self;
    }
    
    return _network;
}


#pragma mark NetworkDelegate
-(NSString *)getUrl
{
    return [[ZZBaseHelper defaultBaseHelper] cn]?ZZSDK_CN_URL:ZZSDK_US_URL;
}

-(NSString *)encrypt:(NSString *)input
{
    return [input encryptWithAES];

}

-(NSString *)decrypt:(NSString *)input
{
    return [input decryptWithAES];
}

@end
