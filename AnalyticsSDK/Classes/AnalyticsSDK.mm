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

-(void)beginTask
{
    _task = [[ZZAnalyticsTask alloc] init];
    [_task begin];
    
}

-(void)applicationDidBecomeActive
{
    NSLog(@"BecomeActive");
}

-(void)applicationEnterBackground
{
    NSLog(@"EnterBackground");
}

+(void)initWithAppkey:(NSString *)appkey andIsDebug:(BOOL)debug andIsCN:(BOOL)isCN
{
    [ZZBaseHelper defaultBaseHelper].appkey = appkey;
    [ZZBaseHelper defaultBaseHelper].cn = isCN;
    [ZZBaseHelper defaultBaseHelper].debug = debug;
    
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




@end


