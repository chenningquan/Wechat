//
//  AppDelegate.m
//  Wechat
//
//  Created by 陈宁权 on 16/4/4.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import "AppDelegate.h"
#import "WCAccount.h"
#import "WCXMPPTool.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([WCAccount shareAccount].isLogin) {
        id mainVc = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        self.window.rootViewController = mainVc;
        
        [[WCXMPPTool sharedWCXMPPTool] xmpplogin:nil];
    }
    return YES;
}


@end
