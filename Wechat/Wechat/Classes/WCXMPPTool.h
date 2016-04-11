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
    XMPPResultTypeLoginSuccess,
    XMPPResultTypeLoginFailure
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


@end
