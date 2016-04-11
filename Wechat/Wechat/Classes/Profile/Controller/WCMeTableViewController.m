//
//  WCMeTableViewController.m
//  Wechat
//
//  Created by 陈宁权 on 16/4/11.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import "WCMeTableViewController.h"
#import "WCXMPPTool.h"
#import "WCAccount.h"

@interface WCMeTableViewController ()

@end

@implementation WCMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)logoutBtnClick:(id)sender {
    [[WCXMPPTool sharedWCXMPPTool] xmpplogout];
    //删除沙盒中的login记录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
    //回到登录界面
    id loginVc = [UIStoryboard storyboardWithName:@"login" bundle:nil].instantiateInitialViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;
}

@end
