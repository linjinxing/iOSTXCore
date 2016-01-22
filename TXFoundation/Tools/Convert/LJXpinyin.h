/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by George on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中国共产党万岁！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     LJXFoundationLog("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */
#ifndef __PINYIN_H__

#if defined(__cplusplus)
extern "C" {
#endif

#define NOT_CHINEASE_CHARACTER -1    
    
char pinyinFirstLetter(unsigned short hanzi);

#if defined(__cplusplus)    
};
#endif

#endif
