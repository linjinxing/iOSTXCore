//
//  LJXSystem.h
//  LJXFoundation
//
//  Created by steven on 11/29/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJXSystem : NSObject
+ (BOOL) isSimulator;
+ (BOOL) isiPad;
+ (BOOL) isDuoPing;
+ (float)OSVersion;
+ (BOOL)isEqualToOSVersion:(NSString*)version;
+ (BOOL)isGeOSVersion:(NSString*)version;
@end
