//
//  AnalyticsSDK.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/18.
//  Copyright © 2020年 zhizhen. All rights reserved.
//

#import "AnalyticsSDK.h"

#import "ZZBodyHelper.h"
#import "ZZNetwork.h"
#import "ZZAnalyticsUser.h"

#import "ZZAnalyticsBase.h"
#import "ZZDBHelper.h"
#import "ZZDBModel.h"
#import "ZZAnalyticsTask.h"


@interface AnalyticsSDK()


@property (nonatomic,assign)BOOL initComplete;
@property (nonatomic,retain)ZZAnalyticsTask *task;
@property (nonatomic,assign)NSTimeInterval enterTimer;

@end

@implementation AnalyticsSDK

+(instancetype)defaultSDK
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(void)addObserver
{
    // 进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

    // 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
  
}


-(void)applicationDidBecomeActive
{
//    NSLog(@"BecomeActive");
    _enterTimer = [[[ZZBaseHelper defaultBaseHelper] getLocalTime] timeIntervalSinceNow];

    
    [[ZZAnalyticsUser shareInstance] track:nil withName:@"app_front" withValue:@"8" withId:nil withStatus:1 withMsg:nil withInfo:nil];
}

-(void)applicationEnterBackground
{
//    NSLog(@"EnterBackground");
    
    NSTimeInterval now = [[[ZZBaseHelper defaultBaseHelper] getLocalTime] timeIntervalSince1970];
    
    NSMutableDictionary<NSString *,NSString*> *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%f",_enterTimer]  forKey:@"entry_time"];
    [dict setValue:[NSString stringWithFormat:@"%f",now]  forKey:@"departure_time"];
    
    [[ZZAnalyticsUser shareInstance] track:nil withName:@"app_exit" withValue:@"9" withId:nil withStatus:1 withMsg:nil withInfo:nil];
}


-(void)beginTask
{
    _task = [[ZZAnalyticsTask alloc] init];
    [_task begin];
    
    [[ZZAnalyticsUser shareInstance] track:nil withName:@"app_open" withValue:@"4" withId:nil withStatus:1 withMsg:nil withInfo:nil];
    
}




+(void)initWithAppkey:(NSString *)appkey printLog:(BOOL)printLog andIsCN:(BOOL)isCN
{
    NSLog(@"Init ZZAnalyticsSDK , APPKEY:%@ ,isCN:%d",appkey,isCN);
    
    [ZZBaseHelper defaultBaseHelper].appkey = appkey;
    [ZZBaseHelper defaultBaseHelper].cn = isCN;
    [ZZBaseHelper defaultBaseHelper].debug = printLog;
    
    [[AnalyticsSDK defaultSDK] addObserver];
    
    [[AnalyticsSDK defaultSDK] beginTask];
    
    [[ZZAnalyticsBase shareInstance] track];
 
}



+(void)setUK:(NSString *)uk
{
    [ZZBaseHelper defaultBaseHelper].uk = uk;
}

+(void)setChannel:(NSString *)channel
{
    [ZZBaseHelper defaultBaseHelper].channel = channel;
}


+(void)trackWithName:(NSString *)name eventValue:(NSString *)value eventId:(NSString *)eventId eventConfigVersion:(NSString *)configVersion enentInfo:(NSDictionary *)info
{

    NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:configVersion withName:name withValue:value withId:eventId withStatus:1 withMsg:nil withInfo:info];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}

+(void)trackWithName:(NSString *)name
{
    
    NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:name withValue:nil withId:nil withStatus:1 withMsg:nil withInfo:nil];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}

+(void)trackWithName:(NSString *)name eventInfo:(NSDictionary *)info
{
       NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:name withValue:nil withId:nil withStatus:1 withMsg:nil withInfo:info];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}

+(void)trackWithName:(NSString *)name eventValue:(NSString *)value
{
        NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:name withValue:value withId:nil withStatus:1 withMsg:nil withInfo:nil];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}

@end


