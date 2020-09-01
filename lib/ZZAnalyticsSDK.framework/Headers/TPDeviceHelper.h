//
//  TPDeviceHelper.h
//  Unity-iPhone
//
//  Created by wbz on 2020/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TPDeviceHelper : NSObject

+(instancetype)defaultHelper;


-(NSString *)getVersionCode;

/// 国家
-(NSString *)getCountry;

/// idfa
-(NSString *)getIDFA;


-(void)getIDFA:(void(^)(NSString *idfa))callback;

/// 自动
-(NSString *)getCustomID;


/// 是否开启vpn
-(BOOL)isVPN;


/// 是否开启代理
-(BOOL)isAgency;

-(void)sendEmail:(NSString *)mail withTitle:(NSString*)title withContent:(NSString*)content;



@end

NS_ASSUME_NONNULL_END
