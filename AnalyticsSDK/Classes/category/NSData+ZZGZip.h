//
//  NSData+XZZGZip.h
//  XZZStrategySDK
//
//  Created by zhouhaoran on 2018/8/21.
//  Copyright © 2018年 zhouhaoran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZZGZip)
- (nullable NSData *)zz_gzippedDataWithCompressionLevel:(float)level;
- (nullable NSData *)zz_gzippedData;
- (nullable NSData *)zz_gunzippedData;
- (BOOL)zz_isGzippedData;
- (nullable NSData *)toGZipCompressData;
@end
