//
//  LJXSystemCompatibility.m
//  LJXFoundation
//
//  Created by steven on 11/29/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "LJXSystemCompatibility.h"
#import "LJXSystem.h"

@implementation LJXSystemCompatibility
+ (BOOL)cellularDataTransmit
{
    if  ( [LJXSystem isSimulator]) return YES;
    NSString* deviceType = [UIDevice currentDevice].model;
    if (NSNotFound != [deviceType rangeOfString:@"iPhone"].location)
    {
        return YES;
    }
    else if (NSNotFound != [deviceType rangeOfString:@"iPod"].location)
    {
        return NO;
    }
    if ([LJXSystem OSVersion] >= 4.0f) {
        CTTelephonyNetworkInfo* tpn =  [[CTTelephonyNetworkInfo alloc] init];
        //NSLog(@"subscriberCellularProvider:%@\n", tpn.subscriberCellularProvider);
        if ([tpn.subscriberCellularProvider.carrierName length]) {
            return YES;
        }
        return NO;
    }else{
        return YES;
    }
}
@end
