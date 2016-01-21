//
//  LJXSetGesturePwdViewController.m
//  MoboWallet
//
//  Created by mobao_ios on 15/4/22.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import "LJXSetGesturePwdViewController.h"
#import "LJXGesturePasswordViewController.h"

#import "LJXGestureLock.h"

@interface LJXSetGesturePwdViewController ()
{
    NSInteger cellNum;
}

@property (weak, nonatomic) IBOutlet UISwitch *pdwSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation LJXSetGesturePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[UIView new]];
    cellNum = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkGesturePwdExistd];
}


-(void)checkGesturePwdExistd {
    //验证密码是否存在
    if ([LJXLockPassword loadLockPassword] && [LJXLockPassword loadLockPassword].length > 0) {
        self.tipLabel.text = @"修改手势密码";
    }else
    {
        self.tipLabel.text = @"设置手势密码";
    }
    
    [self.pdwSwitch setOn:[LJXLockPassword isNeedVerificationLockPassword]];
    if (self.pdwSwitch.isOn) {
        cellNum = 2;
    }else
    {
        cellNum = 1;
    }
    [self.tableView reloadData];
}

- (IBAction)onSwitchValueChange:(UISwitch *)sender {
    cellNum = sender.isOn?2:1;
    [self.tableView reloadData];
    //设置是否开启手势密码
    [LJXLockPassword setNeedVerificationLockPassword:sender.isOn];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellNum;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        //跳转到手势密码输入界面
        
//        [self setBackButtonWithTitle:@""];
        [self gotoGesturePassWordVC];
    }
}

-(void)gotoGesturePassWordVC {
    [self performSegueWithIdentifier:@"showGusturePwdVC" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGusturePwdVC"]) {
        LJXGesturePasswordViewController *controller = segue.destinationViewController;
        if ([LJXLockPassword loadLockPassword]) {
            controller.lockType = LJXLockViewTypeModify;
        }else
        {
            controller.lockType = LJXLockViewTypeCreate;
        }
    }
}

@end
