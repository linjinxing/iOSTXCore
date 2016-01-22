//
//  LJXWifi.m
//  iMoveHomeServer
//
//  Created by LoveYouForever on 1/4/15.
//  Copyright (c) 2015 i-Move. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "LJXWifi.h"

NSString* const LJXNotificationWifiSSIDDidChange = @"LJXNotificationWifiSSIDDidChange";

static NSString* s_lastSSID = nil;

@implementation LJXWifi

+ (void)load
{
    if ([LJXWifi class] == self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSSID:) name:UIApplicationDidFinishLaunchingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSSID:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}

+ (void)updateSSID:(NSNotification*)noti
{
    NSString* currentSSID = [self currentSSID];
    if  (0 == [currentSSID length])
    {
        return;
    }
    if (nil == s_lastSSID)
    {
        s_lastSSID = currentSSID;
    }else{
        if (![s_lastSSID isEqualToString:currentSSID])
        {
            s_lastSSID = currentSSID;
            [[NSNotificationCenter defaultCenter] postNotificationName:LJXNotificationWifiSSIDDidChange object:nil];
        }
    }
}


+ (NSString *) currentSSID {
    
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    
    if (!interfaces) {
        return nil;
    }
    
    CFIndex count = CFArrayGetCount(interfaces);
    
    if (count < 1) {
        return nil;
    }
    
    NSString *ssid = nil;
    CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, (CFIndex) 0));
    if (dicRef) {
        ssid = CFDictionaryGetValue(dicRef, kCNNetworkInfoKeySSID);
        CFRelease(dicRef);
    }
    
    return ssid;
}

@end



