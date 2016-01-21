//
//  LJXWifi.h
//  iMoveHomeServer
//
//  Created by LoveYouForever on 1/4/15.
//  Copyright (c) 2015 i-Move. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 当wifi的SSID变化时，将发送这个通知
   只监测UIApplicationDidBecomeActiveNotification消息来修改ssid
 */
FOUNDATION_EXPORT NSString* const LJXNotificationWifiSSIDDidChange;

@interface LJXWifi : NSObject
+ (NSString *) currentSSID;
@end
