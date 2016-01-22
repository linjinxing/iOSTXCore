//
//  NSFileManager(category).m
//  jokes
//
//  Created by apple on 10-6-30.
//  Copyright 2010 Shenzhen Palmedia technology co., ltd. All rights reserved.
//
#define ENABLE_SHOW_LOG          1

#define KEY_DOWNLOAD_PATH           @"Key_Download_path"

#import "NSFileManagerAdditions.h"
#import "NSStringAdditions.h"
#import "LJXDebug.h"
#import "LJXSystem.h"
//#import "LJXGlobalUICommon.h"

@implementation NSFileManager(category)

//- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error
//{
//    //NSLog(@"path:%@\n", path);
//    return NO;
//}
//
//- (BOOL)removeItemAtURL:(NSURL *)URL error:(NSError **)error
//{
//    //NSLog(@"URL:%@\n", URL);    
//    return NO;
//}
//
//- (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error
//{
//       //NSLog(@"srcPath:%@\n", srcPath); 
//    return NO;
//}
//
//- (BOOL)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error{
//    //NSLog(@"srcURL:%@\n", srcURL);        
//     return NO;   
//}

+ (BOOL)removeFilePath:(NSString *)fullPath
{
    return [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
}

+ (BOOL)removeFileAtDocumentWithName:(NSString*)aName
{
    NSString* path = [self filePathInDocumentsWithFileName:aName];
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        LJXError( "[removeFileAtDocumentWithName] failed 2 remove file:%@\n", aName);
        return FALSE;
    }else{
        return TRUE;
    }
}

+ (BOOL)removeAllFilesAtDocument
{
    return [self removeFileAtDocumentWithName:nil];
}

+ (uint64_t)freeDisksapce
{
        uint64_t totalSpace = 0.0f;
        uint64_t totalFreeSpace = 0.0f;
        NSError *error = nil;  
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
        
        if (dictionary) {  
            NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];  
            NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
            totalSpace = [fileSystemSizeInBytes floatValue];
            totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
            //NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
        } else {  
            //NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
        }  
#define  _200M  (200 * (1ll << 20)) 
    if ( totalFreeSpace > 200) totalFreeSpace -= _200M;  ////   系统会预留200M，因此这里减去200
        return totalFreeSpace;
}

+ (NSArray*)filesAtDocument
{
    NSMutableArray* results = nil;
    NSFileManager *localFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum =  [localFileManager enumeratorAtPath:[self documentsPath]];
    
    NSString *file = nil;
    results = [NSMutableArray arrayWithCapacity:100];
    while ((file = [dirEnum nextObject])) {
        [results addObject:file];
    }
//    [localFileManager release];
    return results;    
}


//-(void)searchFilesAtPath:(NSString*)aPath withExtension:(NSString*)aExtension result:(NSMutableArray*)aResult  recursion:(BOOL)aRecursion
//{
//    NSMutableArray* results = nil;
//    NSFileManager *localFileManager = [NSFileManager defaultManager];
//    NSDirectoryEnumerator *dirEnum =  [localFileManager enumeratorAtPath:aPath];
//    
//    NSString *file = [dirEnum nextObject];
//    results = [NSMutableArray arrayWithCapacity:100];
//    while (file) {
//        // LJXFoundationLog("[searchFilesInDocumentWithExtension] file:%@\n", file);
//        if (NSOrderedSame == [[file pathExtension] caseInsensitiveCompare: aExtension])
//        {
//            // process the document
//            [results addObject:file];
//        }
//        file = [dirEnum nextObject];
//    } 
//}

+(NSArray*)searchFilesAtPath:(NSString*)aPath withExtension:(NSString*)aExtension  recursion:(BOOL)aRecursion error:(NSError**)error
{
    NSArray *fileNames = nil;
    NSMutableArray *results = nil;
    
    fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aPath error:error];
    results = [NSMutableArray arrayWithCapacity:[fileNames count]];    
    if (fileNames) {
        LJXError( "error:%@\n",  *error);
    }else{
        for (NSString * fileName in fileNames) 
        {
            NSString* fullPath = [aPath stringByAppendingPathComponent:fileName];    
            if (aRecursion && [fullPath isDirectory]) {
                [results addObjectsFromArray:[self searchFilesAtPath:fullPath withExtension:aExtension recursion:aRecursion]];
            }else{
                if (nil == aExtension || [fileName isFileWithExtention:aExtension]) {
                    [results addObject:fullPath];                    
                }
            }
        }
    }    
    
    return results; 
}

+(NSArray*)searchFilesAtResourcePathWithExtension:(NSString*)aExtension
{
    return nil;   
}

+(NSArray*)searchFilesAtDocumentWithExtension:(NSString*)aExtension recursion:(BOOL)aRecursion
{
    NSString* docPath = nil;
#if defined(_DEBUG_VERSION)
    /* 每个人可以根据自己的修改 */
    if ([LJXSystem isSimulator]) {
        NSError* error = nil;
        docPath = [NSString stringWithContentsOfFile:@"/VideoFileDocumentPath.cfg" encoding:NSUTF8StringEncoding error:&error];    
        if (error) {
            //LJXError( "error:%@\n", error);
        }else{
            //LJXFoundationLog("docPath:%@\n", docPath);
        }
    }
    if (nil == docPath) 
#endif
    {
        docPath = [self documentsPath];            
    }
    
    NSArray *array = [self searchFilesAtPath:docPath withExtension:aExtension recursion:aRecursion];
    NSMutableArray *newFilesArray = [NSMutableArray arrayWithArray:array];
    
    array = [self searchFilesAtPath:docPath withExtension:aExtension recursion:aRecursion];
    if (array != nil) {
        [newFilesArray addObjectsFromArray:array];
    }
    
    return newFilesArray;
}

+(NSString*)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; 
}
+(NSString*)libraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}
+(NSString*)cachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+(NSArray*)searchFilesAtPath:(NSString*)path withExtension:(NSString*)aExtension recursion:(BOOL)aRecursion
{
//    NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
//                         lastObject];    
//    return [self searchFilesAtPath:docsDir withExtension:aExtension];
        return nil;   
}

+(NSString*)filePathInDocumentsWithFileName:(NSString*)aName
{
	NSString* documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
								  lastObject];
    if (aName) {
        return [documentsDir stringByAppendingPathComponent:aName];	        
    }else{
        return documentsDir;
    }
}

+(NSString*)filePathInBundleWithFileName:(NSString*)aName
{
    return [[NSBundle mainBundle] pathForResource:aName ofType:nil];	  
}

+(BOOL)fileExistsInPath:(NSString*)path	
{
	return [[NSFileManager defaultManager] fileExistsAtPath:path];	
}

+(BOOL)createDirectory:(NSString*)dir
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            LJXError( " failed 2 create dir:%@\n", dir);
            return FALSE;
        }
    }
    return TRUE;
}

+(BOOL)fileExistsInDocumentsWithName:(NSString*)aName
{
    NSString *path = [self filePathInDocumentsWithFileName:aName];
#ifdef _DEBUG_VERSION
	BOOL ret = FALSE;
	ret =  [[NSFileManager defaultManager] fileExistsAtPath:path];
	LJXFoundationLog("[fileExistsInDocumentsWithName] aName:%@, ret:%d\n",
			  aName, ret); 
	return ret;
#else
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
#endif
}

+(BOOL)copyBundleFileToDocumentIfNeed:(NSString*)filename
{
    return [self copyBundleFile:filename toDocument:filename];
}

+(BOOL)copyBundleFile:(NSString*)fromFileName toPath:(NSString*)aPath overwrite:(BOOL)aOverwrite
{
    BOOL bSuccess = TRUE;
    //Using NSFileManager we can perform file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //find file path
    NSString *toFilePath = aPath;
    BOOL bFileExist = [fileManager fileExistsAtPath:toFilePath];
	
    // LJXFoundationLog("[copyBundleFile:toDocument] toFilePath:%@, file exist:%s\n",
	//		  toFilePath, YES == bFileExist ? "YES" : "NO");
    
    if (!bFileExist || aOverwrite) {
        NSString *bundleFilePath = [[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:fromFileName];
        //   LJXFoundationLog("[copyBundleFile:toDocument] bundleFilePath:%@\n", bundleFilePath);
        if ([fileManager fileExistsAtPath:bundleFilePath]) 
        {    
            NSError *error = nil;                        
            if  (aOverwrite)
            {
                [fileManager removeItemAtPath:toFilePath error:&error];
            }
            if ( ! [fileManager copyItemAtPath:bundleFilePath  toPath:toFilePath error:&error] )
            {
               LJXError( "Failed to copy file:%@ to doc:%@, error:%@\n",  fromFileName, toFilePath, [error localizedDescription]);
                bSuccess = FALSE;
            }
        }else {
            //     LJXError( "fromFileName don't exist:%@\n",  fromFileName);
            bSuccess = FALSE;
        }
    }    
    return bSuccess;    
}

+(BOOL)copyBundleFile:(NSString*)fromFileName toDocumentPrefixPath:(NSString*)toFileName
{
    NSString *toFilePath = [self filePathInDocumentsWithFileName:toFileName];    
    return [self copyBundleFile:fromFileName toPath:toFilePath overwrite:YES];  
}

+(BOOL)copyBundleFile:(NSString*)fromFileName toDocument:(NSString*)toFileName
{
    NSString *toFilePath = [self filePathInDocumentsWithFileName:toFileName];    
    return [self copyBundleFile:fromFileName toPath:toFilePath overwrite:NO];
}
+(id)getFileAttr:(NSString *)fileName withAttr:(NSString * const)attrName
{
	if (fileName == nil || attrName == nil)
	{
		return nil;
	}
	NSFileManager *defaultManager = [NSFileManager defaultManager];
	NSString *filePath = [NSFileManager filePathInDocumentsWithFileName:fileName];
	if (![defaultManager fileExistsAtPath:filePath])
	{
		return nil;
	}
	NSError *error = nil;
	NSDictionary *attrDic = [defaultManager attributesOfItemAtPath:filePath error:&error];
	
	return [attrDic objectForKey:attrName];
}

+(id)getFileAttr:(NSString * const)attrName atPath:(NSString *)fullPath
{
    if (fullPath == nil || attrName == nil || [fullPath length] == 0)
    {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fullPath])
    {
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *attrDic = [fileManager attributesOfItemAtPath:fullPath error:&error];
    
    return [attrDic objectForKey:attrName];
}

+ (BOOL)createFileAtPath:(NSString *)absolutePath
{
    if (absolutePath == nil || [absolutePath isEqualToString:@""])
    {
        return NO;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:absolutePath])
    {
        return [fileManager createFileAtPath:absolutePath contents:nil attributes:nil];
    }
    
    return YES;
}

+(NSString *)getURLFromSeed:(NSString *)seedPath
{
    if (seedPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:seedPath]) {
        return nil;
    }
    
    NSError *error = nil;
    NSString *seedContent = [NSString stringWithContentsOfFile:seedPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        error = nil;
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        seedContent = [NSString stringWithContentsOfFile:seedPath encoding:enc error:&error];
        if (error) {
            error = nil;
            seedContent = [NSString stringWithContentsOfFile:seedPath encoding:NSUnicodeStringEncoding error:&error];
        } 
    }
    NSString *url = [seedContent substringBetweenString:@"href=\"" anotherString:@"\""];
    url = [url stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"\t" withString:@""];

    return url;
}


@end
