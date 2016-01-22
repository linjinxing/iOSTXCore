//
//  NSString+UrlAddition.m
//  LJXWebsite
//
//  Created by Zhang Jing on 13-2-26.
//  Copyright (c) 2013年 steven. All rights reserved.
//

#import "NSString+UrlAddition.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSString (UrlAddition)

- (BOOL)isHostEqualToURL:(NSString*)url
{
    NSURL* urlurl = [NSURL URLWithString:self];
    return [[urlurl host] isEqualToString:url];
}

- (BOOL)isLocalHost
{
    return [self isHostEqualToURL:@"127.0.0.1"];
}

#pragma mark -
#pragma mark Http相关

- (NSDictionary *)queryParams
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *array = [self componentsSeparatedByString:@"&"];
    for (NSString *a in array) {
        NSArray *keyAndValue = [a componentsSeparatedByString:@"="];
        NSString *key = [keyAndValue objectAtIndex:0];
        NSString *value = [keyAndValue objectAtIndex:1];
        value = [value urlDecode];
        [dic setValue: value forKey:key];
    }
    return dic;
}

//
//- (NSString *)urlEncode
//{
//    if (self == nil) {
//        return nil;
//    }
//    unsigned char charSt[2*1024] = {0};
//    memset(charSt, 0, sizeof(charSt));
//    strncpy((char*)charSt, [self UTF8String], sizeof(charSt));
//    unsigned char *encoded = urlencodeC(charSt);
//    NSString *result = [NSString stringWithUTF8String:(const char*)encoded];
//    free(encoded);
//    return  result;
//}

- (NSString *)urlDecode
{
    if (self == nil) {
        return nil;
    }
    
    unsigned char charSt[2*1024] = {0};
    memset(charSt, 0, sizeof(charSt));
    strncpy((char*)charSt, [self UTF8String], sizeof(charSt));
    
    unsigned char *decoded = urldecodeC(charSt);
    NSString *result = [NSString stringWithUTF8String:(const char *)decoded];
    free(decoded);
    
    return result;
}

- (NSString *)urlEncodeGB2312
{
    if (self == nil) {
        return nil;
    }
    unsigned char charSt[2*1024] = {0};
    memset(charSt, 0, sizeof(charSt));
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    strncpy((char*)charSt, [self cStringUsingEncoding:encoding], sizeof(charSt));
    unsigned char *encoded = urlencodeC(charSt);
    
    NSString *result = [NSString stringWithCString:(const char*)encoded encoding:NSUTF8StringEncoding];
    free(encoded);
    return  result;
}

- (NSURL*)nsurl
{
    NSString* str = [self lowercaseString];
    if ([str hasPrefix:@"http"]) {
        return [NSURL URLWithString:self];
    }else{
        NSString* url = self;
        NSString* prefix = @"file://";
        if ([[self lowercaseString] hasPrefix:prefix]) {
            url = [[self stringByReplacingCharactersInRange:NSMakeRange(0, [prefix length]) withString:@""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        return [NSURL fileURLWithPath:url];
    }
}

unsigned char* urlencodeC(unsigned char *string) {
    
    int escapecount = 0;
    unsigned char *src, *dest;
    unsigned char *newstr;
    
    char hextable[] = { '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
    
    
    if (string == NULL) return NULL;
    
    for (src = string; *src != 0; src++)
        if (!isalnum(*src)) escapecount++;
    
    //字母或数字的个数+非字母和数字的个数*3+1('\0')
    int newLength = strlen((char *)string) - escapecount + (escapecount * 3) + 1;
    newstr = (unsigned char *)malloc(newLength);
    
    src = string;
    dest = newstr;
    
    while (*src != 0) {
        if (!isalnum(*src)) {
            *dest++ = '%';
            *dest++ = hextable[*src >> 4];
            *dest++ = hextable[*src & 0x0F];
            src++;
            
        } else {
            *dest++ = *src++;
        }
    }
    
    *dest = 0;
    
    return newstr;
    
}

unsigned char* urldecodeC(unsigned char *string) {
    
    int destlen = 0;
    unsigned char *src, *dest;
    unsigned char *newstr;
    
    if (string == NULL) return NULL;
    
    for (src = string; *src != 0; src++) {
        if (*src == '%') { src+=2; }
        destlen++;
    }
    
    
    newstr = (unsigned char *)malloc(destlen + 1);
    src = string;
    dest = newstr;
    while (*src != 0) {
        if (*src == '%') {
            char h = toupper(src[1]);
            char l = toupper(src[2]);
            int vh, vl;
            vh = isalpha(h) ? (10+(h-'A')) : (h-'0');
            vl = isalpha(l) ? (10+(l-'A')) : (l-'0');
            *dest++ = ((vh<<4)+vl);
            src += 3;
            
        }
        else if (*src == '+') {
            *dest++ = ' ';
            src++;
        } else {
            *dest++ = *src++;
        }
    }
    *dest = 0;
    return newstr;
}


- (BOOL)isAudiovisualContent
{
    NSString *pathExtension = [self pathExtension];
    CFStringRef preferredUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)pathExtension, NULL);
    BOOL fileConformsToUTI = UTTypeConformsTo(preferredUTI, kUTTypeAudiovisualContent);
    CFRelease(preferredUTI);
    return fileConformsToUTI;
}

- (BOOL)isiPodOrAssetURL
{
    NSString* lowcaseURL = [self lowercaseString];
    return  ( [lowcaseURL hasPrefix:@"ipod-library:"]  || [lowcaseURL hasPrefix:@"assets-library:"]);
}

- (BOOL)isRemoteURL
{
    NSString *lowcaseURL = [self lowercaseString];
    return [lowcaseURL hasPrefix:@"http:"];
}



- (NSString *)URLEncode {
    return [self URLEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)URLDecode {
    return [self URLDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
