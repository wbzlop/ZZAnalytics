//
//  NSDictionary+Log.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/19.
//  Copyright © 2020 zz. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary(Log)

- (NSString *)description
{
    NSMutableString *strM = [NSMutableString stringWithString:@"\n{"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            [strM appendFormat:@" %@ = %@\n", key, obj];
        }
        else
        {
            [strM appendFormat:@" %@ = %@\n", key, [obj description]];
        }
    }];
    [strM appendString:@"}"];
    return strM;
}

@end
