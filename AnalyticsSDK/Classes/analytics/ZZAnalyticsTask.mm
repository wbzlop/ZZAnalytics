//
//  ZZAnalyticsTask.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/30.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ZZAnalyticsTask.h"
#import "ZZDBHelper.h"
#import "ZZAnalyticsBase.h"
#import "ZZAnalyticsUser.h"
@interface ZZAnalyticsTask()
@property (nonatomic,retain) dispatch_source_t timer;
@property (nonatomic,assign) BOOL running;
@property (nonatomic,assign) BOOL hasPause;
@end

@implementation ZZAnalyticsTask
{
    NSString * lineDelimiter;
    
}

-(void)begin
{
//    _first = YES;
    __weak ZZAnalyticsTask* weakSelf = self;
    lineDelimiter =[NSString stringWithFormat:@"%C", 0x0002];
    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW,2 * 60 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{

//         NSLog(@"时间到，开始批量任务");
//        if(!weakSelf.first)
//        {
            [weakSelf analyticsTask];
//        }
//        else
//        {
//            weakSelf.first = NO;
//        }
       
      
    });
     _hasPause = NO;
    dispatch_resume(_timer);
}

-(void)pause
{
    if (_timer && !_hasPause) {
        _hasPause = YES;
        NSLog(@"批量暂停");
        dispatch_suspend(self.timer);
        
    }
}

-(void)resume
{
    
    if (_timer  && _hasPause) {
        NSLog(@"批量继续");
        _hasPause = NO;
        dispatch_resume(_timer);
        
    }
}

-(void)analyticsTask
{
    if(!_running)
    {
        _running = YES;
        //删除失效数据
         [[ZZDBHelper shareInstance] deleteInvalidData];
        [self trackUserEvent:0];
        
       
    }
    else
    {
        NSLog(@"批量任务正在进行中");
    }
}


/// 批量上报用户行为
-(void)trackUserEvent:(NSInteger)offset
{
    NSLog(@"批量======90-5=======开始====%d",offset);
    NSArray<ZZDBModel *> *models = [[ZZDBHelper shareInstance] getFromTable:ZZSDK_TABLE_USER offset:offset];
    if([models count] != 0)
    {
        NSMutableArray *bodyArr = [NSMutableArray array];
        for (ZZDBModel *model in models) {
            NSString *body = [NSString stringWithFormat:model.body,[ZZBaseHelper defaultBaseHelper].appkey];
            [bodyArr addObject:body];
        }
        NSLog(@"批量======90-5======= %@",[bodyArr componentsJoinedByString:@"[=================]"]);
        __weak ZZAnalyticsTask* weakSelf = self;
        [[ZZAnalyticsUser shareInstance] track:[bodyArr componentsJoinedByString:lineDelimiter] complete:^(BOOL success) {
           if(!success)
           {
               //失败则重试次数+1
               [[ZZDBHelper shareInstance] increaseRetry:models inTable:ZZSDK_TABLE_USER];
                [weakSelf trackUserEvent:[models count] + offset];
           }
            else
            {
                //成功则从数据库删除
                [[ZZDBHelper shareInstance] deleteFromTable:ZZSDK_TABLE_USER limit:[models count]];
                [weakSelf trackUserEvent:0];
            }
            
        }];

    }
    else
    {
        NSLog(@"批量======90-5=======完成");
        [self trackBaseEvent:0];
    }
        
        
}
/// 批量上报基本信息
-(void)trackBaseEvent:(NSInteger)offset
{
    NSLog(@"批量======90-4=======开始");
    NSArray<ZZDBModel *> *models = [[ZZDBHelper shareInstance] getFromTable:ZZSDK_TABLE_BASE offset:offset];
    if([models count] != 0)
    {
        NSMutableArray *bodyArr = [NSMutableArray array];
        for (ZZDBModel *model in models) {
            NSString *body = [NSString stringWithFormat:model.body,[ZZBaseHelper defaultBaseHelper].appkey];
            [bodyArr addObject:body];
        }
         __weak ZZAnalyticsTask* weakSelf = self;
        NSLog(@"批量======90-4======= %@",[bodyArr componentsJoinedByString:@"[=================]"]);
        [[ZZAnalyticsBase shareInstance] track:[bodyArr componentsJoinedByString:lineDelimiter] complete:^(BOOL success) {

            if(!success)
            {
                //失败则重试次数+1
                [[ZZDBHelper shareInstance] increaseRetry:models inTable:ZZSDK_TABLE_BASE];
                [weakSelf trackBaseEvent:[models count] + offset];
            }
            else
            {
                //成功则从数据库删除
                [[ZZDBHelper shareInstance] deleteFromTable:ZZSDK_TABLE_BASE limit:[models count]];
                [weakSelf trackBaseEvent:0];
            }
            
        }];
    }
    else
    {
         NSLog(@"批量======90-4=======完成");
        _running = NO;
        
    }
}





@end
