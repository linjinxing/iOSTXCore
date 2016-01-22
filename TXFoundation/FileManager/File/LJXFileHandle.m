//
//  LJXHttpFileHandle.m
//  LJXBrowser
//
//  Created by kangyi on 7/11/12.
//  Copyright (c) 2012 LJX. All rights reserved.
//

#import "LJXFileHandle.h"

@interface LJXFileHandle()
{
    FILE* pFile;
}
@end

@implementation LJXFileHandle

- (void)dealloc{
    if (pFile) fclose(pFile);
    pFile = NULL;
}

+(id)fileHandelWithPath:(NSString*)aPath
{
    return [[self alloc] initWithPath:aPath];
}

-(void)close
{
    fclose(pFile);
    pFile = NULL;
}

- (id)initWithPath:(NSString*)aPath
{
    self = [super init];
    self.filePath = aPath;
    if ([aPath length]) {
        pFile = fopen([aPath UTF8String], "a+");
    }
    if (NULL == pFile) {
        perror("failed 2 open file\n");
    }
    return self;
}

-(void)writeData:(NSData*)aData
{
    if (pFile) {
        fwrite([aData bytes], [aData length], 1, pFile);
    }
}

@end
