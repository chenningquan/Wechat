//
//  WCXMPPTool.m
//  Wechat
//
//  Created by 陈宁权 on 16/4/11.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import "WCXMPPTool.h"
#import "XMPPFramework.h"
#import "WCAccount.h"

@interface WCXMPPTool ()<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;//与服务器交互的核心类
    
    XMPPReultBlock _resultBlock;
}

/**
 * 1.初始化XMPPStream
 */
- (void)setupStream;
/**
 * 2.连接服务器(传JID过去)
 */
- (void)connectToHost;
/**
 * 3.判断返回状态是否连接成功，成功就发送密码到服务器
 */
- (void)sendPwdToHost;
/**
 * 4.发送一个在线请求给服务器(默认不在线) -> 可以通知其他用户你上线
 */
- (void)sendOnlineMsg;
/**
 *发送离线消息
 */
- (void)sendOffLineMsg;
@end



@implementation WCXMPPTool
singleton_implementation(WCXMPPTool)

#pragma mark -私有方法
- (void)setupStream
{
    //创建XNPPStream对象
    _xmppStream = [[XMPPStream alloc] init];
    
    //设置代理 - 所有的代理方法都在子线程中调用
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)connectToHost
{
    if (_xmppStream == nil) {
        [self setupStream];
    }
    //1.设置Jid
    NSString *user = [WCAccount shareAccount].user;
    XMPPJID *myjid = [XMPPJID jidWithUser:user domain:@"test.local" resource:@"iphone"];
    _xmppStream.myJID = myjid;
    
    //2.设置主机地址
    _xmppStream.hostName = @"127.0.0.1";
    
    //3.设置主机端口号(默认就是5222,可以不用设置)
    _xmppStream.hostPort = 5222;
    
    //4.发起连接
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"connectToHost error :%@",error);
    }
    else
    {
        NSLog(@"发起连接成功");
    }
}

- (void)sendPwdToHost
{
    NSString *pwd = [WCAccount shareAccount].pwd;
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        NSLog(@"sendPwdToHost error :%@",error);
    }
}

- (void)sendOnlineMsg
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [_xmppStream sendElement:presence];
}

- (void)sendOffLineMsg
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

#pragma mark -XMPPStream代理方法
#pragma mark 连接建立成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接建立成功");
    [self sendPwdToHost];
}

#pragma mark 登录成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"登录成功");
    [self sendOnlineMsg];
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
        
        //清空resultBlock，避免产生循环引用
        _resultBlock = nil;
    }
}

#pragma mark 登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"登录失败，错误是：%@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
        
        //清空resultBlock，避免产生循环引用
        _resultBlock = nil;
    }
}
#pragma mark -公共方法
#pragma mark 用户登录
- (void)xmpplogin:(XMPPReultBlock)resultBlock
{
    //将上一次的连接断开，每次都重新连接
    [_xmppStream disconnect];
    //保存resultBlock
    _resultBlock = resultBlock;
    [self connectToHost];
}

-(void)xmpplogout
{
    //发送离线消息
    [self sendOffLineMsg];
    //断开连接
    [_xmppStream disconnect];
}


@end
