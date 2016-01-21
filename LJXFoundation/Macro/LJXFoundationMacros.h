//
//  LJXGlobalMacros.h
//  LJX
//
//  Created by lin steven on 3/23/11.
//  Copyright 2011 LJX. All rights reserved.
//

#ifndef __IM_GLOBAL_MACROS_H__
#define __IM_GLOBAL_MACROS_H__

#define _APP_STORE_VERSION //  AppStore 版本

#ifndef _APP_STORE_VERSION
#define _PRIVATE_API_ENABLE   // 是否使用私有API
#endif

/**
 * Borrowed from Apple's AvailabiltyInternal.h header. There's no reason why we shouldn't be
 * able to use this macro, as it's a gcc-supported flag.
 * Here's what we based it off of.
 * __AVAILABILITY_INTERNAL_DEPRECATED         __attribute__((deprecated))
 */
#define __IMDEPRECATED_METHOD __attribute__((deprecated))

/**
 * Add this macro before each category implementation, so we don't have to use
 * -all_load or -force_load to load object files from static libraries that only contain
 * categories and no classes.
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 */
#define LJX_FIX_CATEGORY_BUG(name) @interface LJX_FIX_CATEGORY_BUG_##name :NSObject @end \
@implementation LJX_FIX_CATEGORY_BUG_##name @end


///////////////////////////////////////////////////////////////////////////////////////////////////
// Flags

/**
 * For when the flag might be a set of bits, this will ensure that the exact set of bits in
 * the flag have been set in the value.
 */
#define IS_MASK_SET(value, flag)  (((value) & (flag)) == (flag))


///////////////////////////////////////////////////////////////////////////////////////////////////
// Time

#define LJX_MINUTE 60
#define LJX_HOUR   (60 * LJX_MINUTE)
#define LJX_DAY    (24 * LJX_HOUR)
#define LJX_5_DAYS (5 * LJX_DAY)
#define LJX_WEEK   (7 * LJX_DAY)
#define LJX_MONTH  (30.5 * LJX_DAY)
#define LJX_YEAR   (365 * LJX_DAY)



///////////////////////////////////////////////////////////////////////////////////////////////////
// Safe releases
#if __has_feature(objc_arc)
#define LJX_RELEASE_SAFELY(__POINTER) { __POINTER = nil; }
#define LJX_SUPPER_DEALLOC
#else
#define LJX_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define LJX_SUPPER_DEALLOC     [super dealloc];
#endif

#define LJX_SELETOR_TO_STRING(sel)   NSStringFromSelector(@selector(sel))

#define LJXIsPhone (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM())
#define LJXIsPad (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())


#define LJX_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

// Release a CoreFoundation object safely.
#define LJX_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }


#define LJX_FREE_POINTER_SAFELY(pointer) {if (pointer) { free(pointer); pointer = NULL;}}

#define IS_NOT_FOUND_RANGE(range) NSEqualRanges(range, (NSRange){0,0})

#define  LJX_DISPATCH_GLOBAL_HIGH_PRIORITY_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

#define  LJX_DISPATCH_GLOBAL_DEFAULT_PRIORITY_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define  LJX_DISPATCH_GLOBAL_LOW_PRIORITY_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)

#define  LJX_DISPATCH_GLOBAL_BACKGROUND_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

#define DeclareWeakSelf __typeof(&*self) __weak weakSelf = self
#define DeclareStrongSelf __typeof(&*self) __strong strongSelf = weakSelf

#define LJXIntToNSNumber(value)                   [NSNumber numberWithInt:value]
#define LJXNSStringFromNSNumber(value)            [NSString stringWithFormat:@"%@", value]
#define LJXIntToNSString(value)                   [NSString stringWithFormat:@"%@", @(value)]
#define LJXUIntToNSString(value)                  [NSString stringWithFormat:@"%@", @(value)]
#define LJXFloatToNSString(value)                 [NSString stringWithFormat:@"%@", @(value)]
#define LJXDouleToNSString(value)                 [NSString stringWithFormat:@"%@", @(value)]
#define LJXLongToNSNumber(value)                  [NSNumber numberWithLong:value]
#define LJXLongLongToNSNumber(value)              [NSNumber numberWithLongLong:value]
#define LJXBoolToNSNumber(value)                  [NSNumber numberWithInt:value]
#define LJXFloatToNSNumber(value)                 [NSNumber numberWithFloat:value]
#define LJXDoubleToNSNumber(value)                [NSNumber numberWithDouble:value]

#define LJXIndexPathFromRowAndSection(row, sec) [NSIndexPath indexPathForRow:row inSection:sec]
#define LJXIndexPathIsEqual(ip1,ip2) (ip1.row == ip2.row && ip1.section == ip2.section)

#define  LJXIsiOS7Later (!([LJXSystem OSVersion] < 7.0f))
#define  LJXIsiOS8Later (!([LJXSystem OSVersion] < 8.0f))

/* 判断一个浮点数是否为0 */
#define  LJXFloatIsEqualToZero(f)   (fabs(f) < 0.0000001)
#define  LJXFloatIsNotEqualToZero(f)   (!(fabs(f) < 0.0000001))

/* 判断二个浮点数是否相等 */
#define  LJXFloatIsEqual(a, b)   (fabs((a) - (b)) < 0.0000001)
#define  LJXFloatIsNotEqual(a, b)   (!(fabs((a) - (b)) < 0.0000001))


#define DeallocLog DDLogWarn(@"\n\n******************************************\n******  ViewController dealloc  **********\n******                          **********\n******  %@\n******                          **********\n******************************************\n\n\n",[self class])



#ifndef __OPTIMIZE__
#define NSLog(...)	NSLog(__VA_ARGS__)
#else
#define NSLog(...)	{}
#endif

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#define kNavigationBarHeight 64.0f


#endif


