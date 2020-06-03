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
#import "ZZReachability.h"

@interface AnalyticsSDK()


@property (nonatomic,assign)BOOL initComplete;
@property (nonatomic,retain)ZZAnalyticsTask *task;
@property (nonatomic,assign)NSTimeInterval enterTimer;
@property (nonatomic,retain)ZZReachability *reach;
@property (nonatomic,assign)BOOL canUploadByFront;
@property (nonatomic,assign)BOOL force;
@end

NSString *  const ARCHIVE_KEY_CHANNEL = @"TPSDK_CHANNEL";

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];

    // 即将进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    //监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kZZReachabilityChangedNotification
                                               object: nil];
   
  
}

- (void)reachabilityChanged:(NSNotification *)note {
    
     
    ZZReachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [ZZReachability class]]);
    ZZNetworkStatus status = [curReach currentReachabilityStatus];
 
    //判断网络状体，无网络弹窗提示
    if (status == NotReachable)
    {
       if(self.task != nil)
       {
           [self.task pause];
       }
    }
    else
    {
        [self tryInit];
        
        if(self.task != nil)
        {
            [self.task resume];
        }
    }
}


-(void)applicationDidBecomeActive
{

    _enterTimer = [[NSDate now] timeIntervalSince1970];
    if(_initComplete)
    {
        [[ZZAnalyticsUser shareInstance] track:nil withName:@"app_front" withValue:@"8" withId:nil withStatus:1 withMsg:nil withInfo:nil];
        
        if(_canUploadByFront && self.task != nil && ![self isNotReachable])
        {
//            NSLog(@"回到前台，开始批量任务");
           [self.task analyticsTask];
            
           [self.task resume];
        }
        
        _canUploadByFront = YES;
    }
    else
    {
        
        NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:@"app_front" withValue:@"8" withId:nil withStatus:1 withMsg:nil withInfo:nil];
        [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
        
        

    }
   
    
    
}

-(void)applicationEnterBackground
{

    
    NSTimeInterval now = [[NSDate now] timeIntervalSince1970];

    NSMutableDictionary<NSString *,NSString*> *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%0.f",_enterTimer]  forKey:@"entry_time"];
    [dict setValue:[NSString stringWithFormat:@"%0.f",now]  forKey:@"departure_time"];
    
    NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:@"app_exit" withValue:@"9" withId:nil withStatus:1 withMsg:nil withInfo:dict];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
    
    if(self.task != nil)
    {
        [self.task pause];
    }
    
}


-(void)beginTask
{
    _task = [[ZZAnalyticsTask alloc] init];
    [self.task begin];
    
    [[ZZAnalyticsUser shareInstance] track:nil withName:@"app_open" withValue:@"4" withId:nil withStatus:1 withMsg:nil withInfo:nil];
    
}


-(void)tryInit
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *channel = [userDefault objectForKey:ARCHIVE_KEY_CHANNEL];

    //是否有网络
    if(!_initComplete && [self.reach currentReachabilityStatus] != 0 && (channel != nil || _force))
    {
        [[AnalyticsSDK defaultSDK] beginTask];
        
        [[ZZAnalyticsBase shareInstance] track];
        
        _initComplete = YES;
        
    }

}

-(ZZReachability *)reach
{
    if(_reach == nil)
    {
        _reach = [ZZReachability zzReachabilityForInternetConnection];
           [_reach startNotifier];
    }
    return _reach;
}

-(BOOL)isNotReachable
{
    return [self.reach currentReachabilityStatus] == NotReachable;
}

-(void)checkChannel
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *channel = [userDefault objectForKey:ARCHIVE_KEY_CHANNEL];
    if(channel == nil)
    {
        __weak AnalyticsSDK* weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.force = true;
            [weakSelf tryInit];
        });
    }
}


+(void)initWithAppkey:(NSString *)appkey printLog:(BOOL)printLog andIsCN:(BOOL)isCN
{
    NSLog(@"Init ZZAnalyticsSDK , APPKEY:%@ ,isCN:%d",appkey,isCN);
    
    
    
    [ZZBaseHelper defaultBaseHelper].appkey = appkey;
    [ZZBaseHelper defaultBaseHelper].cn = isCN;
    [ZZBaseHelper defaultBaseHelper].debug = printLog;
    
    [[AnalyticsSDK defaultSDK] addObserver];
    
    [[AnalyticsSDK defaultSDK] tryInit];
    
    [[AnalyticsSDK defaultSDK] checkChannel];
    
 
}


+(void)setUK:(NSString *)uk
{
    [ZZBaseHelper defaultBaseHelper].uk = uk;
}

+(void)setChannel:(NSString *)channel
{
    [ZZBaseHelper defaultBaseHelper].channel = channel;
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:channel forKey:ARCHIVE_KEY_CHANNEL];
    [userDefault synchronize];
    
     [[AnalyticsSDK defaultSDK] tryInit];
}


/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
/// @param eventId 事件ID（可nil）
/// @param configVersion 策略版本（可nil）
/// @param info 事件map（可nil）
+(void)trackWithName:(NSString *)name eventValue:(NSString *)value eventId:(NSString *)eventId eventConfigVersion:(NSString *)configVersion enentInfo:(NSDictionary *)info
{

    NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:configVersion withName:name withValue:value withId:eventId withStatus:1 withMsg:nil withInfo:info];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}


/// 统计事件
/// @param name 事件名
+(void)trackWithName:(NSString *)name
{
    
    NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:name withValue:nil withId:nil withStatus:1 withMsg:nil withInfo:nil];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}


/// 统计事件
/// @param name  事件名
/// @param info 事件map（可nil）
+(void)trackWithName:(NSString *)name eventInfo:(NSDictionary *)info
{
       NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:name withValue:nil withId:nil withStatus:1 withMsg:nil withInfo:info];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}


/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
+(void)trackWithName:(NSString *)name eventValue:(NSString *)value
{
        NSString *body = [[ZZBodyHelper defaultBodyHelper] creatUserBody:nil withName:name withValue:value withId:nil withStatus:1 withMsg:nil withInfo:nil];
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:body];
}

@end


