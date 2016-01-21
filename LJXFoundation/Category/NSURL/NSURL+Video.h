//
//  NSURL+Video.h
//  DavidVideo
//
//  Created by Test on 14-9-7.
//  Copyright (c) 2014年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (Video)
-(void)imageAtTime:(NSTimeInterval)time size:(CGSize)size completion:(void(^)(UIImage* image, NSError* error))completion;



@end


