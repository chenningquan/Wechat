//
//  WCXMPPTool.h
//  Wechat
//
//  Created by 陈宁权 on 16/4/11.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)

typedef enum {
    XMPPResultTypeLoginSuccess,//用户登录成功
    XMPPResultTypeLoginFailure,//用户登录失败
    XMPPResultTypeRegistSuccess,//用户注册成功
    XMPPResultTypeRegistFailure //用户注册失败
}XMPPResultType;

typedef void (^XMPPReultBlock)(XMPPResultType);

/**
 *xmpp用户登录
 */
- (void)xmpplogin:(XMPPReultBlock)resultBlock;
/**
 *xmpp用户注销
 */
- (void)xmpplogout;
/**
 *用户注册
 */
- (void)xmppregist:(XMPPReultBlock)resultBlock;


@end
