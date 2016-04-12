//
//  WCLoginViewController.m
//  Wechat
//
//  Created by 陈宁权 on 16/4/11.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import "WCLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+HM.h"
#import "WCAccount.h"
#import "WCXMPPTool.h"

@interface WCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdfield;


@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)loginBtnClick:(id)sender {
    //1.判断有没有输入用户名和密码
    if (self.userfield.text.length == 0 || self.pwdfield.text.length == 0) {
        NSLog(@"请输入用户名和密码");
        return;
    }
    
    //给用户提示
    [MBProgressHUD showMessage:@"正在登录ing....."];
    
    //2.登录服务器
    //2.1把用户名和密码保存到沙盒
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.userfield.text forKey:@"user"];
//    [defaults setObject:self.pwdfield.text forKey:@"pwd"];
//    [defaults synchronize];
    
    //把用户和密码先放到account单例
    [WCAccount shareAccount].loginUser = self.userfield.text;
    [WCAccount shareAccount].loginPwd = self.pwdfield.text;
    [WCAccount shareAccount].registOperation = NO;
    
    //2.2调用Appdelegate的登录方法
    //怎么把appdelegate的登录结果告诉WCLoginViewController控制器(代理，block，通知)
    //Block会对self造成强引用，会导致循环引用，然后内存泄漏
    __weak typeof(self) selfVC = self;
    [[WCXMPPTool sharedWCXMPPTool] xmpplogin:^(XMPPResultType resultType) {
        [selfVC handleXMPPResultType:resultType];
    }];
}

#pragma mark 处理结果
- (void)handleXMPPResultType:(XMPPResultType)resultType
{
    //到主线程中更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if (resultType == XMPPResultTypeLoginSuccess) {
            NSLog(@"登录成功!!");
            //3.登录成功切换到主界面
            [self changeToMain];
            [WCAccount shareAccount].login = YES;
            //保存登录账户信息
            [[WCAccount shareAccount] saveToSandBox];
        }
        else
        {
            NSLog(@"登录失败!!");
            [MBProgressHUD showError:@"用户名或者密码不正确"];
        }
    });
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark 切换到主界面
- (void)changeToMain
{
    //1.获取Main.storyboard的第一个控制器
    id VC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    //2.切换window的根控制器
    [UIApplication sharedApplication].keyWindow.rootViewController = VC;
    
    
}


@end
