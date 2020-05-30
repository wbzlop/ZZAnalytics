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
@property (nonatomic,assign) BOOL first;
@end

@implementation ZZAnalyticsTask
{
    NSString * lineDelimiter;
    
}

-(void)begin
{
    _first = YES;
    __weak ZZAnalyticsTask* weakSelf = self;
    lineDelimiter =[NSString stringWithFormat:@"%C", 0x0002];
    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
       
        //删除失效数据
        if(!weakSelf.first)
        {
            [[ZZDBHelper shareInstance] deleteInvalidData];
            [weakSelf analyticsTask];
        }
        else
        {
            weakSelf.first = NO;
        }
        
      
    });
    dispatch_resume(_timer);
}

-(void)analyticsTask
{
    [self trackUserEvent:0];
}


/// 批量上报用户行为
-(void)trackUserEvent:(NSInteger)offset
{
    
    NSArray<ZZDBModel *> *models = [[ZZDBHelper shareInstance] getFromTable:ZZSDK_TABLE_USER offset:offset];
    if([models count] != 0)
    {
        NSMutableArray *bodyArr = [NSMutableArray array];
        for (ZZDBModel *model in models) {
            [bodyArr addObject:model.body];
        }
        NSLog(@"批量======90-5=======\n%@",[bodyArr componentsJoinedByString:@"\n"]);
        __weak ZZAnalyticsTask* weakSelf = self;
        [[ZZAnalyticsUser shareInstance] track:[bodyArr componentsJoinedByString:lineDelimiter] complete:^(BOOL success) {
           if(!success)
           {
               //失败则重试次数+1
               [[ZZDBHelper shareInstance] increaseRetry:models inTable:ZZSDK_TABLE_USER];
                [weakSelf trackUserEvent:[models count]];
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
        [self trackBaseEvent:0];
    }
        
        
}
/// 批量上报基本信息
-(void)trackBaseEvent:(NSInteger)offset
{
    NSArray<ZZDBModel *> *models = [[ZZDBHelper shareInstance] getFromTable:ZZSDK_TABLE_BASE offset:offset];
    if([models count] != 0)
    {
        NSMutableArray *bodyArr = [NSMutableArray array];
        for (ZZDBModel *model in models) {
            [bodyArr addObject:model.body];
        }
         __weak ZZAnalyticsTask* weakSelf = self;
        NSLog(@"批量======90-4=======\n%@",[bodyArr componentsJoinedByString:@"\n"]);
        [[ZZAnalyticsBase shareInstance] track:[bodyArr componentsJoinedByString:lineDelimiter] complete:^(BOOL success) {

            if(!success)
            {
                //失败则重试次数+1
                [[ZZDBHelper shareInstance] increaseRetry:models inTable:ZZSDK_TABLE_BASE];
                [weakSelf trackBaseEvent:[models count]];
            }
            else
            {
                //成功则从数据库删除
                [[ZZDBHelper shareInstance] deleteFromTable:ZZSDK_TABLE_BASE limit:[models count]];
                [weakSelf trackBaseEvent:0];
            }
            
        }];
    }
}





@end
