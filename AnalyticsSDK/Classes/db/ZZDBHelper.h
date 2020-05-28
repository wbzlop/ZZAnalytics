//
//  ZZDBHelper.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/28.
//  Copyright © 2020 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
#import "ZZDBModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZZDBHelper : NSObject

@property(nonatomic,retain)WCTDatabase *database;

+(instancetype)shareInstance;

-(void)addToTable:(NSString *)table content:(NSString *)content;

-(NSArray<ZZDBModel *> *)getFromTable:(NSString *)table;

-(void)deleteFromTable:(NSString *)table limit:(NSInteger )limit;

@end

NS_ASSUME_NONNULL_END
