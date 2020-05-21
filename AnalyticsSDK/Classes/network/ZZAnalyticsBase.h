//
//  ZZAnalyticsBase.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/20.
//  Copyright © 2020 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZNetwork.h"
NS_ASSUME_NONNULL_BEGIN


/// 用户操作事件协议 http://wiki.batcloud.cn/pages/viewpage.action?pageId=16680484
/// 90-4
@interface ZZAnalyticsBase : NSObject<ZZNetworkDelegate>

@property (nonatomic,retain)ZZNetwork *network;

+(instancetype)shareInstance;

/// 统计用户基本信息
-(void)track;


@end

NS_ASSUME_NONNULL_END
