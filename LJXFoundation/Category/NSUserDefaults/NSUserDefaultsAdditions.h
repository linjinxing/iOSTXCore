//
//  NSUserDefaultsAdditions.h
//  LJX
//
//  Created by lin steven on 5/30/11.
//  Copyright 2011 LJX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults(Additions)
+ (BOOL)boolForKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

+ (void)setFloat:(float)value forKey:(NSString *)defaultName;
+ (float)floatForKey:(NSString *)defaultName;

+(BOOL)setObject:(id)aObject forKey:(NSString*)aKey;
+ (id)objectForKey:(NSString*)aKey;
+(BOOL)setArchiverObject:(id)aObject forKey:(NSString*)aKey;

+(void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
+ (NSInteger)integerForKey:(NSString *)defaultName;

+(NSArray *)arrayForKey:(NSString *)defaultName;
+(id) archiverObjectForKey:(NSString *)defaultName;
@end
