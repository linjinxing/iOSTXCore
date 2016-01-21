//
//  IMPath.h
//  LJXFoundation
//
//  Created by steven on 11/29/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJXPath : NSObject
+(NSString*)library;
+(NSString*)document;
+(NSString*)tmp;
+(NSString *)systemData;
+(NSString *)downloadData;
+(NSString *)bigScreenCache;
@end
