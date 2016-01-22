//
//  NSNumber+LJXExtend.m
//  iMoveHomeServer
//
//  Created by zengwm on 14/11/24.
//  Copyright (c) 2014年 i-Move. All rights reserved.
//

#import "NSNumber+LJXExtend.h"
#import "NSDateAdditions.h"
#import "NSStringAdditions.h"
#import "LJXFoundationMacros.h"

@implementation NSNumber (LJXExtend)

- (NSString *)formatDateString
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]];
    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@",[date dateYear],[date dateMouth],[date dateDay]];
    return dateString;
}



- (NSString*) percentFormatWithMaximumFractionDigits:(NSUInteger)maximumFractionDigits{
	NSNumberFormatter* percentFormatter = [[NSNumberFormatter alloc] init];
	[percentFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
	[percentFormatter setLocale:[NSLocale currentLocale]];
	[percentFormatter setMaximumFractionDigits:maximumFractionDigits];
	return [percentFormatter stringFromNumber:self];
}

- (NSString*) currencyFormatString{
	if (LJXFloatIsEqualToZero([self doubleValue])) {
		return @"0";
	}
	NSNumberFormatter* percentFormatter = [[NSNumberFormatter alloc] init];
//	[percentFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[percentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[percentFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
//	[percentFormatter setMaximumFractionDigits:maximumFractionDigits];
//	NSString* str = [percentFormatter stringFromNumber:self];
//	return [[str substringWithRange:NSMakeRange(1, [str length] - 1)] stringByReplacingOccurrencesOfString:@".00" withString:@""];
	
	NSUInteger startIdx = [self doubleValue] > .0f ? 1 : 2;
	NSString* str = [percentFormatter stringFromNumber:self];
	NSString* result = [str substringWithRange:NSMakeRange(startIdx, [str length] - startIdx)];
	result = [result stringByReplacingOccurrencesOfString:@".00" withString:@""];
	result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
	if ([self floatValue] < .0f) {
		result = [@"-" stringByAppendingString:result];
	}
	return result;
}

- (NSString *)moneyFormatString {
    
    return [self currencyFormatString];
}

@end



