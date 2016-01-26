//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "LJXFoundationMacros.h"
#import "NSDateAdditions.h"
#import "LJXLocale.h"
// Core


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
//LJX_FIX_CATEGORY_BUG(NSDateAdditions)

@implementation NSDate (LJXCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate*)dateWithToday {
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-d-M";

  NSString* formattedTime = [formatter stringFromDate:[NSDate date]];
  NSDate* date = [formatter dateFromString:formattedTime];
  LJX_RELEASE_SAFELY(formatter);

  return date;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate*)dateAtMidnight {
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-d-M";

  NSString* formattedTime = [formatter stringFromDate:self];
  NSDate* date = [formatter dateFromString:formattedTime];
  LJX_RELEASE_SAFELY(formatter);

  return date;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatTime {
  static NSDateFormatter* formatter = nil;
  if (nil == formatter) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = LJXLocalizedString(@"h:mm a", @"Date format: 1:05 pm");
    formatter.locale = LJXCurrentLocale();
  }
  return [formatter stringFromDate:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatDate {
  static NSDateFormatter* formatter = nil;
  if (nil == formatter) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =
      LJXLocalizedString(@"EEEE, LLLL d, YYYY", @"Date format:Monday-July-27-2009");
    formatter.locale = LJXCurrentLocale();
  }
  return [formatter stringFromDate:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatShortTime {
  NSTimeInterval diff = abs([self timeIntervalSinceNow]);

  if (diff < LJX_DAY) {
    return [self formatTime];

  } else if (diff < LJX_5_DAYS) {
    static NSDateFormatter* formatter = nil;
    if (nil == formatter) {
      formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = LJXLocalizedString(@"EEEE", @"Date format: Monday");
      formatter.locale = LJXCurrentLocale();
    }
    return [formatter stringFromDate:self];

  } else {
    static NSDateFormatter* formatter = nil;
    if (nil == formatter) {
      formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = LJXLocalizedString(@"M/d/yy", @"Date format: 7/27/09");
      formatter.locale = LJXCurrentLocale();
    }
    return [formatter stringFromDate:self];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatDateTime {
  NSTimeInterval diff = abs([self timeIntervalSinceNow]);
  if (diff < LJX_DAY) {
    return [self formatTime];

  } else if (diff < LJX_5_DAYS) {
    static NSDateFormatter* formatter = nil;
    if (nil == formatter) {
      formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = LJXLocalizedString(@"EEE h:mm a", @"Date format: Mon 1:05 pm");
      formatter.locale = LJXCurrentLocale();
    }
    return [formatter stringFromDate:self];

  } else {
    static NSDateFormatter* formatter = nil;
    if (nil == formatter) {
      formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = LJXLocalizedString(@"MMM d h:mm a", @"Date format: Jul 27 1:05 pm");
      formatter.locale = LJXCurrentLocale();
    }
    return [formatter stringFromDate:self];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatRelativeTime {
  NSTimeInterval elapsed = abs([self timeIntervalSinceNow]);
  if (elapsed <= 1) {
    return LJXLocalizedString(@"just a moment ago", @"");

  } else if (elapsed < LJX_MINUTE) {
    int seconds = (int)(elapsed);
    return [NSString stringWithFormat:LJXLocalizedString(@"%d seconds ago", @""), seconds];

  } else if (elapsed < 2*LJX_MINUTE) {
    return LJXLocalizedString(@"about a minute ago", @"");

  } else if (elapsed < LJX_HOUR) {
    int mins = (int)(elapsed/LJX_MINUTE);
    return [NSString stringWithFormat:LJXLocalizedString(@"%d minutes ago", @""), mins];

  } else if (elapsed < LJX_HOUR*1.5) {
    return LJXLocalizedString(@"about an hour ago", @"");

  } else if (elapsed < LJX_DAY) {
    int hours = (int)((elapsed+LJX_HOUR/2)/LJX_HOUR);
    return [NSString stringWithFormat:LJXLocalizedString(@"%d hours ago", @""), hours];

  } else {
    return [self formatDateTime];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatShortRelativeTime {
  NSTimeInterval elapsed = abs([self timeIntervalSinceNow]);

  if (elapsed < LJX_MINUTE) {
    return LJXLocalizedString(@"<1m", @"Date format: less than one minute ago");

  } else if (elapsed < LJX_HOUR) {
    int mins = (int)(elapsed / LJX_MINUTE);
    return [NSString stringWithFormat:LJXLocalizedString(@"%dm", @"Date format: 50m"), mins];

  } else if (elapsed < LJX_DAY) {
    int hours = (int)((elapsed + LJX_HOUR / 2) / LJX_HOUR);
    return [NSString stringWithFormat:LJXLocalizedString(@"%dh", @"Date format: 3h"), hours];

  } else if (elapsed < LJX_WEEK) {
    int day = (int)((elapsed + LJX_DAY / 2) / LJX_DAY);
    return [NSString stringWithFormat:LJXLocalizedString(@"%dd", @"Date format: 3d"), day];

  } else {
    return [self formatShortTime];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatDay:(NSDateComponents*)today yesterday:(NSDateComponents*)yesterday {
  static NSDateFormatter* formatter = nil;
  if (nil == formatter) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = LJXLocalizedString(@"MMMM d", @"Date format: July 27");
    formatter.locale = LJXCurrentLocale();
  }

  NSCalendar* cal = [NSCalendar currentCalendar];
  NSDateComponents* day = [cal components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                               fromDate:self];

  if (day.day == today.day && day.month == today.month && day.year == today.year) {
    return LJXLocalizedString(@"Today", @"");

  } else if (day.day == yesterday.day && day.month == yesterday.month
             && day.year == yesterday.year) {
    return LJXLocalizedString(@"Yesterday", @"");

  } else {
    return [formatter stringFromDate:self];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatMonth {
  static NSDateFormatter* formatter = nil;
  if (nil == formatter) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = LJXLocalizedString(@"MMMM", @"Date format: July");
    formatter.locale = LJXCurrentLocale();
  }
  return [formatter stringFromDate:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)formatYear {
  static NSDateFormatter* formatter = nil;
  if (nil == formatter) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = LJXLocalizedString(@"yyyy", @"Date format: 2009");
    formatter.locale = LJXCurrentLocale();
  }
  return [formatter stringFromDate:self];
}

- (NSString *)formatDateFull
{
//    NSDate *  senddate=[NSDate date];  
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];  
    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm:ss"]; 
    [dateformatter stringFromDate:self];
    return [dateformatter stringFromDate:self];
}

- (NSDateComponents*)dateComponet
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    return comps;
}

- (NSString*)formatString:(long)value
{
    NSString *string;
    if (value<10) {
        string = [NSString stringWithFormat:@"0%d",value];
    }
    else
        string = [NSString stringWithFormat:@"%d",value];
    return string;
}

- (NSString*)dateYear
{
    NSDateComponents *dateCom = [self dateComponet];
    return [NSString stringWithFormat:@"%@",@([dateCom year])];
}

- (NSString*)dateMouth
{
    NSDateComponents *dateCom = [self dateComponet];
    return  [self formatString:[dateCom month]];
}

- (NSString*)dateDay
{
    NSDateComponents *dateCom = [self dateComponet];
    return [self formatString:[dateCom day]];
}

- (NSString*)dateHour
{
    NSDateComponents *dateCom = [self dateComponet];
    return [self formatString:[dateCom hour]];    
}

- (NSString*)dateMinute
{
    NSDateComponents *dateCom = [self dateComponet];
    return  [self formatString:[dateCom minute]];
}

- (NSString*)dateSecond
{
    NSDateComponents *dateCom = [self dateComponet];
    return [self formatString:[dateCom second]];
}


@end
