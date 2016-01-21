//
//  NSFileManager(category).h
//  jokes
//
//  Created by apple on 10-6-30.
//  Copyright 2010 Shenzhen Palmedia technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager(category)
/* */
+(BOOL)removeFileAtDocumentWithName:(NSString*)aName;
+(BOOL)removeAllFilesAtDocument;
+(BOOL)removeFilePath:(NSString *)fullPath;


+ (uint64_t)freeDisksapce;

+(NSArray*)filesAtDocument;
+(NSString*)documentsPath;
+(NSString*)libraryPath;
+(NSString*)cachesPath;
+(BOOL)copyBundleFileToDocumentIfNeed:(NSString*)filename;
+(BOOL)copyBundleFile:(NSString*)fromFileName toDocument:(NSString*)toFileName;
+(BOOL)copyBundleFile:(NSString*)fromFileName toDocumentPrefixPath:(NSString*)toFileName;

+(BOOL)fileExistsInDocumentsWithName:(NSString*)aName;
+(BOOL)fileExistsInPath:(NSString*)path;
+(BOOL)createDirectory:(NSString*)dir;
+(NSString*)filePathInDocumentsWithFileName:(NSString*)aName;
+(NSString*)filePathInBundleWithFileName:(NSString*)aName;
/* aExtension 可以使用","进行分割，例如 "mov,mp4"则返回mov和mp４文件，传入nil 时，返回所有 */
+(NSArray*)searchFilesAtResourcePathWithExtension:(NSString*)aExtension;

/* aExtension 可以使用","进行分割，例如 "mov,mp4"则返回mov和mp４文件，传入nil 时，返回所有 */
+(NSArray*)searchFilesAtPath:(NSString*)aPath withExtension:(NSString*)aExtension  recursion:(BOOL)aRecursion  error:(NSError**)error;

+(id)getFileAttr:(NSString *)fileName withAttr:(NSString * const)attrName;
+(id)getFileAttr:(NSString * const)attrName atPath:(NSString *)fullPath;

+(BOOL)createFileAtPath:(NSString *)absolutePath;

@end
