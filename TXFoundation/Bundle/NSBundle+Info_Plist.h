//
//  NSBundle+Info_Plist.h
//  LJXFoundation
//
//  Created by steven on 5/28/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Info_Plist)
//+(NSString*)filePathWithLanguage:(NSString*)aLanguage;
+(NSString*)buildVersion;
+(NSString*)version;
+(NSString*)applicationName;
+(NSString*)displayName;
+(NSString*)identifier;
+(NSString*)executable;
+(NSString*)URLSchemes;
@end
