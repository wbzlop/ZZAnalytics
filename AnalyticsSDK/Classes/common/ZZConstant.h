//
//  ZZConstant.h
//  zzmediation
//
//  Created by zhouhaoran on 2018/11/20.
//  Copyright © 2018年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZConstant : NSObject
//SDK版本号
extern NSString* const ZZSDK_VersionString;
//SDK版本号
extern NSString* const ZZSDK_VersionCode;
//服务版本号
extern int const ZZSDK_ServiceVersion;
//数据版本号
extern int const ZZSDK_DataVersion;


//国内加密key
extern NSString* const ZZSDK_CN_KEY;
//国内域名
extern NSString* const ZZSDK_CN_URL;

//国外加密key
extern NSString* const ZZSDK_US_KEY;
//国外j域名
extern NSString* const ZZSDK_US_URL;

//加密偏移量
extern NSString* const ZZSDK_OFFSET;
//大数据appkey
extern NSString* const ZZSDK_APPKEY;

//90-4表名
extern NSString* const ZZSDK_TABLE_USER;
//90-5表名
extern NSString* const ZZSDK_TABLE_BASE;



@end

NS_ASSUME_NONNULL_END
