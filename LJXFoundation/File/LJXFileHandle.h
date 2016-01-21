//
//  LJXHttpFileHandle.h
//  LJXBrowser
//
//  Created by kangyi on 7/11/12.
//  Copyright (c) 2012 LJX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJXFileHandle : NSObject
@property(nonatomic, copy)NSString* filePath;

/*功能说明：     构建一个文件管理的对象
 aName         文件的路径
 */
+(id)fileHandelWithPath:(NSString*)aName;

/*功能说明：     用路径初始化一个对象
 aPath      文件的路径
 */
- (id)initWithPath:(NSString*)aPath;

/*功能说明：     写入数据
 aData      要写入的数据
 */
-(void)writeData:(NSData*)aData;

/*功能说明：     关闭文件
 */
-(void)close;
@end
