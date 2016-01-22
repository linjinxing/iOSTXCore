//
//  UITableView+Addition.m
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/3/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "UITableView+Addition.h"

@implementation UITableView (Addition)
- (void)setAllCellsSelected:(BOOL)select
{
    NSArray* cells = [self indexPathsForVisibleRows];
    for (NSIndexPath* ip in cells)
    {
        UITableViewCell* cell = [self cellForRowAtIndexPath:ip];
        cell.selected = select;
    }
}
@end
