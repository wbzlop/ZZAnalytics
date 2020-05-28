//
//  ViewController.m
//  AnalyticsSDKDemo
//
//  Created by wbz on 2020/5/18.
//  Copyright © 2020 zz. All rights reserved.
//

#import "ViewController.h"
#import <AnalyticsSDK/AnalyticsSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AnalyticsSDK initWithAppkey:@"B7P1QWHQROD9FRJ1YL49YX90" andIsDebug:YES andIsCN:YES];
}


@end
