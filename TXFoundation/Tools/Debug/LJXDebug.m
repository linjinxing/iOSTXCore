//
//  DebugTools.m
//  ZM
//
//  Created by apple on 09-11-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <assert.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>

#import "LJXDebug.h"


//#import "NSFileManagerAdditions.h"
//#import "LJXBundle.h"

#define OUTPUT_FILE_NAME

#undef LJXDebugTrace

#if defined(_DEBUG) || defined(DEBUG)

typedef struct tagIMDebugData
{
    unsigned int model;
    LJXDebugOutput output;
}LJXDebugData;

static NSString* keyModel = @"LJXDebugDataModel";
static NSString* keyOutput = @"LJXDebugDataOutput";

static LJXDebugData s_TraceModule = {LJXDebugModelALL,
    #if defined(DEBUG)
    LJXDebugOutputAll
    #else
    LJXDebugOutputFile
    #endif
};


//static unsigned int LJXDebugGetStrLength(const unsigned short*in_str);
static char* LJXDebugGetFileName(char* out_pszFileName,
									unsigned int in_uiBufferSize, 
									const char* in_pszFilePath);
static NSString* LJXDebugAddDatePrefix(NSString*msg);


#define ModelName(modell)  #modell, modell



static LJXDebugModelName s_names[] = {
    ModelName(LJXDebugModelTmp),
    ModelName(LJXDebugModelFoundation),
    ModelName(LJXDebugModelUI),
    ModelName(LJXDebugModelBrowser),
    ModelName(LJXDebugModelFiles),
    ModelName(LJXDebugModelPayment),
    ModelName(LJXDebugModelPlayer),
    ModelName(LJXDebugModelRadar),
    ModelName(LJXDebugModelScanImage),
    ModelName(LJXDebugModelStatistic),
    ModelName(LJXDebugModelUser),
    ModelName(LJXDebugModelWebsite),
    ModelName(LJXDebugModelPrefrencesSetup),
    ModelName(LJXDebugModelAdvertisement),
    ModelName(LJXDebugModelPP),
    ModelName(LJXDebugModelMV),
    ModelName(LJXDebugModelRouterSettings)
};


void LJXDebugLoadSetting()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id value = [[NSUserDefaults standardUserDefaults] valueForKey:keyModel];
        if (value) {
            s_TraceModule.model = [value integerValue];
        }
        
        value = [[NSUserDefaults standardUserDefaults] valueForKey:keyOutput];
        if (value) {
            s_TraceModule.output = (LJXDebugOutput)[value integerValue];
        }
    });
}

void LJXDebugSetLogModel(int in_module)
{
    s_TraceModule.model = in_module;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:s_TraceModule.model] forKey:keyModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

int LJXDebugGetLogModel()
{
    return s_TraceModule.model;
}

void LJXDebugSetOutputModel(LJXDebugOutput output){
    s_TraceModule.output = output;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:s_TraceModule.output] forKey:keyOutput];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

LJXDebugOutput LJXDebugGetOutputModel(){
    return s_TraceModule.output;
}

const LJXDebugModelName* LJXDebugGetModelName(unsigned int* count)
{
    *count = sizeof(s_names)/sizeof(s_names[0]);
    return s_names;
}

const char* LJXDebugLogPath()
{
    static NSString* path = nil;
    time_t t = time(NULL);
    struct tm* tm = localtime(&t);
    
    NSString* date = nil;
    if (tm) {
        date = [NSString stringWithFormat:@"%d-%02d-%02d %02d-%02d-%02d ", tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec];
    }
    
    if (0 == [date length]) {
        date = [[[NSDate date] description] stringByAppendingString:@" "];
    }
    NSString* name = [date stringByAppendingString:@"LJXodPlayerLog.txt"];
    name = [@"LJXodPlayerLog" stringByAppendingPathComponent:name];
    if (nil == path) {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                 lastObject] stringByAppendingPathComponent:name];
        NSString* logDirectory = [path stringByDeletingLastPathComponent];
        if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                UIAlertView* v = [[UIAlertView alloc] initWithTitle:[error description] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [v show];
            }
        }
    }
    return [path UTF8String];
}



void LJXDebugWriteLog(NSString* str)
{
    static dispatch_once_t onceToken;
    static dispatch_queue_t queue;
    static NSFileHandle* fh = nil;
//    static NSTimer* timer = nil;
//    static BOOL haveData2Write = YES;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.LJXod.log", DISPATCH_QUEUE_SERIAL);
        NSString* path = [NSString stringWithUTF8String:LJXDebugLogPath()];
        NSFileManager* fmng = [NSFileManager defaultManager];
        if (fmng) {
            if (![fmng fileExistsAtPath:path])
            {
                [fmng createFileAtPath:path  contents:nil attributes:nil];
            }
            fh = [NSFileHandle fileHandleForWritingAtPath:path];
            [fh seekToEndOfFile];
//            timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer *inTimer) {
//                if (haveData2Write) {
//                    haveData2Write = NO;
//                    [fh synchronizeFile];
////                    printf("synchronize File \n !!!!!!!!!!!!!!");
//                }
//            }];
//        }else{
//            
        }
    });
    dispatch_async(queue, ^{
        [fh writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [fh synchronizeFile];
    });
}

//static NSLocale* LJXCurrentLocale()
//{
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
//    if (languages.count > 0) {
//        NSString* currentLanguage = [languages objectAtIndex:0];
//        return [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
//        
//    } else {
//        return [NSLocale currentLocale];
//    }
//}

static NSString* LJXDebugAddDatePrefix(NSString*msg)
{
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY:MM:dd HH:mm:ss "];
////    dateformatter.locale = LJXCurrentLocale();
//    NSString* date = [dateformatter stringFromDate:[NSDate date]];
    
    time_t t = time(NULL);
    struct tm* tm = localtime(&t);
    
    NSString* date = nil;
    if (tm) {
        date = [NSString stringWithFormat:@"%4d.%02d.%02d-%02d:%02d:%02d ", tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec];
    }
    
    if (0 == [date length]) {
        date = [[[NSDate date] description] stringByAppendingString:@" "];
    }
    return [date stringByAppendingString:msg];
}


void LJXDebugTrace(
                      int in_module,
					  const char* in_file, 
					  unsigned int in_line, 
                      const char* in_functionName,
					  const char* in_format, 
					  ...)
{
    @autoreleasepool {
        LJXDebugLoadSetting();
        if (in_module & s_TraceModule.model)
        {
            NSString *str =  nil;
            char szFileName[128];
            memset(szFileName, 0, sizeof(szFileName));
            
            if (NULL == in_format)
            {
                str = [[NSString alloc] initWithFormat:@""
#ifdef OUTPUT_FILE_NAME
                       " %s:%d\n",
                       LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
                       in_line
#else
                       " %s\n", in_functionName
#endif
                       ];
            }
            else
            {
                
                va_list argList;
                va_start(argList, in_format);
                NSString* fmt = [NSString stringWithUTF8String:in_format];
                NSString *strFmt = [[NSString alloc] initWithFormat:@""
#ifdef OUTPUT_FILE_NAME
                                    " %s:%d, %@ \n\n",
                                    LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
                                    in_line,
#else
                                    " %s %s\n\n",
                                    in_functionName,
#endif
                                    fmt];
                str = [[NSString alloc] initWithFormat:strFmt arguments:argList];
                //            id firstObj = va_arg(argList, id);
                //            while (firstObj) {
                //                NSLog(@"firstObj:%@", firstObj);
                //                firstObj = va_arg(argList, id);
                //            }
                
                va_end(argList);
            }
            
            if ([str length]) {
                NSString* log = LJXDebugAddDatePrefix(str);
                if (s_TraceModule.output & LJXDebugOutputConsole) {
                    printf("😄 %s", [log UTF8String]);
                }
                if (s_TraceModule.output & LJXDebugOutputFile) {
                    //                NSString* path = [NSFileManager filePathInDocumentsWithFileName:[NSString stringWithFormat:@"%@.txt", [LJXBundle executable]]];
                    LJXDebugWriteLog(log);
                }
            }
        }
    }
}

void LJXDebugWarn(LJXDebugWarnLevel in_level,
					 const char* in_file, 
					 unsigned int in_line, 
					 const char* in_format, 
					 ...)
{
    @autoreleasepool {
        LJXDebugLoadSetting();
        if (NULL == in_format)
        {
            //NSLog(@" !!!!!!!!!!!!!!!!!!!!!!!!! errror !!!!!!!!!!!!!!!!!!!!!!\n"
            //			  " in_format is NULL \n");
        }
        else
        {
            va_list argList;
            char szFileName[128];
            memset(szFileName, 0, sizeof(szFileName));
            va_start(argList, in_format);
            NSString *strFmt = [[NSString alloc] initWithFormat:@" %s:%d, %@ \n\n",
                                LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
                                in_line,
                                [NSString stringWithUTF8String:in_format]];
            NSString *str = [[NSString alloc] initWithFormat:strFmt arguments:argList];
            NSString* log = LJXDebugAddDatePrefix(str);
//            NSString* msg = [@"!!!!!  warning !!!!! " stringByAppendingString:log];
            printf("😭😭😭 %s\n", [log UTF8String]);
            LJXDebugWriteLog(log);
            va_end(argList);
        }
    }
}



void LJXDebugReportError(LJXErrorType in_ErrorType,
							 const char* in_file, 
							 unsigned int in_line, 
                      const char* in_functionName,
                             void* nstype,
							 const char* in_format, 
							 ...)
{
    @autoreleasepool {
        char szFileName[128];
        NSString *str = nil;
        memset(szFileName, 0, sizeof(szFileName));
        LJXDebugLoadSetting();
        if (NULL == in_format)
        {
            if (nstype) {
                str = [[NSString alloc] initWithFormat:@" %s:%d, %s error:%@ \n\n",
                       LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
                       in_line,
                       in_functionName,
                       nstype];
            }else{
                str = [[NSString alloc] initWithFormat:@" %s:%d, %s \n\n",
                       LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
                       in_line,
                       in_functionName];
            }
        }
        else
        {
                va_list argList;
                va_start(argList, in_format);
            NSString *strFmt = nil;
            if (    LJXErrorTypeNSError == in_ErrorType
                ||  LJXErrorTypeNSException == in_ErrorType)
            {
                strFmt = [[NSString alloc] initWithFormat:@" %s:%d, %s %@, error:%@ \n\n",
                          LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
                          in_line,
                          in_functionName,
                          [NSString stringWithUTF8String:in_format],
                           nstype];
            }else{
                strFmt = [[NSString alloc] initWithFormat:@" %s:%d, %s %@ \n\n",
                          LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
                          in_line,
                          in_functionName,
                          [NSString stringWithUTF8String:in_format]];
            }

            str = [[NSString alloc] initWithFormat:strFmt arguments:argList];
    //			printf("\n\n\n!!!!!!!!!!!!!!!!!!!!!!!!! end of errror !!!!!!!!!!!!!!!!!!!!!!\n");
        }
        if ([str length]) {
//            str = [@"\n!!!!! error !!!!! " stringByAppendingString:str];
            NSString* log = LJXDebugAddDatePrefix(str);
            /* 😡😡😡 */
            log = [@"💔💔💔 " stringByAppendingString:log];
            if (in_ErrorType & LJXErrorTypePError)
            {
                perror([log UTF8String]);
            }
            else
            {
                printf("%s", [log UTF8String]);
            }
    //        if (s_TraceModule.output & LJXDebugOutputFile)
            {
                //                NSString* path = [NSFileManager filePathInDocumentsWithFileName:[NSString stringWithFormat:@"%@.txt", [LJXBundle executable]]];
                LJXDebugWriteLog(log);
            }
        }
    }
}

void LJXDebugCurrentThreadDump()
{
    void *frames[128];
    int i,len = backtrace(frames, 128);
    char **symbols = backtrace_symbols(frames,len);
    
    NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:4096];
    
    for (i = 1; i < len; ++i) {
        [buffer appendFormat:@"%s\n",symbols[i]];
    }
    printf("%s", [buffer UTF8String]);
}

void LJXDebugAssert(const char* in_expresstion,
					   const char* in_file, 
					   unsigned int in_line,
                      const char* in_functionName,
					   const char* in_format, 
					   ...)
{
    @autoreleasepool {
        NSString *str =  nil;
        char szFileName[128];
        LJXDebugLoadSetting();
        memset(szFileName, 0, sizeof(szFileName));
        str = [NSString stringWithUTF8String:in_expresstion];
        if (NULL == in_format)
        {
//            str = [[NSString alloc] initWithFormat:@"%s:%d\n\n",
//                   LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
//                   in_line];
        }
        else
        {
            
            va_list argList;
            va_start(argList, in_format);
//            NSString *strFmt = [[NSString alloc] initWithFormat:@"%s:%d, %s %s\n\n",
//                                LJXDebugGetFileName(szFileName, sizeof(szFileName) - 1, in_file),
//                                in_line,
//                                in_functionName,
//                                in_format];
//            str = [[NSString alloc] initWithFormat:[NSString stringWithUTF8String:in_format] arguments:argList];
            str = [str stringByAppendingString:[[NSString alloc] initWithFormat:[NSString stringWithUTF8String:in_format] arguments:argList]];
            va_end(argList);
        }
        //    printf(" !!!!!!!!!!!!!!!!!!!!!!!!! assertion failed !!!!!!!!!!!!!!!!!!!!!!\n");
        
        NSString* log = str ? str : @"";
//        printf("\n!!!!! Assert !!!!! %s", [log UTF8String]);
//        //    if (s_TraceModule.output & LJXDebugOutputFile)
//        {
//            //                NSString* path = [NSFileManager filePathInDocumentsWithFileName:[NSString stringWithFormat:@"%@.txt", [LJXBundle executable]]];
//            LJXDebugWriteLog(log);
//        }
//        [[NSAssertionHandler currentHandler] handleFailureInMethod:NSSelectorFromString([NSString stringWithUTF8String:in_functionName]) object:nil file:[NSString stringWithUTF8String:in_file] lineNumber:in_line description:log];
        LJXDebugCurrentThreadDump();
#if __DARWIN_UNIX03
        __assert_rtn(in_functionName, in_file, in_line, [log UTF8String]);
#else /* !__DARWIN_UNIX03 */
        __assert ([log UTF8String], in_file, in_line);
#endif /* __DARWIN_UNIX03 */
        //    printf("!!!!!!!!!!!!!!!!!!!!!!!!! end of assertion !!!!!!!!!!!!!!!!!!!!!!\n");
    }
}


//static unsigned int LJXDebugGetStrLength(const unsigned short*in_str)
//{
//    const unsigned short* str = in_str;
// 	while (*str)
//	{
//		str++;
//	}
//	//printf("in_str length:%d\n", (str - in_str));
//	return (str - in_str);
//}

static char* LJXDebugGetFileName(char* out_pszFileName, 
								   unsigned int in_uiBufferSize, 
								   const char* in_pszFilePath)
{
    unsigned int uiLenOfPath = 0;
    unsigned int uiIndexOfDirLimiter = 0;
    unsigned int uiCopiedLenOfFileName = 0;
    const char* pszPath = in_pszFilePath;
	
	if (NULL == out_pszFileName || NULL == in_pszFilePath)
	{
		//NSLog(@"parameter error:out_pszFileName:%p, in_pszFilePath:%p\n", out_pszFileName, in_pszFilePath);
	    return NULL;	
	}
	
    while (0 != *pszPath)
    {
		if ('/' == *pszPath++)
		{
			uiIndexOfDirLimiter = uiLenOfPath + 1;
		}
		uiLenOfPath++;
    }
	
    uiCopiedLenOfFileName = (uiLenOfPath - uiIndexOfDirLimiter) > in_uiBufferSize ?
	in_uiBufferSize : (uiLenOfPath - uiIndexOfDirLimiter);
    memcpy(out_pszFileName, in_pszFilePath + uiIndexOfDirLimiter, uiCopiedLenOfFileName);
    out_pszFileName[in_uiBufferSize - 1] = 0;
	
    return out_pszFileName;
}

#endif