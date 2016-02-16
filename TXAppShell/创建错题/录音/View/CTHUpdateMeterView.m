//
//  CTHUpdateMeterView.m
//  PRJCTH
//
//  Created by linjinxing on 16/2/3.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CTHUpdateMeterView.h"

@interface CTHUpdateMeterView()
@property(nonatomic, weak) IBOutlet UIImageView* imageViewMeter;
@end

@implementation CTHUpdateMeterView
- (void)setMeter:(NSUInteger)meter
{
    self.imageViewMeter.image = [UIImage imageNamed:[NSString stringWithFormat:@"sound%@", @(meter % 6)]];
}
@end
