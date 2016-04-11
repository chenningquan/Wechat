//
//  WCAccount.h
//  Wechat
//
//  Created by 陈宁权 on 16/4/11.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject

@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *pwd;
/**
 *判断用户是否登录
 */
@property (nonatomic,assign,getter=isLogin)BOOL login;

+ (instancetype)shareAccount;

/**
 *保存最新的用户数据到沙盒
 */
- (void)saveToSandBox;

@end
