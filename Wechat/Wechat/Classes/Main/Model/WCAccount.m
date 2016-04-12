//
//  WCAccount.m
//  Wechat
//
//  Created by 陈宁权 on 16/4/11.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import "WCAccount.h"

@implementation WCAccount
+(instancetype)shareAccount
{
    return [[self alloc] init];
}

#pragma mark 分配内存创建对象
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static WCAccount *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (account == nil) {
            account = [super allocWithZone:zone];
            
            //从沙盒获取上次的用户登录信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            account.loginUser = [defaults objectForKey:@"user"];
            account.loginPwd = [defaults objectForKey:@"pwd"];
            account.login = [defaults objectForKey:@"login"];
        }
    });
    return account;
}

-(void)saveToSandBox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginUser forKey:@"user"];
    [defaults setObject:self.loginPwd forKey:@"pwd"];
    [defaults setBool:self.isLogin forKey:@"login"];
    [defaults synchronize];
}

@end
