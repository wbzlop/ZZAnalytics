//
//  ZZDBHelper.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/28.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ZZDBHelper.h"
#import <WCDB/WCDB.h>
#import "ZZDBModel.h"



@implementation ZZDBHelper



+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (WCTDatabase *)database {
    static WCTDatabase *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        db = [[WCTDatabase alloc] initWithPath:[docDir stringByAppendingPathComponent:@"ZZDB"]];
        if ([db canOpen]) {
            [db createTableAndIndexesOfName:ZZSDK_TABLE_BASE withClass:[ZZDBModel class]];
            [db createTableAndIndexesOfName:ZZSDK_TABLE_USER withClass:[ZZDBModel class]];
        }
    });
    _database = db;
    return _database;
}

-(void)addToTable:(NSString *)table content:(NSString *)content
{

    ZZDBModel *model = [[ZZDBModel alloc] init];
    model.body = content;
    model.createTime = [self getLocalDate];
    model.retry = 1;
    model.isAutoIncrement = YES;
    [self.database insertObject:model into:table];
}

-(NSArray<ZZDBModel *> *)getFromTable:(NSString *)table offset:(NSInteger)offset
{
    NSArray<ZZDBModel *> *models = [self.database getObjectsOfClass:ZZDBModel.class fromTable:table limit:100 offset:offset];
    

    return models;
}

-(void)deleteFromTable:(NSString *)table limit:(NSInteger)limit
{
    [self.database deleteObjectsFromTable:table limit:limit];
}



-(void)increaseRetry:(NSArray<ZZDBModel *> *)models inTable:(NSString *)table
{
    if(models != nil)
    {
        for (ZZDBModel *model in models) {
            model.retry++;
            [self.database updateRowsInTable:table onProperties:ZZDBModel.retry withObject:model where:ZZDBModel.localID == model.localID];
        }

    }
}

-(void)deleteInvalidData
{
    //超过24小时 重试超过5次 的数据丢弃
    NSDate *invalidDate = [[NSDate alloc] initWithTimeInterval:-(24 * 60 * 60) sinceDate:[self getLocalDate]];
    [self.database deleteObjectsFromTable:ZZSDK_TABLE_USER where:ZZDBModel.retry > 5 or ZZDBModel.createTime < invalidDate ];
}


-(NSDate *)getLocalDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date dateByAddingTimeInterval: interval];
}

@end
