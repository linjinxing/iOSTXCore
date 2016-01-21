//
//  NSUserDefaultsAdditions.m
//  LJX
//
//  Created by lin steven on 5/30/11.
//  Copyright 2011 LJX. All rights reserved.
//

#import "NSUserDefaultsAdditions.h"
#import "LJXDebug.h"

@implementation NSUserDefaults(Additions)
+(BOOL)setObject:(id)aObject forKey:(NSString*)aKey
{
	if (aObject && aKey) {
		NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
		//    if ([aObject isKindOfClass:[NSArray class]])
		{
		[userDefault setObject:aObject forKey:aKey];
		}
		return [userDefault synchronize];
	}
	else{
		LJXFoundationLog("aObject:%@, aKey:%@", aObject, aKey);
		return NO;
	}
}

+ (id)objectForKey:(NSString*)aKey
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:aKey];    
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:defaultName];
}

+ (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    //    if ([aObject isKindOfClass:[NSArray class]])
    {
        [userDefault setFloat:value forKey:defaultName];
    }
    [userDefault synchronize];
}

+ (float)floatForKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault floatForKey:defaultName];
}


+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    //    if ([aObject isKindOfClass:[NSArray class]])
    {
        [userDefault setBool:value forKey:defaultName];
    }
    [userDefault synchronize];        
}

+(void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    //    if ([aObject isKindOfClass:[NSArray class]])
    {
        [userDefault setInteger:value forKey:defaultName];
    }
    [userDefault synchronize];        
}

+ (NSInteger)integerForKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault integerForKey:defaultName];
}




+(BOOL)setArchiverObject:(id)aObject forKey:(NSString*)aKey
{
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:aObject];
    return [self setObject:theData forKey:aKey];
}

+(id) archiverObjectForKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    id obj = [userDefault objectForKey:defaultName];
    if (obj) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    }
    return nil;
}

+(NSArray *)arrayForKey:(NSString *)defaultName
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray* obj = [userDefault objectForKey:defaultName];
    if ([obj isKindOfClass:[NSArray class]]) {
        LJXFoundationLog("obj:%@\n", obj);
        return obj;
    }
    return nil;
}
@end



