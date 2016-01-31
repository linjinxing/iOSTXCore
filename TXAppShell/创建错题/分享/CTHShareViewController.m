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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)share2QQ{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title=[NSString stringWithFormat:@"Hello OpenShare (msg.title) %f",[[NSDate date] timeIntervalSince1970]];
    if (1)
    {
        [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
            NSLog(@"分享到QQ好友成功:%@",msg);
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"分享到QQ好友失败:%@\n%@",msg,error);
        }];
    }else
    {
        [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
            NSLog(@"分享到QQ空间成功:%@",msg);
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"分享到QQ空间失败:%@\n%@",msg,error);
        }];
    }
}

- (void)share2WeiXin
{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title=[NSString stringWithFormat:@"Hello OpenShare (msg.title) %f",[[NSDate date] timeIntervalSince1970]];
    if (1)
    {
        [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
            NSLog(@"微信分享到会话成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"微信分享到会话失败：\n%@\n%@",error,message);
        }];
    }
    else{
        [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
            NSLog(@"微信分享到朋友圈成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
        }];
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
