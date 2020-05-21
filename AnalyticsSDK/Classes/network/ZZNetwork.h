//
//  ZZNetwork.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/19.
//  Copyright © 2020 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZZNetworkDelegate <NSObject>


/// 加密
/// @param input <#input description#>
-(NSString *)encrypt:(NSString *)input;


/// 解密
/// @param input <#input description#>
-(NSString *)decrypt:(NSString *)input;


/// 获取请求链接
-(NSString *)getUrl;


@end

@interface ZZNetwork : NSObject

@property (nonatomic,weak)id<ZZNetworkDelegate> delegate;

-(void)postRequest:(NSDictionary *)requestData withCompleteHandler:(ZZConnectionHandler)completeHandler;

@end

NS_ASSUME_NONNULL_END
