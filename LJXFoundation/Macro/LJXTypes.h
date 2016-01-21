//
//  LJXTypes.h
//  LJXFoundation
//
//  Created by steven on 12/25/12.
//  Copyright (c) 2012 steven. All rights reserved.
//

#ifndef LJXFoundation_IMTypes_h
#define LJXFoundation_IMTypes_h

#import <Foundation/Foundation.h>

//#if !defined(CGFLOAT_DEFINED)
//# define CGFLOAT_TYPE double
//typedef CGFLOAT_TYPE CGFloat;
//#endif

typedef unsigned long long LJXFileLength;
typedef LJXFileLength LJXFilePosition;
typedef LJXFileLength LJXDiskSize;

typedef void (^LJXBlock)(void); // compatible with dispatch_block_t
typedef void (^LJXSenderBlock)(id sender);
typedef void (^LJXBoolBlock)(BOOL yes);

typedef void (^LJXalidateBlock)(BOOL result); // compatible with dispatch_block_t
typedef void(^LJXIndexBlock)(NSInteger index);
typedef void(^LJXFloatBlock)(float value);
typedef void(^LJXErrorBlock)(NSError* error);
typedef void(^LJXResultBlock)(id result, NSError* error);
typedef void(^LJXURLBlock)(NSURL* url);
typedef void(^LJXStringBlock)(NSString* string);
typedef void(^LJXIdBlock)(id obj);
typedef  LJXResultBlock LJXDoneBlock;

#if !defined(FT_SUCCESS)
#define FT_SUCCESS 0
#endif

#if !defined(FT_ERROR)
#define FT_ERROR -1
#endif

typedef  unsigned short     FT_UINT16;
typedef  unsigned int       FT_UINT32;
typedef  unsigned long long FT_UINT64;

typedef  short     FT_INT16;
typedef  int       FT_INT32;
typedef  long long FT_INT64;

typedef  unsigned long long FT_FILE_LENGTH;

typedef  FT_UINT32 FT_SIZE;
//typedef CGRect LJXRect;

#endif
