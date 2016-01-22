//
//  LJXUIMacros.h
//  iMove
//
//  Created by linjinxing on 7/30/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//



#import "LJXUIBlocks.h"


#define LJXIs3Dot5InchIphone   (!([[UIScreen mainScreen] bounds].size.height > 481.0f))

#define UIColorFromRGBA(r, g, b, a) \
                          [UIColor colorWithRed:((float)(r)/255.0) \
                          green:((float)(g)/255.0) \
                          blue:((float)(b)/255.0) \
                          alpha:a]

#define UIColorFromRGB(r, g, b)  UIColorFromRGBA(r, g, b, 1.0)

#define UIColorFromRGBHex(rgbValue) UIColorFromRGB(((rgbValue & 0xFF0000) >> 16), ((rgbValue & 0x00FF00) >> 8), (rgbValue & 0x0000FF))


#define LJXShowAlertView(title,msg) do{\
                                     UIAlertView* av = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];\
                                     [av show];\
                                   }while(0)
