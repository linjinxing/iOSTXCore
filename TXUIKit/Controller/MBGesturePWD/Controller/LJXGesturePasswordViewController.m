//
//  LJXGesturePasswordViewController.m
//  MoboWallet
//
//  Created by mobao_ios on 15/4/23.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import "LJXGesturePasswordViewController.h"
#import "LJXLoadingViewController.h"
#import "LJXGestureLock.h"

@interface LJXGesturePasswordViewController ()<LJXLockDelegate>

@property (weak, nonatomic) IBOutlet LJXLockIndicator *locakIndicatorView;
@property (weak, nonatomic) IBOutlet LJXLockView *lockDrawView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

//设置密码时的两次密码
@property (nonatomic, strong) NSString *pwdStringOld;
@property (nonatomic, strong) NSString *pwdStringNew;
@property (nonatomic, assign) NSInteger errorCount;
@property (nonatomic, assign) BOOL bOldPasswordSuccessed;//修改密码时原密码是否正确;
@end

@implementation LJXGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lockDrawView.delegate = self;
    self.title = @"手势绘制";
    [self installLockView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLockType:(LJXLockViewType)lockType
{
	_lockType = lockType;
	[self installLockView];
}

-(void)installLockView {
    switch (self.lockType) {
        case LJXLockViewTypeCreate:
            self.tipsLabel.text = @"请绘制密码";
            break;
            
        case LJXLockViewTypeModify:
            self.tipsLabel.text = @"请绘制原来的密码";
            break;
        case LJXLockViewTypeCheck:
            break;
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
- (void)inputErrorPassword{
	self.errorCount++;
	if (self.errorCount < 5){
		[self showHUDAndHidWithStr:[NSString stringWithFormat:@"您还有%@次机会", @(5 - self.errorCount)]];
	}else{
		[self showHUDAndHidWithStr:[NSString stringWithFormat:@"通过用户名和密码重新登录，并重新设置手势密码"]];
		if (self.didError) {
			self.didError([NSError errorWithDomain:NSStringFromClass([self class]) code:LJXGesturePasswordErrorCodeOverErrorCount userInfo:nil]);
		}
	}
}

#pragma mark - 绘制密码视图delegate
-(void)lockString:(NSString *)string {
    LJXFoundationLog("%@",string);
    [self.locakIndicatorView setPasswordString:string];
    
    switch (self.lockType) {
        case LJXLockViewTypeCreate:
        {
            if (!self.pwdStringOld && !self.pwdStringNew) {
                self.pwdStringOld = string;
                self.tipsLabel.text = @"请再次绘制密码";
            }else if (self.pwdStringOld){
                if ([string isEqualToString:self.pwdStringOld]) {
                    self.tipsLabel.text = @"设置密码成功";
                    [LJXLockPassword saveLockPassword:string];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						if (self.navigationController
							&& [self.navigationController.viewControllers firstObject] != self
							) {
							[self.navigationController popViewControllerAnimated:YES];
						}else{
							[self dismissViewControllerAnimated:YES completion:nil];
						}
                    });
                }else
                {
                    self.tipsLabel.text = @"两次绘制密码不同，请重新设置密码";
                    self.pwdStringOld = nil;
                }
            }
        }
            
            break;
        case LJXLockViewTypeCheck:
        {
            NSString *password = [LJXLockPassword loadLockPassword];
            if ([string isEqualToString:password]) {
                //解码成功;
                self.tipsLabel.text = @"解锁密码成功";
                [self dismissViewControllerAnimated:NO completion:nil];
            }else
            {
                //失败
                self.tipsLabel.text = @"解锁密码错误,请重新绘制";
			    [self inputErrorPassword];
            }
        }
            break;
        case LJXLockViewTypeModify:
        {
            if (!self.bOldPasswordSuccessed) {
                NSString *password = [LJXLockPassword loadLockPassword];
                if ([password isEqualToString:string]) {
                    self.bOldPasswordSuccessed = YES;
                    self.tipsLabel.text = @"请绘制新的密码";
                }else
                {
                    self.tipsLabel.text = @"绘制错误，请重新绘制原来的密码";
					[self inputErrorPassword];
                }
            }else
            {
                if (!self.pwdStringOld && !self.pwdStringNew) {
                    self.pwdStringOld = string;
                    self.tipsLabel.text = @"请再次绘制密码";
                }else if (self.pwdStringOld){
                    if ([string isEqualToString:self.pwdStringOld]) {
                        self.tipsLabel.text = @"设置密码成功";
                        [LJXLockPassword saveLockPassword:string];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
							if (self.navigationController
								&& [self.navigationController.viewControllers firstObject] != self
								) {
								[self.navigationController popViewControllerAnimated:YES];
							}else{
								[self dismissViewControllerAnimated:YES completion:nil];
							}
                        });
                    }else
                    {
                        self.tipsLabel.text = @"两次绘制密码不同，请重新设置密码";
                        self.pwdStringOld = nil;
                    }
                }

            }
        }
            break;
        default:
            break;
    }
    
}

@end
