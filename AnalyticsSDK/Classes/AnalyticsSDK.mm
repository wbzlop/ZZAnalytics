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
@interface AnalyticsSDK()


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
    
    [[ZZAnalyticsBase shareInstance] track];
    
    [[ZZDBHelper shareInstance] addToTable:ZZSDK_TABLE_USER content:@"1111"];
    
    NSArray<ZZDBModel *> *models = [[ZZDBHelper shareInstance] getFromTable:ZZSDK_TABLE_USER];
    
    for (ZZDBModel *model in models) {
        NSLog(@"数据库：%@",model.createTime);
    }
    
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
  

   
    
}

@end


