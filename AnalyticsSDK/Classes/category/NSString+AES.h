//
//  NSString+AES.h
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/19.
//  Copyright © 2020 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(AES)

/**< 加密方法 */
- (NSString*)encryptWithAES;

/**< 解密方法 */
- (NSString*)decryptWithAES;

@end

NS_ASSUME_NONNULL_END
