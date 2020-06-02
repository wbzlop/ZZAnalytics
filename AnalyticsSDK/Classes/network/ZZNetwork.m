//
//  ZZNetwork.m
//  AnalyticsSDK
//
//  Created by wbz on 2020/5/19.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ZZNetwork.h"
#import "NSString+AES.h"

@interface ZZNetwork()<NSURLSessionDelegate>

@property (nonatomic) NSURLSession *session;
@end

/// 基础网络
@implementation ZZNetwork




-(void)postRequest:(NSDictionary *)requestData withCompleteHandler:(ZZConnectionHandler)completeHandler
{
    
    NSAssert(_delegate, @"请实现委托");
   
    if(!self.session){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    }
    
    NSURL *url = [NSURL URLWithString:[_delegate getUrl]];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    mutableRequest.timeoutInterval = 10;
    
    NSString *json = [[ZZBaseHelper defaultBaseHelper] convertToJsonData:requestData];

    NSString *aesJson = [_delegate encrypt:json];
    
    [mutableRequest setHTTPBody:[aesJson dataUsingEncoding:NSUTF8StringEncoding]];
    
    
        __block NSURLSessionDataTask *dataTask = nil;
        dataTask = [self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(!error && data.length == 0){

//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"return:%@",data);
                
                completeHandler(dataTask,YES,nil,nil);
                
            }else {
                NSLog(@"error:%@",error );
                completeHandler(dataTask,NO,error,nil);
            }
        }];
        [dataTask resume];
    
}


#pragma mark -NSURLSessionDelegate
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {

    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {

        completionHandler(disposition, credential);
    }
}

@end
