//
//  NSNumber+LJXExtend.h
//  iMoveHomeServer
//
//  Created by zengwm on 14/11/24.
//  Copyright (c) 2014年 i-Move. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (LJXExtend)

/**
 *  NSNumber转成供显示的日期字符串
 *
 *  @return NSSTring字符串
 */
- (NSString *)formatDateString;

- (NSString*) percentFormatWithMaximumFractionDigits:(NSUInteger)maximumFractionDigits;

- (NSString*) currencyFormatString;

//转换number为金额显示， 保留小数点2位，加上千位分隔符
- (NSString *) moneyFormatString;

@end


