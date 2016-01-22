//
//  LJXSystem.m
//  LJXFoundation
//
//  Created by steven on 11/29/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJXSystem.h"
#import "NSBundle+Info_Plist.h"

@implementation LJXSystem

+ (BOOL) isSimulator {
    NSString* deviceType = [UIDevice currentDevice].model;
    //    //NSLog(@"deviceType:%@\n", deviceType);
    if (NSNotFound != [deviceType rangeOfString:@"Simulator"].location) {
        return YES;
    }
    return NO;
}

+ (BOOL) isiPad
{
    return (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM());
}


+ (float)OSVersion
{
  return [[[UIDevice currentDevice] systemVersion] floatValue];    
}


+ (BOOL)isEqualToOSVersion:(NSString*)version
{
    NSString* str = [[UIDevice currentDevice] systemVersion];
    return (NSOrderedSame == [str compare:version]);
}

+ (BOOL)isGeOSVersion:(NSString*)version
{
    NSString* str = [[UIDevice currentDevice] systemVersion];
    return (NSOrderedAscending != [str compare:version]);
}


@end
