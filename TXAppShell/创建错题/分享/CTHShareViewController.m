//
//  CTHShareViewController.m
//  PRJ_CTH
//
//  Created by linjinxing on 16/1/29.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CTHShareViewController.h"
#import "OpenShareHeader.h"

@interface CTHShareViewController ()
@property(weak) IBOutlet UICollectionView* collectionView;
@end

@implementation CTHShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self)
    [[self.view rac_signalForSelector:@selector(hitTest:withEvent:)] subscribeNext:^(RACTuple* tuple) {
        @strongify(self)
        CGPoint point1 = [self.view convertPoint:[tuple.first CGPointValue] toView:self.collectionView];
        if (![self.collectionView pointInside:point1 withEvent:nil]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender{

}

- (NSArray*)datas{
    return @[@"微信",
    @"朋友圈",
    @"QQ好友",
             @"QQ空间"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self datas].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* const reuseIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    [cell.contentView labelWithTag:2].text = [self datas][indexPath.item];
    return cell;
};

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title = [NSString stringWithFormat:@"错题会分享"];
    msg.image = UIImageJPEGRepresentation(self.image, 1.0);
    msg.thumbnail = UIImageJPEGRepresentation([self.image scaleWithWidth:80.0f], 1.0);
    msg.desc = @"我从错题会分享了错题图片";
    shareSuccess success = ^(OSMessage * message){
        [self showHUDAndHidWithStr:[NSString stringWithFormat:@"分享到%@成功", [self datas][indexPath.item]]];
    };
    shareFail fail = ^(OSMessage * message,NSError *error){
        [self showHUDAndHidWithStr:[NSString stringWithFormat:@"分享到%@失败", [self datas][indexPath.item]]];
    };
    switch (indexPath.item) {
        case 0: [OpenShare shareToWeixinSession:msg Success:success Fail:fail];break;
        case 1: [OpenShare shareToWeixinTimeline:msg Success:success Fail:fail]; break;
        case 2: [OpenShare shareToQQFriends:msg Success:success Fail:fail]; break;
        case 3: [OpenShare shareToQQZone:msg Success:success Fail:fail]; break;
        default:
            break;
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
