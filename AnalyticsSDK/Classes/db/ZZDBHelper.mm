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
    model.createTime = [NSDate date];
    model.isAutoIncrement = YES;
    [self.database insertObject:model into:table];
}

-(NSArray<ZZDBModel *> *)getFromTable:(NSString *)table
{
    NSArray<ZZDBModel *> *models = [self.database getObjectsOfClass:ZZDBModel.class
    fromTable:table
      limit:100];
    return models;
}

-(void)deleteFromTable:(NSString *)table limit:(NSInteger)limit
{
    
}




@end
