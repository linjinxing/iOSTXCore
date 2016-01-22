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

#import <Foundation/Foundation.h>
#import "NSStringAdditions.h"

@interface NSString(init)
+ (NSString*)stringWithGBData:(NSData*)aGBData;
+ (NSString*)stringWithInt:(NSInteger)number;
@end

@interface NSString (hex)
-(NSData*) hexToBytes;
@end

@interface NSString(substring)
-(NSString*)substringBetweenRange:(NSRange)range1 anotherRange:(NSRange)range2;
-(NSString*)substringAfterRange:(NSRange)range;
-(NSString*)substringAfterString:(NSString*)string;
-(NSString*)substringBetweenStrings:(NSString*)str1 anotherString:(NSString*)str2;
-(NSString*)substringBetweenString:(NSString*)str;

- (NSString*)substringToString:(NSString*)aStr;
- (NSString*)substringFromString:(NSString*)str;
- (NSString*)substringFromString:(NSString*)str options:(NSStringCompareOptions)mask;
//- (NSString*)substringBetweenString:(NSString*)str;
- (NSString*)substringBetweenString:(NSString*)str1 anotherString:str2;
- (NSString*)substringBetweenString:(NSString*)str1 anotherString:str2  range:(NSRange)searchRange;

@end




@interface NSString (time)
+(NSString*)stringPlayTimeWidthTime:(NSTimeInterval)aTimeInterval;
+(NSString*)stringDateWidthTime:(NSTimeInterval)aTimeInterval;
+(NSString*)stringDurationWithTimeInterval:(NSTimeInterval)aTimeInterval;
/* 返回时间的格式化，如果是0，则不显示 */
+(NSString*)stringWithTimeInterval:(NSTimeInterval)aTimeInterval;
@end

@interface NSString (LJX)
+ (NSString*)stringWithFileLen:(long long)fileLength ;
+ (NSString*)stringWithFileLen:(long long)fileLength  downloadProgress:(float)downloadProgress;
+ (NSString *)convertGBMBKBFromByte:(long long)byteSize decimals:(NSUInteger)decimals ;

//- (NSString*)stringWithDownloadSpeed:(NSInteger)fileLength;
@end

@interface NSString (fileManager)
-(BOOL)removeFileAtDocument;
-(BOOL)removeFile;
-(BOOL)isDirectory;
-(BOOL)createDirectory;
-(BOOL)modifyNameToString:(NSString*)aName;
- (BOOL)isFileWithExtention:(NSString*)aExtension;
- (BOOL)canHardwareDecode;
- (NSString*)fileType;
- (NSDate*) fileCreateDate;
- (NSDate*) fileModificationDate;
@end

@interface NSString(keyPath)
- (NSString*)stringByAppendingKeyPath:(NSString*)path;
@end

@interface NSString(pinyin)
//-(NSString*)firstPinYin;
@end

@interface NSString(url)
- (NSString *)urlencode;
- (NSStringEncoding)htmlContentStringEncoding;
@end

 // For __IMDEPRECATED_METHOD
/**
 * Doxygen does not handle categories very well, so please refer to the .m file in general
 * for the documentation that is reflected on api.three20.info.
 */
@interface NSString (lyric)
- (NSTimeInterval)lyricTime;
@end

@interface NSString (NSRegularExpression)
- (NSString*)firstMatchWithPattern:(NSString*)pattern;
@end

@interface NSString (LJXAdditions)


/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 * @deprecated Use LJXIsStringWithAnyText() instead. Updating your use of
 * this method is non-trivial. See the note below.
 *
 * Notes for updating your use of isEmptyOrWhitespace:
 *
 * if (!textField.text.isEmptyOrWhitespace) {
 *
 * becomes
 *
 * if (LJXIsStringWithAnyText(textField.text) && !textField.text.isWhitespaceAndNewlines) {
 *
 * and
 *
 * if (textField.text.isEmptyOrWhitespace) {
 *
 * becomes
 *
 * if (0 == textField.text.length || textField.text.isWhitespaceAndNewlines) {
 */
- (BOOL)isEmptyOrWhitespace ;

/**
 *  检测是否含有characterStr中的字符.
 *
 *  @param characterStr 包含所要检测的字符的字符串
 *
 *  @return 若包含characterStr中的字符，则返回YES，否则返回NO
 */
- (BOOL)containsCharactersFromString:(NSString*)characterStr;

/**
 *  检测是否只含有characterStr中的字符.
 *
 *  @param characterStr 包含所要检测的字符的字符串
 *
 *  @return 若只好汉characterStr中的字符，则返回YES，否则返回NO
 */
- (BOOL)onlyContainsCharactersFromString:(NSString*)characterStr;

/**
 *  检测是否含有中文
 *
 *  @return 若含有中文，返回YES，否则返回NO
 */
- (BOOL)containsChinese;

/**
 * Parses a URL query string into a dictionary.
 *
 * @deprecated Use queryContentsUsingEncoding: instead.
 */
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding ;

/**
 * Parses a URL query string into a dictionary where the values are arrays.
 */
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 * Returns a string with all HTML tags removed.
 */
//- (NSString*)stringByRemovingHTMLTags;

/**
 * Compares two strings expressing software versions.
 *
 * The comparison is (except for the development version provisions noted below) lexicographic
 * string comparison. So as long as the strings being compared use consistent version formats,
 * a variety of schemes are supported. For example "3.02" < "3.03" and "3.0.2" < "3.0.3". If you
 * mix such schemes, like trying to compare "3.02" and "3.0.3", the result may not be what you
 * expect.
 *
 * Development versions are also supported by adding an "a" character and more version info after
 * it. For example "3.0a1" or "3.01a4". The way these are handled is as follows: if the parts
 * before the "a" are different, the parts after the "a" are ignored. If the parts before the "a"
 * are identical, the result of the comparison is the result of NUMERICALLY comparing the parts
 * after the "a". If the part after the "a" is empty, it is treated as if it were "0". If one
 * string has an "a" and the other does not (e.g. "3.0" and "3.0a1") the one without the "a"
 * is newer.
 *
 * Examples (?? means undefined):
 *   "3.0" = "3.0"
 *   "3.0a2" = "3.0a2"
 *   "3.0" > "2.5"
 *   "3.1" > "3.0"
 *   "3.0a1" < "3.0"
 *   "3.0a1" < "3.0a4"
 *   "3.0a2" < "3.0a19"  <-- numeric, not lexicographic
 *   "3.0a" < "3.0a1"
 *   "3.02" < "3.03"
 *   "3.0.2" < "3.0.3"
 *   "3.00" ?? "3.0"
 *   "3.02" ?? "3.0.3"
 *   "3.02" ?? "3.0.2"
 */
- (NSComparisonResult)versionStringCompare:(NSString *)other;

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString* sha1Hash;

@end
