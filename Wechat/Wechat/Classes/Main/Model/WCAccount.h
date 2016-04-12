//
//  WCAccount.h
//  Wechat
//
//  Created by 陈宁权 on 16/4/11.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject

@property (nonatomic,copy)NSString *loginUser;
@property (nonatomic,copy)NSString *loginPwd;
@property (nonatomic,copy)NSString *registUser;
@property (nonatomic,copy)NSString *registPwd;
/**
 *判断是注册还是登录
 *NO  : 登录
 *YES : 注册
 */
@property (nonatomic,assign,getter=isregistOperation)BOOL registOperation;
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
