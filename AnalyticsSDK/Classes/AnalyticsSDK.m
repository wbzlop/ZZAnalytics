//
//  AnalyticsSDK.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/18.
//  Copyright © 2020年 zhizhen. All rights reserved.
//

#import "AnalyticsSDK.h"
#import "ZZPromise.h"
#import "ZZBodyHelper.h"
#import "ZZNetwork.h"
#import "ZZAnalyticsUser.h"

#import "ZZAnalyticsBase.h"

@interface AnalyticsSDK()

@property (nonatomic,strong)ZZPromise *promise;
@property (nonatomic,assign)BOOL initComplete;

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


-(void)applicationBecomeActive
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


+(void)load{
  
    NSMutableDictionary<NSString *,NSString *> *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"2" forKey:@"1"];


//    [[ZZAnalyticsUser shareInstance] track:nil withName:@"testevent" withValue:@"value" withId:nil withStatus:1 withMsg:nil withInfo:[[ZZBaseHelper defaultBaseHelper] convertToJsonData:dict]];
    
    
   
    
}

@end


