//
//  LFCache.h
//  zzmediation
//
//  Created by zhouhaoran on 2018/11/20.
//  Copyright © 2018年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZBaseObject.h"
NS_ASSUME_NONNULL_BEGIN


@interface ZZCache : ZZBaseObject
/**
 *二级缓存的一个简单实现,目前仅支持缓存字符串,后续替换成第三方缓存库
 *
 */
+ (instancetype)defaultCache;

-(NSString*)getStringForKey:(NSString*)key;

-(void)cacheObj:(NSString*)jsonStringOfObj forKey:(NSString*)key;

-(void)clearCacheForKey:(NSString*)key;
-(void)clearAll;
/**
 缓存对象
 
 @param jsonStringOfObj 要缓存的值
 @param key 对应的key
 @param writeToDisk 是否写入磁盘
 */
-(void)cacheObj:(NSString *)jsonStringOfObj forKey:(NSString *)key bothDisk:(BOOL)writeToDisk;

@end

NS_ASSUME_NONNULL_END
