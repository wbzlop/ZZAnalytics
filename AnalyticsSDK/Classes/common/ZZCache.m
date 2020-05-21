//
//  LFCache.m
//  zzmediation
//
//  Created by zhouhaoran on 2018/11/20.
//  Copyright © 2018年 zero. All rights reserved.
//

#import "ZZCache.h"
@interface ZZCache ()

@property(nonatomic)NSCache<NSString*,NSString*> *memoryCache;
@property(nonatomic)NSUserDefaults *diskCache;

@end
@implementation ZZCache

+ (instancetype)defaultCache {
    static id instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(instancetype)init{
    
    if(self=[super init]){
        
        [self commonInitialization];
        
        return self;
    }
    
    return nil;
}

-(void)commonInitialization{
    
    _memoryCache=[NSCache new];
    _diskCache=[[NSUserDefaults alloc]initWithSuiteName:@"com.lf.business.sdk"];
    
}

-(NSString*)getStringForKey:(NSString*)key{
    
    NSString *valueInMemoryCache=[_memoryCache objectForKey:key];
    
    if(valueInMemoryCache){
        
        return valueInMemoryCache;
    }else{
        
        NSString *valueInDisk=[self innerRedFromDisk4Key:key];
        
        if(valueInDisk){
            
            [_memoryCache setObject:valueInDisk forKey:key];
            
            return valueInDisk;
        }
        
    }
    
    
    return nil;
    
}

-(void)clearCacheForKey:(NSString*)key {
    
    [_memoryCache removeObjectForKey:key];
    [_diskCache removeObjectForKey:key];
    
}

-(void)clearAll{
    
    [_memoryCache removeAllObjects];
    NSDictionary *dic = [ _diskCache dictionaryRepresentation ];
    for(NSString *key in [dic allKeys]){
        [_diskCache removeObjectForKey:key];
    }
    [_diskCache synchronize];
    
}

-(void)cacheObj:(NSString*)jsonStringOfObj forKey:(NSString*)key{
    
    [self cacheObj:jsonStringOfObj forKey:key bothDisk:YES];
}

-(void)cacheObj:(NSString *)jsonStringOfObj forKey:(NSString *)key bothDisk:(BOOL)writeToDisk{
    
    if(!jsonStringOfObj) return ;
    
    [_memoryCache setObject:jsonStringOfObj forKey:key];
    
    if(writeToDisk==NO)return;
    
    [self innerWrite2Disk:jsonStringOfObj forKey:key];
    
    BOOL syncSucces=[_diskCache synchronize];
    if (!syncSucces) {
        
        NSLog(@"缓存数据失败 key:%@ value:%@",key,jsonStringOfObj);
    }
    
}


/**
 从磁盘中读取数据并进行base64解码
 
 @param key 键
 @return    值
 */
-(NSString*) innerRedFromDisk4Key:(NSString*)key{
    
    NSString *encodedString=[_diskCache stringForKey:key];
    
    if(!encodedString) return nil;
    
    NSData *data=[[NSData alloc]initWithBase64EncodedString:encodedString options:0];
    
    NSString *decodedString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return decodedString;
}


/**
 将数据写入磁盘并进行base64编码
 
 @param value 值
 @param key 键
 */
-(void) innerWrite2Disk:(NSString*) value forKey:(NSString*)key{
    
    NSData *data=[value dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedString=[data base64EncodedStringWithOptions:0];
    
    [_diskCache setObject:encodedString forKey:key];
    
}

@end
