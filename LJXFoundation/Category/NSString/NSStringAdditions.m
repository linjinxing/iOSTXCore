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


#import "LJXDebug.h"
#import "NSStringAdditions.h"
#import "LJXFoundationMacros.h"
//#import "pinyin.h"
//#import "BG2Unicode.h"
#import "LJXSystem.h"
//#import "ConstString.h"
// Core

//#import "LJXMarkupStripper.h"
#import "NSDateAdditions.h"
#import "NSDataAdditions.h"
#import "NSFileManagerAdditions.h"
//#import "LJXGlobalUICommon.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
LJX_FIX_CATEGORY_BUG(NSStringAdditions)
const float GB = (float)(1024 * 1024 * 1024);
const float LJX = (float)(1024 * 1024);
const float KB = (float)(1024);

@implementation NSString(init)
+ (NSString*)stringWithGBData:(NSData*)aGBData
{
    NSString* retString = nil;
    NSString * asyncTextEncodingName = (__bridge NSString*)CFStringConvertEncodingToIANACharSetName(kCFStringEncodingGB_18030_2000);
    CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)asyncTextEncodingName);
    if (cfEncoding != kCFStringEncodingInvalidId) {
        unsigned long nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
        if (nsEncoding != 0) 
        {
            retString = [[NSString alloc] initWithData:aGBData encoding:nsEncoding];
        }
    }
    return retString;
}

+ (NSString*)stringWithInt:(NSInteger)number
{
    return [NSString stringWithFormat:@"%ld",(long)number];
}


@end

@implementation NSString(hex)
-(NSData*) hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end
@implementation NSString(substring)
-(NSString*)substringBetweenRange:(NSRange)range1 anotherRange:(NSRange)range2
{
	if (range1.location > range2.location) {
		NSRange range = {
			range2.location, range1.location - range2.location
		};
		return [self substringWithRange:range];		
	}else {
		NSRange range = {
			range1.location, range2.location - range1.location
		};
		return [self substringWithRange:range];			
	}
}

-(NSString*)substringAfterRange:(NSRange)range
{
	NSRange rangSubstring = {
		range.location + range.length, [self length] - range.location - range.length};
	
	return [self substringWithRange:rangSubstring];	
}

-(NSString*)substringAfterString:(NSString*)string
{
	NSRange rangSubstring = [self rangeOfString:string];
	if (NSNotFound == rangSubstring.location) {
        return nil;
    }
	return [self substringAfterRange:rangSubstring];	
}

-(NSString*)substringBetweenStrings:(NSString*)str1 anotherString:(NSString*)str2
{
	NSRange range1 = [self rangeOfString:str1];
	if (NSNotFound == range1.location) 
	{
		LJXWarnPrompt( "[substringBetweenStrings] haven't found "
				 "str1:%@ in str:%@ \n",
				 str1, self);
		
		return nil;
	}else {
		/* search for second string from the found string */		
		NSString* strStart = [self substringFromIndex:range1.location+range1.length];
		NSRange range2 = [strStart rangeOfString:str2];
		LJXFoundationLog("111 [substringBetweenStrings ] [self length]:%d, " 
				  "range1.location:%d, range2:%d\n", 
				  [self length],
				  range1.location,
				  range2.location
				  );
		if (NSNotFound == range2.location) 
		{
			LJXWarnPrompt( "[substringBetweenStrings] haven't found "
					 "str1:%@ in str:%@ \n",
					 str2, strStart);
			
			return nil;
		}		
		NSRange returnRange = {
			range1.location + range1.length, 
			range2.location
		};
//		LJXFoundationLog("222 [substringBetweenStrings ] [self length]:%d, " 
//				  "range1.location:%d, range1.length:%d, "
//				  "range2.location:%d, range2.length:%d, "
//				  "result:%@\n", 
//				  [self length],
//				  range1.location,
//				  range1.length,
//				  range2.location,
//				  range2.length,
//				  [self substringWithRange:returnRange]
//				  );		
		return [self substringWithRange:returnRange];
	}
}

-(NSString*)substringBetweenString:(NSString*)str
{
    //	LJXFoundationLog(DM_BASE, "[substringBetweenString] str:%@\n", str);
	return [self substringBetweenStrings:str anotherString:str];
}
@end

@implementation NSString (file)

- (NSDate*) fileCreateDate
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return  [[manager attributesOfItemAtPath:self error:NULL]  fileCreationDate];    
}

- (NSDate*) fileModificationDate
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [[manager attributesOfItemAtPath:self error:NULL] fileModificationDate]; //objectForKey:NSFileModificationDate
}

- (BOOL)canHardwareDecode
{
    NSString* extension = [[self pathExtension] lowercaseString];
    NSSet* set = [NSSet setWithObjects:@"mov", @"mp4", @"qt", @"3gp", @"3gpp", @"m4a", @"m4a", @".caf",  @"wav", @"aif", @"amr", nil];
    BOOL retVal = [set containsObject:extension];
    if (!retVal) {
        NSURL* nsurl = [NSURL URLWithString:self];
        extension = [[nsurl pathExtension] lowercaseString];
        retVal = [set containsObject:extension];
    }
    return retVal;
}

- (NSString*) fileType
{  
    NSString* type = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    type = [[manager attributesOfItemAtPath:self error:NULL] fileType];    
    if ([NSFileTypeDirectory isEqualToString:type]) 
    {
        /* 排在最前面 */
        type = @" 1st directory";
    }else
    {
        type = [[self pathExtension] lowercaseString];
    }
//    LJXFoundationLog("type:%@\n", type);    
    return type;
}

- (BOOL)isFileWithExtention:(NSString*)aExtensions
{
    NSArray* exts = [[aExtensions lowercaseString] componentsSeparatedByString:@","];
    NSString *ext = [self pathExtension] ;
    if (ext == nil || [ext isEqualToString:@""]) {
        return NO;
    }
    ext = [[self pathExtension] lowercaseString];
    return [[NSSet setWithArray:exts] containsObject:ext];
}

-(BOOL)removeFileAtDocument
{
    return [NSFileManager removeFileAtDocumentWithName:self];
}
-(BOOL)removeFile
{
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self error:&error];
    if (error) {
        //LJXError( "[removeFile] failed 2 remove file:%@\n", self);
        return FALSE;
    }else{
        return TRUE;
    }    
}
-(BOOL)isDirectory
{
    NSError* error = nil;
    NSString* type = [[[NSFileManager defaultManager] attributesOfItemAtPath:self 
                                      error:&error] fileType];    
    if (error) {
        //LJXError( "failed 2 get %@ type, error:%@\n", self, error);
    }
    return [type isEqualToString:NSFileTypeDirectory];
}

-(BOOL)createDirectory
{
    return [NSFileManager createDirectory:self];
}

-(BOOL)modifyNameToString:(NSString*)aName
{
    NSString* originName = [self lastPathComponent]; 
    NSString* dir = [self stringByDeletingLastPathComponent];
    NSError* error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:[dir stringByAppendingPathComponent:originName] 
                                            toPath:[dir stringByAppendingPathComponent:aName] error:&error];
    if (error) {
        LJXError( "failed 2 get %@ type, error:%@\n", self, error);
        return NO;
    }
    return YES;
}

@end


@implementation NSString(keyPath)
- (NSString*)stringByAppendingKeyPath:(NSString*)path
{
    if ([path length]) {
        return [self stringByAppendingFormat:@".%@", path];
    }else{
        return self;
    }
}

@end

@implementation NSString(pinyin)
//-(NSString*)firstPinYin
//{
//    NSMutableString* pinyin = [NSMutableString string];
//    for (int i = 0; i < [self length]; i++)
//    {
//        unichar ch = [self characterAtIndex:i];
//        char firstPinYin = pinyinFirstLetter(ch);
//        if (firstPinYin != NOT_CHINEASE_CHARACTER) {
//            [pinyin appendFormat:@"%c", firstPinYin];
//        }else{
//            [pinyin appendFormat:@" %c", isupper(ch) ? tolower(ch) : ch];
//        }
//    }  
////    LJXFoundationLog("pinyin:%@\n", pinyin);
//    return pinyin;
//}
@end

@implementation NSString (url)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || 
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSStringEncoding)htmlContentStringEncoding
{
    NSStringEncoding sourceEncoding = NSUTF8StringEncoding;
    NSString *strCharacterSet = self;
    
    if ( [strCharacterSet length])
    {
        if ([strCharacterSet hasPrefix:@"GB"])
        {
            sourceEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) ;
        }
        else if ( [strCharacterSet hasPrefix:@"ISO-8859"] )
        {
                sourceEncoding = NSISOLatin2StringEncoding;
        }
        else sourceEncoding = NSUTF8StringEncoding;
    }
    return sourceEncoding;
}

@end

@implementation NSString (LJX)


+ (NSString *)convertGBMBKBFromByte:(long long)byteSize
{
    NSString *gbmbFormat = [@"%" stringByAppendingString :[NSString stringWithFormat:@".%luf",(unsigned long)1]];
    NSString *kbFormat = [@"%" stringByAppendingString :[NSString stringWithFormat:@".%luf",(unsigned long)0]];

    if (byteSize / GB >= 1) {
        float size = byteSize / GB;
        gbmbFormat = [gbmbFormat stringByAppendingString:@"GB"];
        return [NSString stringWithFormat:gbmbFormat,size];
    } else if (byteSize / LJX >= 1) {
        float size = byteSize / LJX;
        gbmbFormat = [gbmbFormat stringByAppendingString:@"LJX"];
        return [NSString stringWithFormat:gbmbFormat,size];
    } else if (byteSize / KB >= 1) {
        double size = byteSize / KB;
        kbFormat = [kbFormat stringByAppendingString:@"KB"];
        return [NSString stringWithFormat:[NSString stringWithFormat:@".%luf",(unsigned long)0],size];
    } else {
        return [NSString stringWithFormat:@"%ldB",(long)byteSize];
    }
}

+ (NSString *)convertGBMBKBFromByte:(long long)byteSize decimals:(NSUInteger)decimals {
    NSString *format = [NSString stringWithFormat:@".%luf",(unsigned long)decimals];
    format = [@"%" stringByAppendingString:format];
    if (byteSize / GB >= 1) {
        float size = byteSize / GB;
        format = [format stringByAppendingString:@"GB"];
        return [NSString stringWithFormat:format,size];
    } else if (byteSize / LJX >= 1) {
        float size = byteSize / LJX;
        format = [format stringByAppendingString:@"LJX"];
        return [NSString stringWithFormat:format,size];
    } else if (byteSize / KB >= 1) {
        double size = byteSize / KB;
        format = [format stringByAppendingString:@"KB"];
        return [NSString stringWithFormat:format,size];
    } else {
        return [NSString stringWithFormat:@"%ldB",(long)byteSize];
    }
}

+ (NSString*)stringWithFileLen:(long long)fileLength
{
    int fileSize = fileLength >> 30;
    if (fileSize > 0) {
        float m_fileSize = (fileLength >> 20) / 1024.0;
        return [NSString stringWithFormat:@"%.2fGB", m_fileSize];
    }else {
        fileSize = fileLength >> 20;
        if (fileSize > 0) {
            return [NSString stringWithFormat:@"%dMB", fileSize];
        }else {
            return [NSString stringWithFormat:@"%lldKB", fileLength >> 10];
        }
    }
}
+ (NSString*)stringWithFileLen:(long long)fileLength downloadProgress:(float)downloadProgress
{
    return [NSString stringWithFormat: ([LJXSystem isiPad]? @"%@ / %@" : @"%@/%@"), [self stringWithFileLen:fileLength*downloadProgress], [self stringWithFileLen:fileLength]];
}

//- (NSString*)stringWithDownloadSpeed:(NSInteger)fileLength
//{
//    
//}
@end

@implementation NSString (time)
+(NSString*)stringPlayTimeWidthTime:(NSTimeInterval)aTimeInterval
{
	long long duration = labs(lround(aTimeInterval));
	
    int days = aTimeInterval / LJX_DAY;
    if (days > 0 )
    {
        duration = duration % LJX_DAY;
    }
    
	int hour = duration / LJX_HOUR;
	if (hour > 0 ) 
	{
		duration = duration % LJX_HOUR;
	}
	
	int minute = duration / LJX_MINUTE;
	if (minute > 0)
	{
		duration = duration % LJX_MINUTE;
	}
	int seconds = duration;
	
	NSString *timeStr = nil;
    if (0 == days && 0 == hour && 0 == minute && 0 == seconds) {
        timeStr = @"00:00:00";
    }else{
        timeStr = [NSString stringWithFormat:aTimeInterval > 0.0f ? @"%02d:%02d:%02d" : @"-%02d:%02d:%02d", hour, minute, seconds];
        if (days > 0) {
            timeStr = [NSString stringWithFormat:@"%d天%@", days, timeStr];
        }
    }
	
	return timeStr;
}

+(NSString*)stringDateWidthTime:(NSTimeInterval)aTimeInterval
{
    int days = aTimeInterval / LJX_DAY;
    if (days > 0) {
        if (1 == days)
        {
            return @"昨天";
        }else if (2 == days)
        {
            return @"前天";
        }else{
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
            return [NSString stringWithFormat:@"%@年%@月%@日", [date dateYear], [date dateMouth], [date dateDay]];
        }
    }else{
        return [self stringPlayTimeWidthTime:aTimeInterval];
    }
}

+(NSString*)stringDurationWithTimeInterval:(NSTimeInterval)aTimeInterval
{
    long long duration = lround(aTimeInterval);
    
    int hour = duration / LJX_HOUR;
    if (hour > 0 )
    {
        duration = duration % LJX_HOUR;
    }
    
    int minute = duration / LJX_MINUTE;
    
    NSMutableString *timeStr = [NSMutableString string];
    if (hour > 0) [timeStr appendFormat:@"%02d小时", hour];
    if (minute > 0) [timeStr appendFormat:@"%02d分", minute];
    
    if (0 == [timeStr length]) {
        [timeStr setString:@"0分"];
    }
    
    return [timeStr copy];
}

+(NSString*)stringWithTimeInterval:(NSTimeInterval)aTimeInterval
{
	long long duration = lround(aTimeInterval);
	
	int hour = duration / LJX_HOUR;
	if (hour > 0 )
	{
		duration = duration % LJX_HOUR;
	}
	
	int minute = duration / LJX_MINUTE;
	if (minute > 0)
	{
		duration = duration % LJX_MINUTE;
	}
	int seconds = duration;
	
	NSMutableString *timeStr = [NSMutableString string];
    if (hour > 0) [timeStr appendFormat:@"%02d", hour];
    if (minute > 0) [timeStr appendFormat:@"%02d", minute];
    if (seconds > 0) [timeStr appendFormat:@"%02d", seconds];
    if (0 == [timeStr length]) {
        [timeStr setString:@"0"];
    }
	
	return [timeStr copy];
}

@end


@implementation NSString (lyric)
- (NSTimeInterval)lyricTime
{
    NSInteger min = 0;
    NSInteger second = 0;
//    BOOL bSecond = NO;
    char szBuffer[128];
    size_t bufferLenth = sizeof(szBuffer);
    memset(szBuffer, 0, bufferLenth);
    char* pszBuffer = szBuffer;
    const char* ch = [self UTF8String];
    BOOL bFinished = NO;
    do{
        switch (*ch) {
            case ' ':
                continue;
            case ':':
            {
//                bSecond = TRUE;
                pszBuffer = szBuffer;
                min = atoi(szBuffer);
                LJXFoundationLog("buffer:%s, min:%d\n", pszBuffer, min);
                memset(szBuffer, 0, sizeof(szBuffer));  
                break;
            }
            case '.':
            {
                second = atoi(szBuffer);
                bFinished = YES;
                LJXFoundationLog("buffer:%s, second:%d\n", szBuffer, second);                
                break;
            }
            default:
                if (*ch >= 0x30 && *ch <= 0x39)
                {
                    *pszBuffer++ = *ch;
                    if (pszBuffer - szBuffer > bufferLenth - 1) {
                        LJXError( "buffer is overflow\n");
                        bFinished = YES;
                    }
                }
                break;
        }
        if  (bFinished) break;
    }while (*ch++) ;
    LJXFoundationLog("time:%d\n", min*60 + second);
    return (min*60 + second);
}
@end

@implementation NSString (NSRegularExpression)
- (NSString*)firstMatchWithPattern:(NSString*)pattern
{
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult * resultMatched = [reg firstMatchInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    NSString* ret = nil;
    if (resultMatched.range.length) {
        ret = [self substringWithRange:resultMatched.range];
    }
    return ret;
}
@end


@implementation NSString (LJXAdditions)



///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
  NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  for (NSInteger i = 0; i < self.length; ++i) {
    unichar c = [self characterAtIndex:i];
    if (![whitespace characterIsMember:c]) {
      return NO;
    }
  }
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Deprecated - https://github.com/facebook/three20/issues/367
 */
- (BOOL)isEmptyOrWhitespace {
  // A nil or NULL string is not the same as an empty string
  return 0 == self.length ||
         ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containsCharactersFromString:(NSString*)characterStr
{
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:characterStr];
    for (NSInteger i = 0; i < self.length; i++)
    {
        unichar c = [self characterAtIndex:i];
        if ([set characterIsMember:c])
        {
            return YES;
        }
    }
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)onlyContainsCharactersFromString:(NSString*)characterStr
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:characterStr];
    for (NSInteger i = 0; i < self.length; i++)
    {
        unichar c = [self characterAtIndex:i];
        if (![set characterIsMember:c])
        {
            return NO;
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containsChinese
{
    for (NSInteger i = 0; i < self.length; i++)
    {
        unichar c = [self characterAtIndex:i];
        if (c >=  0x4E00&&c<=0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSString*)stringByRemovingHTMLTags {
//  LJXMarkupStripper* stripper = [[[LJXMarkupStripper alloc] init] autorelease];
//  return [stripper parse:self];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
 * Deprecated
 */
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
  NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
  NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
  NSScanner* scanner = [[NSScanner alloc] initWithString:self];
  while (![scanner isAtEnd]) {
    NSString* pairString = nil;
    [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
    [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
    NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
    if (kvPair.count == 2) {
      NSString* key = [[kvPair objectAtIndex:0]
                       stringByReplacingPercentEscapesUsingEncoding:encoding];
      NSString* value = [[kvPair objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:encoding];
      [pairs setObject:value forKey:key];
    }
  }

  return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
  NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
  NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
  NSScanner* scanner = [[NSScanner alloc] initWithString:self];
  while (![scanner isAtEnd]) {
    NSString* pairString = nil;
    [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
    [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
    NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
    if (kvPair.count == 1 || kvPair.count == 2) {
      NSString* key = [[kvPair objectAtIndex:0]
                       stringByReplacingPercentEscapesUsingEncoding:encoding];
      NSMutableArray* values = [pairs objectForKey:key];
      if (nil == values) {
        values = [NSMutableArray array];
        [pairs setObject:values forKey:key];
      }
      if (kvPair.count == 1) {
        [values addObject:[NSNull null]];

      } else if (kvPair.count == 2) {
        NSString* value = [[kvPair objectAtIndex:1]
                           stringByReplacingPercentEscapesUsingEncoding:encoding];
        [values addObject:value];
      }
    }
  }
  return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
  NSMutableArray* pairs = [NSMutableArray array];
  for (NSString* key in [query keyEnumerator]) {
    NSString* value = [query objectForKey:key];
    value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
    [pairs addObject:pair];
  }

  NSString* params = [pairs componentsJoinedByString:@"&"];
  if ([self rangeOfString:@"?"].location == NSNotFound) {
    return [self stringByAppendingFormat:@"?%@", params];

  } else {
    return [self stringByAppendingFormat:@"&%@", params];
  }
}

- (NSString*)substringToString:(NSString*)aStr
{
    NSRange range = [self rangeOfString:aStr];
    if (NSNotFound == range.location) {
        return nil;
    }
    return [self substringToIndex:range.location];
}

- (NSString*)substringFromString:(NSString*)str
{
    NSString* retVal = nil;
    NSRange range = [self rangeOfString:str];
	if (NSNotFound != range.location) 
	{
        range = NSMakeRange(range.location + range.length, [self length] - (range.location + range.length));
        str = [NSString stringWithString:self];
        retVal =  [str substringWithRange:range];
    }
    return retVal;
}

- (NSString*)substringFromString:(NSString*)str options:(NSStringCompareOptions)mask
{
    NSString* retVal = nil;
    NSRange range = [self rangeOfString:str options:mask];
	if (NSNotFound != range.location)
	{
        range = NSMakeRange(range.location + range.length, [self length] - (range.location + range.length));
        str = [NSString stringWithString:self];
        retVal =  [str substringWithRange:range];
    }
    return retVal;
}

-(NSString*)substringBetweenString:(NSString*)str1 anotherString:str2
{
	NSRange range1 = [self rangeOfString:str1];
	if (NSNotFound == range1.location) 
	{
		return nil;
	}else {
		/* search for second string from the found string */		
		NSString* strStart = [self substringFromIndex:range1.location+range1.length];
		NSRange range2 = [strStart rangeOfString:str2];
		if (NSNotFound == range2.location) 
		{
			return nil;
		}		
		NSRange returnRange = {
			range1.location + range1.length, 
			range2.location
		};
		return [self substringWithRange:returnRange];
	}
}

- (NSString*)substringBetweenString:(NSString*)str1 anotherString:str2  range:(NSRange)searchRange
{
    NSString* strSearch1 = [self substringWithRange:searchRange];
    LJXFoundationLog("strSearch1:%@\n", strSearch1);
	NSRange range1 = [strSearch1 rangeOfString:str1];
	if (NSNotFound == range1.location) 
	{
//		LJXWarnPrompt( "[substringBetweenStrings] haven't found "
//				 "str1:%@ in str:%@ \n",
//				 str1, self);
//		
		return nil;
	}else {
		/* search for second string from the found string */		
		NSRange range = NSMakeRange(range1.location + range1.length, [self length] - (range1.location+range1.length));
        NSString* strSearch2 = [self substringWithRange:range];
        LJXFoundationLog("strSearch2:%@\n", strSearch2);        
		NSRange range2 = [strSearch2 rangeOfString:str2];
//		LJXFoundationLog(DM_BASE, "111 [substringBetweenStrings ] [self length]:%d, " 
//				  "range1.location:%d, range2:%d\n", 
//				  [self length],
//				  range1.location,
//				  range2.location
//				  );
		if (NSNotFound == range2.location) 
		{
//			LJXWarnPrompt( "[substringBetweenStrings] haven't found "
//					 "str1:%@ in str:%@ \n",
//					 str2, strStart);
			return nil;
		}		
		NSRange returnRange = {
			range1.location + range1.length, 
			range2.location
		};
//		LJXFoundationLog(DM_BASE, "222 [substringBetweenStrings ] [self length]:%d, " 
//				  "range1.location:%d, range1.length:%d, "
//				  "range2.location:%d, range2.length:%d, "
//				  "result:%@\n", 
//				  [self length],
//				  range1.location,
//				  range1.length,
//				  range2.location,
//				  range2.length,
//				  [self substringWithRange:returnRange]
//				  );		
		return [self substringWithRange:returnRange];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)versionStringCompare:(NSString *)other {
  NSArray *oneComponents = [self componentsSeparatedByString:@"a"];
  NSArray *twoComponents = [other componentsSeparatedByString:@"a"];

  // The parts before the "a"
  NSString *oneMain = [oneComponents objectAtIndex:0];
  NSString *twoMain = [twoComponents objectAtIndex:0];

  // If main parts are different, return that result, regardless of alpha part
  NSComparisonResult mainDiff;
  if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame) {
    return mainDiff;
  }

  // At this point the main parts are the same; just deal with alpha stuff
  // If one has an alpha part and the other doesn't, the one without is newer
  if ([oneComponents count] < [twoComponents count]) {
    return NSOrderedDescending;

  } else if ([oneComponents count] > [twoComponents count]) {
    return NSOrderedAscending;

  } else if ([oneComponents count] == 1) {
    // Neither has an alpha part, and we know the main parts are the same
    return NSOrderedSame;
  }

  // At this point the main parts are the same and both have alpha parts. Compare the alpha parts
  // numerically. If it's not a valid number (including empty string) it's treated as zero.
  NSNumber *oneAlpha = [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
  NSNumber *twoAlpha = [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
  return [oneAlpha compare:twoAlpha];
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
  return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)sha1Hash {
  return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}
@end



