//
//  LJXLockPassword.m
//  LockSample
//
//  Created by Lugede on 14/11/12.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LJXLockPassword.h"

@interface LJXLockPasswordUser : NSObject
@property(nonatomic, copy) NSString* userName;
@property(nonatomic, copy) NSString* password;
@property(nonatomic, assign) BOOL needVerification;
@end

@implementation LJXLockPasswordUser
@end

static LJXLockPasswordUser* s_user = nil;

@implementation LJXLockPassword

+ (LJXLockPasswordUser*)user{
	return s_user;
}

+ (NSString*)key{
   return [s_user.userName stringByAppendingString:NSStringFromClass([self class])];
}

+ (NSArray*)allPropetiesKeys
{
	return @[@"userName", @"password", @"needVerification"];
}

+ (void)setUser:(NSString*)userName{
	if (userName){
		s_user = [[LJXLockPasswordUser alloc] init];
		s_user.userName = userName;
		NSDictionary* dict = [NSUserDefaults objectForKey:[self key]];
		if (dict) {
			[s_user setValuesForKeysWithDictionary:dict];
		}
	}
}

+ (void)save{
	
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[self allPropetiesKeys].count];
	
	[[self allPropetiesKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id value = [s_user valueForKey:obj];
		if (value) {
			dict[obj] = value;
		}
	}];
	
	[NSUserDefaults setObject:dict
					   forKey:[[self class] key]];
}

#pragma mark - 锁屏密码读写
+ (NSString*)loadLockPassword
{
    NSString* pswd = [[self class] user].password;
    //    LLLog(@"pswd = %@", pswd);
    if (pswd != nil &&
        ![pswd isEqualToString:@""] &&
        ![pswd isEqualToString:@"(null)"]) {
        
        return pswd;
    }
    
    return nil;
}

+ (void)clearLockPassword
{
	s_user.password = @"";
	[self save];
}

+ (void)saveLockPassword:(NSString*)pswd
{
	s_user.password = pswd;
	[self save];
}

// 是否需要提示输入密码
+ (BOOL)isAlreadyAskedCreateLockPassword
{
//    NSUserDefaults* ud = [[self class] userDefault];
//    NSString* pswd = [ud objectForKey:@"AlreadyAsk"];
//    
//    if (pswd != nil && [pswd isEqualToString:@"YES"]) {
//        
//        return NO;
//    }
	
    return YES;
}

// 需要提示过输入密码了
+ (void)setAlreadyAskedCreateLockPassword
{
//    [[[self class] userDefault] setObject:@"YES" forKey:@"AlreadyAsk"];
//    [[[self class] userDefault] synchronize];
}

+(void)setNeedVerificationLockPassword:(BOOL)bl {
	s_user.needVerification = bl;
	[self save];
}

+(BOOL)isNeedVerificationLockPassword {
    if ([LJXLockPassword loadLockPassword]) {
        return s_user.needVerification;
    }
    return NO;
}

@end
