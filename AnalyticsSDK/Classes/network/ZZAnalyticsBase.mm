//
//  ZZAnalyticsBase.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/20.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ZZAnalyticsBase.h"
#import "ZZBodyHelper.h"
#import "NSString+AES.h"
#import "ZZDBHelper.h"
@implementation ZZAnalyticsBase


+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

#pragma mark Public
-(void)track
{
    NSString *body = [[ZZBodyHelper defaultBodyHelper] creatBaseBody];
    
    [self track:body complete:^(BOOL success) {
       
        if(!success)
        {
            //上报失败，存储到数据库
            [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_BASE content:body];
        }
        
    }];
    
}

- (void)track:(NSString *)body complete:(TrackComplete)complete
{
     NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setValue:@"ods_common" forKey:@"dbName"];
    [postDict setValue:@"ods_common_user_base_info_1" forKey:@"tblName"];
    [postDict setValue:@(ZZSDK_DataVersion) forKey:@"tblVersion"];
    [postDict setValue:body forKey:@"logData"];
    
    zz_work_queue_dispatch_async(^(){
        
        
        [self.network postRequest:postDict withCompleteHandler:^(NSURLSessionDataTask *task, BOOL success, NSError *error, NSString *returnString) {
            complete(success);
            if(success)
            {
                NSLog(@"success");
            }
            else
            {
                NSLog(@"failed");
            }
        }];
        
    });
    
    
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
