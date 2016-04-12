//
//  WCRegistViewController.m
//  Wechat
//
//  Created by 陈宁权 on 16/4/12.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import "WCRegistViewController.h"

@interface WCRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registUser;
@property (weak, nonatomic) IBOutlet UITextField *registPwd;

@end

@implementation WCRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registBtnClick:(id)sender {
    //1.判断有没有输入用户名和密码
    if (self.registUser.text.length == 0 || self.registPwd.text.length == 0) {
        NSLog(@"请输入用户名和密码");
        return;
    }
    
    //给用户提示
    [MBProgressHUD showMessage:@"正在注册ing....."];
    
    //2.登录服务器
    //2.1把用户名和密码保存到沙盒
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:self.userfield.text forKey:@"user"];
    //    [defaults setObject:self.pwdfield.text forKey:@"pwd"];
    //    [defaults synchronize];
    
    //把用户和密码先放到account单例
    [WCAccount shareAccount].registUser = self.registUser.text;
    [WCAccount shareAccount].registPwd = self.registPwd.text;
    [WCAccount shareAccount].registOperation = YES;
    
    //2.2调用Appdelegate的登录方法
    //怎么把appdelegate的登录结果告诉WCLoginViewController控制器(代理，block，通知)
    //Block会对self造成强引用，会导致循环引用，然后内存泄漏
    __weak typeof(self) selfVC = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppregist:^(XMPPResultType resultType) {
        [selfVC handleXMPPResultType:resultType];
    }];

}

- (void)handleXMPPResultType:(XMPPResultType)resultType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if (resultType == XMPPResultTypeRegistSuccess) {//注册成功
            [MBProgressHUD showSuccess:@"注册成功，返回登录页面"];
            //自动切换到登录界面
            [UIStoryboard showInitialVCWithName:@"login"];
            //将注册的账户及密码带到登录界面
//            [WCAccount shareAccount].loginUser = self.registUser.text;
//            [WCAccount shareAccount].loginPwd = self.registPwd.text;
        }else{
            [MBProgressHUD showError:@"注册失败"];
        }
    });
    
}


@end
