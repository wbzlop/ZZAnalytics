//
//  ZZDBModel.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/28.
//  Copyright © 2020 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZZDBModel : NSObject<WCTTableCoding>


/// 数据
@property(nonatomic,copy)NSString *body;

/// 重试次数
@property(nonatomic,assign)int retry;

/// 时间
@property(nonatomic,retain)NSDate *createTime;
@property(nonatomic,assign)int localID;

WCDB_PROPERTY(localID)
WCDB_PROPERTY(body)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(retry)

@end

NS_ASSUME_NONNULL_END
