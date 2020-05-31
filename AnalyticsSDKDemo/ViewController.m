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
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *idText;
@property (weak, nonatomic) IBOutlet UITextField *configVersionText;
@property (weak, nonatomic) IBOutlet UITextField *valueText;
@property (weak, nonatomic) IBOutlet UITextField *infoKeyText;
@property (weak, nonatomic) IBOutlet UITextField *infoValueText;

- (IBAction)trackAction:(id)sender;

- (IBAction)check905:(id)sender;
- (IBAction)check904:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AnalyticsSDK initWithAppkey:@"B7P1QWHQROD9FRJ1YL49YX90" printLog:YES andIsCN:YES];

}


- (IBAction)trackAction:(id)sender {
    
    NSMutableDictionary<NSString *,NSString *> *dict = [NSMutableDictionary dictionary];
    [dict setValue:_infoValueText.text forKey:_infoKeyText.text];
    
    [AnalyticsSDK trackWithName:_nameText.text eventValue:_valueText.text eventId:_idText.text eventConfigVersion:_configVersionText.text enentInfo:dict];
}

- (IBAction)check905:(id)sender {
    
}

- (IBAction)check904:(id)sender {
}
@end
