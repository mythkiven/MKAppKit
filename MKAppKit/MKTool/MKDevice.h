//
//  MKDevice.h
//  MKApp
//
//  Created by apple on 2019/6/29.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKDevice : NSObject
@property (copy,nonatomic) NSString * appName;
@property (copy,nonatomic) NSString * appVersion;
@property (copy,nonatomic) NSString * appBundleVersion;

@property (copy,nonatomic) NSString * deviceName;
@property (copy,nonatomic) NSString * deviceModel;
@property (copy,nonatomic) NSString * deviceVersion;
@property (copy,nonatomic) NSString * deviceLanguage;

/** 屏幕显示的电量,低电量时才能检测出来 */
@property (copy,nonatomic) NSString * batteryPercent;
/** 屏幕显示的网络情况
 eg: netName:中国联通 netType:WIFI netStrength:[raw:0dBm bars:1] wifiStrength:[raw:-54dBm bars:3] 当前网络为: 联通+wifi
 eg: netName:中国联通 netType:4G netStrength:[raw:0dBm bars:1] wifiStrength:[raw:0dBm bars:0] 当前网络为: 联通
 eg: netName:中国联通 netType:WIFI netStrength:[raw:0dBm bars:1] wifiStrength:[raw:-47dBm bars:3] 当前网络为: wifi
 eg: netName:无 SIM 卡 netType:WIFI netStrength:[raw: bars:] wifiStrength:[raw:-49dBm bars:3]   当前网络为: 无SIM卡+wifi
 bars: 标识信号强度 3: 强 ，2：中， 1：弱 ，无
 */
@property (copy,nonatomic) NSString * netInfo;
/** 屏幕显示的时间 */
@property (copy,nonatomic) NSString * currentTime;

@property (copy,nonatomic) NSString * cpuType;
@property (copy,nonatomic) NSString * appUsedMemory;
@property (copy,nonatomic) NSString * totalMemory;
@property (copy,nonatomic) NSString * totalDisk;
@property (copy,nonatomic) NSString * freeDisk;
@property (copy,nonatomic) NSString * cpuUsed;

@property (copy,nonatomic) NSString * deviceInfo;
@end


NS_ASSUME_NONNULL_END
