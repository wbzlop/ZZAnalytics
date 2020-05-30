//
//  ZZEnums.h
//  heyzapDemo
//
//  Created by wbz on 2018/11/20.
//  Copyright © 2018年 zero. All rights reserved.
//

#ifndef ZZEnums_h
#define ZZEnums_h

typedef NS_ENUM(NSUInteger, ZZAdType) {
    AdTypeInterstitial=0,
    AdTypeReward=1,
    AdTypeNative=3,
    AdTypeBanner=4
};

//操作类型
typedef NS_ENUM(NSInteger, ZZAdOpetateType) {
    ZZAdOpetateTypeNone = 0,
    ZZAdOpetateTypeRequest=1, // 广告请求
    ZZAdOpetateTypeFilled=2, // 广告填充
    ZZAdOpetateTypeShowed=3, // 广告展示
    ZZAdOpetateTypeClicked=4, // 广告点击
};

//操作结果
typedef NS_ENUM(NSInteger, ZZAdOpetateResult) {
    ZZAdOpetateResultFailed=0, // 未成功
    ZZAdOpetateResultSuccess=1, // 成功
};

//广告源
typedef NS_ENUM(NSInteger, ZZAdSourceType) {
    ZZAdSourceTypeNone=0,
    ZZAdSourceTypeAdmob=1,
    ZZAdSourceTypeMopub=2,
    ZZAdSourceTypeFB=3,
    ZZAdSourceTypeBat=4,
    ZZAdSourceTypeApplovin=5,
    ZZAdSourceTypeIronSource=6,
    ZZAdSourceTypeUnity=7,
    ZZAdSourceTypeDisplay=8,
    ZZAdSourceTypeTCASH=9,
    ZZAdSourceTypeH5=10
};

//行为类型
typedef NS_ENUM(NSInteger, ZZActionType) {
    ZZActionTypeNone=0,
    ZZActionTypeShow=1,
    ZZActionTypeClick=2,
    ZZActionTypeUndefine=3,
    ZZActionTypeOpen=4,
    ZZActionTypeLogin=5,
    ZZActionTypeExit=6,
    ZZActionTypeRegister=7,
    ZZActionTypeEnterForeground=8,
    ZZActionTypeEnterBackground=9,
};


//行为结果
typedef NS_ENUM(NSInteger, ZZActionResult) {
    ZZActionResultFailed=0,
    ZZActionResultSuccess=1,
};

//网络请求类型
typedef NS_ENUM(NSInteger, ZZRequestHandleType) {
    ZZRequestHandlNone = 0,// 无处理
    ZZRequestHandlGzip = 1, //gzip压缩
    ZZRequestHandlGzipAndBase64 = 2, //gzip压缩+Base64加密
};


typedef NS_ENUM(NSUInteger,ZZStrategyType) {
    ZZStrategyTypeForAd = 0,//广告策略
    ZZStrategyTypeForIAP = 1,//内购策略
    ZZStrategyTypeForTiming = 2,//定时奖励策略
    ZZStrategyTypeForFeedback = 3,//评分引导
    ZZStrategyTypeForAppGuide = 4,//app 引流
};

//网络请求回调
typedef void (^ZZConnectionHandler)(NSURLSessionDataTask *task, BOOL success, NSError *error, NSString *returnString);

//网络请求回调
typedef void (^LFMCompleteHandler)(BOOL success, NSError *error, NSData *data);

typedef void(^ManagerInitComplete)(BOOL success,NSError *error);

typedef void (^TrackComplete)(BOOL success);

#endif /* ZZEnums_h */
