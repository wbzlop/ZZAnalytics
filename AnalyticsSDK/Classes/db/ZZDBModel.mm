//
//  ZZDBModel.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/28.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ZZDBModel.h"



@implementation ZZDBModel

WCDB_IMPLEMENTATION(ZZDBModel)

WCDB_SYNTHESIZE(ZZDBModel, body)
WCDB_SYNTHESIZE(ZZDBModel, localID)
WCDB_SYNTHESIZE(ZZDBModel, createTime)
WCDB_SYNTHESIZE(ZZDBModel, retry)

WCDB_PRIMARY_AUTO_INCREMENT(ZZDBModel, localID)

WCDB_INDEX(ZZDBModel, "_index", createTime)
@end
