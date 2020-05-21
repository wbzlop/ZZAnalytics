//
//  XZZBaseObject.h
//  XZZStrategySDK
//
//  Created by zhouhaoran on 2018/8/21.
//  Copyright © 2018年 zhouhaoran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZBaseObject : NSObject

/**
 *  @author 许辉泽, 15-11-18 21:11:24
 *
 *  从json字符串里面初始化该对象
 *
 *  @param jsString json字符串
 *
 *  @return 生成的对象
 *
 *  @since 1.0.0
 */
-(instancetype _Nullable)initWithJsonString:(NSString* _Nonnull)jsString;
/**
 *  @author 许辉泽, 15-11-18 21:11:29
 *
 *  从字典里面初始化该对象
 *
 *  @param dictionary 字典
 *
 *  @return 生成的对象
 *
 *  @since 1.0.0
 */
- (id _Nullable)initWithDictionary:(NSDictionary * _Nonnull)dictionary;
/**
 *  @author 许辉泽, 15-11-18 21:11:58
 *
 *  将该对象转成字典
 *
 *  @return 转成字典
 *
 *  @since 1.0.0
 */
- (NSDictionary *_Nonnull)objectToDictionary;

/**
 *  @author 许辉泽, 15-11-14 00:11:44
 *
 *  转成json字符串
 *
 *
 *  @return json字符串
 *
 *  @since 1.0.0
 */
-( NSString* _Nullable)toJsonString;
/**
 *  @author 许辉泽, 15-11-18 22:11:37
 *
 *  用字典里面的值创建一个实例
 *
 *  @param dictionary 字典
 *
 *  @return  对象
 *
 *  @since 1.0.0
 */
+ (id _Nullable)objectWithDictionary:(NSDictionary * _Nonnull)dictionary;

/**
 *  @author 许辉泽, 15-11-18 21:11:21
 *
 *  将字典数组转成对象数组
 *
 *  @param array 字典数组
 *
 *  @return 对象数组
 *
 *  @since 1.0.0
 */
+ (NSArray<__kindof ZZBaseObject*> *_Nonnull)objectsWithArray:(NSArray<NSDictionary*> *_Nonnull)array;
/**
 *  @author 许辉泽, 15-11-18 21:11:00
 *
 *  将对象数组转成字典数组
 *
 *  @param array 对象数组
 *
 *  @return 字典数组
 *
 *  @since 1.0.0
 */
+ (NSArray<NSDictionary*> *_Nonnull)objectsWithArrayToDictionary:(NSArray<__kindof ZZBaseObject*> *_Nonnull)array;

/**
 @param dic 字典
 @return json字符串
 */
+(NSString*_Nullable)toJsonString:(NSDictionary*_Nonnull)dic;

/**
 JSON字符串转成字典
 
 @param jsonString json字符串
 @return 字典
 */
+(NSDictionary*_Nullable)toDictionary:(NSString*_Nonnull)jsonString;

/**
 字典数组转成json字符串
 
 @param array 字典数组
 @return json字符串
 */
+(NSString*_Nullable)toJsonStringWithArray:(NSArray <NSDictionary *>*_Nullable)array;

/**
 json字符串转成数组
 
 @param jsonString jsonString
 @return 数组
 */
+(NSArray*_Nullable)toArrayWithJsonString:(NSString *_Nonnull)jsonString;

/**
 *_Nullable  @author 许辉泽, 15-11-18 21:11:53
 *
 *
 *  @param propertyName 该类的字段名
 *  @param dic          最顶层的字典
 *
 *  @return             对应的类型
 *
 *  @since 1.0.0
 */
- (Class _Nullable)propertyClassName:(NSString *_Nonnull)propertyName inDic:(NSDictionary*_Nonnull)dic;

/**
 解决模型在字典里找不到对应key的问题,比较服务器下发了某些关键字作为key,但是客户端模型不能使用该关键字作为属性的情况
 
 @param propertyKey 在字典找不到对应key的属性
 @param dic 字典
 @return 字典里面和该property 对应的key
 */
-(NSString*_Nullable)resloveProperty:(NSString*_Nonnull)propertyKey inDic:(NSDictionary*_Nonnull)dic;

@end
