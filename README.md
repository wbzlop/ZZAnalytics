# ZZAnalyticsSDK接入文档（iOS）

> version:1.2.5

## 集成sdk

**通过cocoapods集成**：

1. 先安装[Cocoapods](https://guides.cocoapods.org/using/getting-started.html)；
2. 通过 `pod repo update` 更新ZZAnalyticsSDK的cocoapods版本(最新版本1.2.5)。
3. 在Podfile对应的target中，添加`pod 'ZZAnalyticsSDK'`，并执行`pod install`。

## 使用

```objective-c
//引入库
#import <ZZAnalyticsSDK/AnalyticsSDK.h>
```

### 初始化

```objective-c
//appkey:运营提供
//printLog:是否打印日志
//isCN:是否国内应用
[AnalyticsSDK initWithAppkey:@"Your App Key" printLog:YES andIsCN:YES];
```

### 设置渠道

```swift
[AnalyticsSDK setChannel:@"Your Channel"];
```

### 事件统计

```swift
NSMutableDictionary<NSString *,NSString *> *eventInfo = [NSMutableDictionary dictionary];
[dict setValue:@"value1" forKey:@"key1"];
[dict setValue:@"value2" forKey:@"key2"];

/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
/// @param eventId 事件ID（可nil）
/// @param configVersion 策略版本（可nil）
/// @param info 事件map（可nil）
[AnalyticsSDK trackWithName:@"eventName" eventValue:@"eventValue" eventId:@"eventId" eventConfigVersion:@"configVersion" enentInfo:eventInfo];


/// 统计事件
/// @param name 事件名
/// @param info 事件map（可nil）
[AnalyticsSDK trackWithName:@"eventName" enentInfo:eventInfo];


/// 统计事件
/// @param name 事件名
/// @param value 事件值（可nil）
[AnalyticsSDK trackWithName:@"eventName" eventValue:@"eventValue"];


/// 统计事件
/// @param name 事件名
[AnalyticsSDK trackWithName:@"eventName"];
```
