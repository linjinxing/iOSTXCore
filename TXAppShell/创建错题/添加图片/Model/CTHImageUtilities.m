//
//  CTHImageUtilities.m
//  PRJCTH
//
//  Created by linjinxing on 16/2/4.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CTHImageUtilities.h"
#import "UserManager.h"

@implementation CTHImageUtilities
+ (NSString*)topicUrl
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
#pragma mark topic 图片唯一标示 id+ topic + 时间
    NSDate *datenow = [NSDate dateWithTimeIntervalSince1970:a];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:datenow];
    NSDictionary* pupilInfo = [UserManager getPupilInfo];
#pragma mark 题干图片的缓存
    return [NSString stringWithFormat:@"%@topic%@",pupilInfo[@"pupilId"],strDate];
}
@end
