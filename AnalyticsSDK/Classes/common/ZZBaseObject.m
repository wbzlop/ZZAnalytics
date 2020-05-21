//
//  XZZBaseObject.m
//  XZZStrategySDK
//
//  Created by zhouhaoran on 2018/8/21.
//  Copyright © 2018年 zhouhaoran. All rights reserved.
//

#import "ZZBaseObject.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation ZZBaseObject

+ (id)objectWithDictionary:(NSDictionary *)dictionary
{
    if(!dictionary) return nil;
    
    Class objClass = [self class];
    
    assert([objClass isEqual:[ZZBaseObject class]] == NO);
    
    ZZBaseObject *object = nil;
    
    if (objClass) {
        
        object = [[objClass alloc] initWithDictionary:dictionary];
    } else {
        
        NSLog(@"Unknown class:%@", NSStringFromClass(objClass));
    }
    
    return object;
}

+ (NSArray<ZZBaseObject*> *)objectsWithArray:(NSArray<NSDictionary*> *)array
{
    Class objClass = [self class];
    
    assert([objClass isEqual:[ZZBaseObject class]]==NO);
    
    ZZBaseObject *object = nil;
    
    NSMutableArray *objArray = nil;
    
    if (objClass) {
        
        objArray = [NSMutableArray new];
        
        for (NSDictionary *dictionary in array) {
            
            object = [[objClass alloc] initWithDictionary:dictionary];
            
            [objArray addObject:object];
        }
    } else {
        
        NSLog(@"Unknown class:%@", NSStringFromClass(objClass));
    }
    
    return objArray;
}

+ (NSArray<NSDictionary*> *)objectsWithArrayToDictionary:(NSArray<ZZBaseObject*> *)array
{
    Class objClass = [self class];
    
    assert((objClass==[ZZBaseObject class])== NO);
    
    NSDictionary *object = nil;
    
    NSMutableArray *objArray = [NSMutableArray new];
    
    if (objClass) {
        
        for (ZZBaseObject *obj in array) {
            
            object = [obj objectToDictionary];
            
            [objArray addObject:object];
        }
    } else {
        
        NSLog(@"Unknown class:%@", objClass);
    }
    
    return objArray;
}



- (id)initWithDictionary:(NSDictionary *)dictionary
{
    NSArray *propertyArray = lfGetPropertyNameList(self);
    
    for (NSString *key in propertyArray) {
        
        //获取该key 所对应值的类型
        
        Class tmpClass = [self propertyClassName:key inDic:dictionary];
        if (tmpClass==nil) {
            
            NSString *resolvedKey=[self resloveProperty:key inDic:dictionary];
            id value=dictionary[resolvedKey];
            
            [self setValue:value forKey:key];
            
        }else{
            id value=dictionary[key];
            
            if (!value) {
                
                continue;
            }
            //目前仅支持嵌套数组
            if ([value isKindOfClass:[NSArray class]]) {
                
                NSArray *array = [tmpClass objectsWithArray:value];
                
                [self setValue:array forKey:key];
                
            } else{
                id parseValue = [tmpClass objectWithDictionary:value];
                
                assert(parseValue);
                
                [self setValue:parseValue forKey:key];
            }
        }
        
        
    }
    
    return self;
}

-(void)setNilValueForKey:(NSString *)key {
    
    //    NSLog(@"key=%@的value值为nil", key);
}


NSArray *lfGetPropertyNameList(id object) {
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        
        objc_property_t property = properties[i];
        
        const char *name = property_getName(property);
        
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
        
    }
    
    free(properties);
    
    return propertyNames;
}

- (NSDictionary *)objectToDictionary {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    NSArray* propertyArray = lfGetPropertyNameList(self);
    
    for (NSString *key in propertyArray) {
        
        @try {
            
            id value = [self valueForKey:key];
            
            if (value != nil) {
                
                if ([value isKindOfClass:[NSArray class]]) {
                    
                    Class tmpClass = [self propertyClassName:key inDic:dictionary];
                    
                    NSArray *array = [tmpClass objectsWithArrayToDictionary:value];
                    
                    [dictionary setObject:array forKey:key];
                    
                } else if([value isKindOfClass:[ZZBaseObject class]]){
                    
                    ZZBaseObject *tmp=value;
                    
                    [dictionary setObject:[tmp objectToDictionary] forKey:key];
                    
                }else{
                    
                    NSString *dicKey=[self resloveProperty:key inDic:@{}];
                    if (dicKey) {
                        [dictionary setObject:value forKey:dicKey];
                    }else{
                        
                        [dictionary setObject:value forKey:key];
                    }
                    
                }
            }
        } @catch (NSException *exception) {
            
            NSLog(@"except:%@",key);
        }
    }
    
    return dictionary;
}

#pragma -mark  JSON

-(instancetype)initWithJsonString:(NSString *)jsString{
    
    return [self initWithDictionary:[[self class] toDictionary:jsString]];
}

-(NSString*)toJsonString{
    
    return [[self class] toJsonString:[self objectToDictionary]];
    
}

+(NSDictionary*)toDictionary:(NSString*)jsonString{
    
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return result;
    
}

+(NSString*)toJsonString:(NSDictionary*)dic{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+(NSString *)toJsonStringWithArray:(NSArray<NSDictionary *> *)array {
    
    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array  options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
    
}

+(NSArray *)toArrayWithJsonString:(NSString *)jsonString {
    
    NSError* error;
    NSArray *array = nil;
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        NSLog(@"json字符串为空无法转成数组");
    }else {
        array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    return array;
}

-(Class)propertyClassName:(NSString *)propertyName inDic:(NSDictionary *)dic{
    
    return nil;
    
}

-(NSString *)resloveProperty:(NSString *)propertyKey inDic:(NSDictionary *)dic{
    
    return propertyKey;
    
}

@end
