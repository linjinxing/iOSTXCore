//
//  LJXTableViewCell.m
//  LJXTableView
//
//  Created by LoveYouForever on 9/22/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "LJXTableViewCell.h"
#import "LJXSettingDataSourceSectonItem.h"
#import "LJXTableViewUtility.h"

@interface LJXTableViewCell()<SWTableViewCellDelegate>
@property(strong, nonatomic) UIButton* deleteButton;
@property(strong, nonatomic) UITapGestureRecognizer* tapGes;
@property(assign, nonatomic) UITableViewCellAccessoryType backupAccessoryType;
@end

@implementation LJXTableViewCell
@synthesize actionHandler, indexPath;

- (void)setupDeleteButton
{
    [self removeGestureRecognizer:self.tapGes];
    UISwipeGestureRecognizer* swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGes];
    
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGes.enabled = NO;
    [self addGestureRecognizer:tapGes];
    self.tapGes = tapGes;
    
    UIButton* btn = [UIButton buttonWithImage:[UIImage imageNamed:@"edit_icon_delete"]];
    [btn setBackgroundColor:[UIColor redColor]];
    //            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
    //                make.width.equalTo(@60.0f);
    //            }];
    self.deleteButton = btn;
    
    CGFloat height = 44.0f;
    self.deleteButton.frame = CGRectMake(0, 0, height + 20.0f, height) ;
}

- (void)resetDeleteButtonState
{
    self.accessoryView = nil;
    if (self.tapGes) {
        [self removeGestureRecognizer:self.tapGes];
        self.tapGes = nil;
    }
}

- (void)swipe:(UISwipeGestureRecognizer*) ges
{
    if (nil == self.accessoryView)
    {
        self.accessoryView = self.deleteButton;
        self.tapGes.enabled = YES;
    }else{
        [self resetDeleteButtonState];
    }
}

- (void)tap:(UITapGestureRecognizer*) ges
{
    [self resetDeleteButtonState];
}


- (void)setupWithItem:(id<LJXSettingDataSourceSectonItem>)item
{
    self.textLabel.text = [item textTitle];
    if ([item.accessoryType length]) {
        self.accessoryType = LJXTableViewUtilityCellAccessoryTypeFromString(item.accessoryType);
    }
    if ([[item detailTitle] length]) {
        self.detailTextLabel.text = [item detailTitle];
    }
    if ([[item imageName] length]) self.imageView.image = [UIImage imageNamed:[item imageName]];
    
    @weakify(self);
    [RACObserve(self, allowDeleted) subscribeNext:^(id allowDeleted) {
        @strongify(self);
        if ([allowDeleted boolValue]){
            [self setupDeleteButton];
        }else{
            self.deleteButton = nil;
        }
    }];
    
    [RACObserve(self, accessoryType) subscribeNext:^(id x) {
        @strongify(self);
        self.backupAccessoryType =  self.accessoryType;
    }];
}

- (instancetype)initWithStyle:(LJXTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier item:(id<LJXSettingDataSourceSectonItem>)item
{
    UITableViewCellStyle s = style > UITableViewCellStyleSubtitle ? UITableViewCellStyleDefault : (UITableViewCellStyle)style;
    self = [super initWithStyle:s  reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWithItem:item];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, text:%@", [super description], self.textLabel.text];
}


@end
