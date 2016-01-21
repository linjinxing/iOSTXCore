//
//  DebugTools.h
//  ZM
// 
//  Created by apple on 09-11-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

/* 
    警告信息和错误信息都会写到日志，log信息会根据设置，是否写到文件。
 
 */


#ifndef __IMDebugH__
#define __IMDebugH__

#ifdef __cplusplus
extern "C" {
#endif

typedef enum tagIMErrorType
{
	LJXErrorTypeNone,            /* 自定义错误  */
	LJXErrorTypePError,          /* 由perror打印的错误 */
	LJXErrorTypeNSError,        /* NSError 类型错误 */
    LJXErrorTypeNSException        /* NSException 类型错误 */
}LJXErrorType;
	
typedef enum tagIMWarnLevel
{
	LJXWarnLevelPrompt,     /* 提示  */
	LJXWarnLevelMiddle,     /* 中等程序警告  */
    LJXWarnLevelSerious,   /* 严重警告  */
	LJXWarnLevelFatal,        /* 致命警告  */
}LJXDebugWarnLevel;
    
typedef enum tagIMDebugModel
{
    LJXDebugModelTmp = 0x01,
    LJXDebugModelFoundation = 0x01 << 1,
    LJXDebugModelUI = 0x01 << 2,
    LJXDebugModelBrowser = 0x01 << 3,
    LJXDebugModelFiles = 0x01 << 4,
    LJXDebugModelPayment = 0x01 << 5,
    LJXDebugModelPlayer = 0x01 << 6,
    LJXDebugModelRadar = 0x01 << 7,
    LJXDebugModelScanImage = 0x01 << 8,
    LJXDebugModelStatistic = 0x01 << 9,
    LJXDebugModelUser = 0x01 << 10,
    LJXDebugModelWebsite = 0x01 << 11,
    LJXDebugModelPrefrencesSetup = 0x01 << 12,
    LJXDebugModelAdvertisement = 0x01 << 13,
    LJXDebugModelPP = 0x01 << 14,
    LJXDebugModelMV = 0x01 << 15,
    LJXDebugModelRouterSettings = 0x01 << 16,
    LJXDebugModelFlow = 0x01 << 17,
    LJXDebugModelALL = 0xFFFFFFFF,
}LJXDebugModel;

    /* 基础 */
#define LJXFoundationLog(format, ...) LJXDebugTrace(LJXDebugModelFoundation, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)

    
    /* UI */    
#define LJXUILog(format, ...) LJXDebugTrace(LJXDebugModelUI, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)

#define LJXBrowserLog(format, ...) LJXDebugTrace(LJXDebugModelBrowser, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXFilesLog(format, ...) LJXDebugTrace(LJXDebugModelFiles, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define IMPaymentLog(format, ...) LJXDebugTrace(LJXDebugModelPayment, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define IMPlayerLog(format, ...) LJXDebugTrace(LJXDebugModelPlayer, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXRadarLog(format, ...) LJXDebugTrace(LJXDebugModelRadar, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXScanImageLog(format, ...) LJXDebugTrace(LJXDebugModelScanImage, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXStatisticLog(format, ...) LJXDebugTrace(LJXDebugModelStatistic, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXUserLog(format, ...) LJXDebugTrace(LJXDebugModelUser, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXWebsiteLog(format, ...) LJXDebugTrace(LJXDebugModelWebsite, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define IMPrefrencesLog(format, ...) LJXDebugTrace(LJXDebugModelPrefrencesSetup, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXAdLog(format, ...) LJXDebugTrace(LJXDebugModelAdvertisement, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define IMPPLog(format, ...) LJXDebugTrace(LJXDebugModelPP, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)

#define IMPPMV(format, ...) LJXDebugTrace(LJXDebugModelMV, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)

#define LJXRouterSettingsLog(format, ...) LJXDebugTrace(LJXDebugModelRouterSettings, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
#define LJXDebugModelFlowLog(format, ...) LJXDebugTrace(LJXDebugModelFlow, __FILE__, __LINE__, _FUNCTION_NAME, format, ##__VA_ARGS__)
    
    /* 打印bool值  */
#define LJXLogBool(b)                             LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "%s :%s\n", #b, b ? "yes" : "no")

    /* 打印object值  */
#define LJXLogObject(obj)                       LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "%s :%@\n", #obj, obj)

    /* 打印CGSize值  */
#define LJXLogSize(size)                          LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "%s:%@\n", #size, NSStringFromCGSize(size))

    /* 打印CGPoint值  */
#define LJXLogPoint(p)                            LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "%s:%@\n", #p, NSStringFromCGPoint(p))
    
    /* 打印UIEdgeInset值  */
#define LJXLogEdgeInset(edgeInsets)    LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "%@-left:%f, right:%f, top:%f, bottom:%f\n", #edgeInsets, edgeInsets.left, edgeInsets.right, edgeInsets.top, edgeInsets.bottom)
    
    /* 打印CGRect值  */
#define LJXLogRect(rect)                         LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "%s:%@\n", #rect, NSStringFromCGRect(rect))
    
    /* 打印view的frame值  */
#define LJXLogViewFrame(view)             LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "%s frame:%@\n", #view, NSStringFromCGRect(view.frame))
    
    /* 打印时间值  */
#define LJXLogClock                                LJXDebugTrace(LJXDebugModelTmp,__FILE__, __LINE__, _FUNCTION_NAME, "clock:%ld\n", clock())
    
    /* 打印self值  */
#define LJXLogSelf                                   LJXDebugTrace(LJXDebugModelTmp, __FILE__, __LINE__, _FUNCTION_NAME, "self:%@", self)

    /* 打印函数名  */    
#define LJXLogFunction                        LJXDebugTrace(LJXDebugModelTmp,  __FILE__, __LINE__, _FUNCTION_NAME, "")
    
#define LJXWarn(WarnLevel, format, ...)  LJXDebugWarn(WarnLevel, __FILE__, __LINE__, format, ##__VA_ARGS__)
    
    /* 提示的警告信息 */
#define LJXWarnPrompt(format, ...)  LJXDebugWarn(LJXWarnLevelPrompt, __FILE__, __LINE__, format, ##__VA_ARGS__)
    /* 中等程序的警告信息 */
#define LJXWarnMiddle(format, ...)  LJXDebugWarn(LJXWarnLevelMiddle, __FILE__, __LINE__, format, ##__VA_ARGS__)
    /* 严重的警告信息 */
#define LJXWarnSerious(format, ...)  LJXDebugWarn(LJXWarnLevelSerious, __FILE__, __LINE__, format, ##__VA_ARGS__)
    /* 致命的警告信息 */
#define LJXWarnFatal(format, ...)  LJXDebugWarn(LJXWarnLevelFatal, __FILE__, __LINE__, format, ##__VA_ARGS__)

        /* 打印通用的错误信息 */
#define LJXError(format, ...)  LJXDebugReportError(LJXErrorTypeNone, __FILE__, __LINE__, _FUNCTION_NAME, NULL,  format, ##__VA_ARGS__)
    
#ifdef __OBJC__
            /* 打印NSError错误信息 */
#define LJXNSError(error)  do{ \
                             if(error) \
                                    LJXDebugReportError(LJXErrorTypeNSError, __FILE__, __LINE__, _FUNCTION_NAME, (__bridge void *)error, NULL); \
                            }while(0)
    
            /* 打印NSError格式化类型错误信息 */
#define LJXNSErrorWithFormat(error, format, ...)  LJXDebugReportError(LJXErrorTypeNSError, __FILE__, __LINE__, _FUNCTION_NAME, (__bridge void *)error, format, ##__VA_ARGS__)
    
            /* 打印异常错误信息 */
#define LJXNSExceptionError(exception)  LJXDebugReportError(LJXErrorTypeNSException, __FILE__, __LINE__, _FUNCTION_NAME, (__bridge void *)exception, NULL)

            /* 打印异常格式化错误信息 */
#define LJXNSExceptionErrorWithFormat(exception, format, ...)  LJXDebugReportError(LJXErrorTypeNSException, __FILE__, __LINE__, _FUNCTION_NAME, (__bridge void *)exception, format, ##__VA_ARGS__)
#endif
    
#undef model
    
    typedef struct tagIMDebugModelName
    {
        const char name[32]; /* 模块名字 */
        const LJXDebugModel model;
    }LJXDebugModelName;
    
    typedef enum tagIMDebugOutput
    {
        LJXDebugOutputConsole = 0x01,   /* 打印到控制台 */
        LJXDebugOutputFile = 0x01 << 1,   /* 打印到文件 */
        LJXDebugOutputAll = (LJXDebugOutputConsole|LJXDebugOutputFile)
    }LJXDebugOutput;
    

    
#if  defined(_DEBUG) || defined(DEBUG)
    /* 获取log文件路径 */
    const char* LJXDebugLogPath();
    
    /* 获取到所有模块名字和枚举, count返回个数 */
    const LJXDebugModelName* LJXDebugGetModelName(unsigned int* count);
    
    /* 设置当前哪些模块输出debug信息 */
    void LJXDebugSetLogModel(int in_module);
    int LJXDebugGetLogModel();
    
    /* 设置当前log信息输出到哪里 */
    void LJXDebugSetOutputModel(LJXDebugOutput output);
    LJXDebugOutput LJXDebugGetOutputModel();
    
    void LJXDebugTrace(
                      int in_module,                      
                    const char* in_file,
                    unsigned int in_line,
                    const char* in_functionName,
                    const char* in_fmt,
                    ...);
    
    void LJXDebugWarn(LJXDebugWarnLevel in_level,
                         const char* in_file,
                         unsigned int in_line,
                         const char* in_fmt,
                         ...);
    
    void LJXDebugReportError(LJXErrorType in_ErrorType,
                                const char* in_file,
                                unsigned int in_line,
                                const char* in_functionName,
                                void* nstype,
                                const char* in_fmt,
                                ...);
    
    void LJXDebugAssert(const char* in_expresstion,
                           const char* in_file, 
                           unsigned int in_line,
                           const char* in_functionName,
                           const char* in_fmt, 
                           ...);
    
    #define  _FUNCTION_NAME __PRETTY_FUNCTION__
    //    #ifdef __OBJC__
    //        #define  _FUNCTION_NAME [NSStringFromSelector(_cmd) UTF8String]
    //    #else
    //        #define  _FUNCTION_NAME __func__
    //    #endif
    //
    //
    //    #if !defined(_cmd)
    //        #undef _FUNCTION_NAME
    //        #define  _FUNCTION_NAME __func__
    //    #endif
    
#ifdef __OBJC__
    #define LJXAssertWithFormat(expression, format, ...)  NSAssert(expression,@format,##__VA_ARGS__)
    #define LJXAssert(expression)  NSAssert(expression, nil)
#else
    #define LJXAssertWithFormat(expression, format, ...)  do{       \
                                                                if (!(expression))    \
                                                                {    \
                                                                    LJXDebugAssert(#expression,  \
                                                                    __FILE__,                       \
                                                                    __LINE__,                       \
                                                                    _FUNCTION_NAME,  \
                                                                    format,                         \
                                                                    ##__VA_ARGS__);                 \
                                                                }     \
                                                       }while(0)
    
    #define LJXAssert(expression)  do{       \
                                                            if (!(expression))    \
                                                            {    \
                                                                LJXDebugAssert(#expression,  \
                                                                __FILE__,                       \
                                                                __LINE__,                       \
                                                                _FUNCTION_NAME,  \
                                                                NULL);                 \
                                                            }     \
                                                    }while(0)
#endif
//
//    #define LJXDebugERROR(type, error, format, ...)	LJXDebugReportNSError(type, error, __FILE__, __LINE__, \
//                                                                format, ##__VA_ARGS__)

#else
    #define LJXDebugTrace(...)
    #define LJXDebugWarn(...)
    #define LJXDebugReportError(...)
    #define LJXAssert(...)
    #define LJXAssertWithFormat(...)
#endif
    
#ifdef __cplusplus
}
#endif

#endif

