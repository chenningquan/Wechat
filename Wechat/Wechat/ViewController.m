//
//  ViewController.m
//  Wechat
//
//  Created by 陈宁权 on 16/4/4.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<NSStreamDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GCDAsyncSocketDelegate>
{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    
    GCDAsyncSocket *_socket;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *msgs;
@end

@implementation ViewController

- (NSMutableArray *)msgs
{
    if (_msgs == nil) {
        _msgs = [NSMutableArray array];
    }
    return _msgs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘将显示
- (void)kbWillShow:(NSNotification *)noti
{
    //显示的时候改变bottomContraint
    
    //获取键盘高度
    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.bottomConstraint.constant = kbHeight;
}

#pragma mark 键盘将隐藏
- (void)kbWillHide:(NSNotification *)noti
{
    self.bottomConstraint.constant = 0;
}


- (IBAction)connectToServer:(id)sender {
    //IOS里实现socket的连接，使用C语言
    
    //1.与服务器通过三次握手建立连接
    /*
     *CFAllocatorRef alloc   分配内存的
     */
    NSString *host = @"127.0.0.1";
    int port = 12345;
    
    //创建一个socket对象
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
}

#pragma mark -socket的代理
#pragma mark -成功连接
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s",__func__);
}

#pragma mark -断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        NSLog(@"连接失败");
    }
    else
    {
        NSLog(@"正常断开");
    }
}

#pragma mark -数据发送成功
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s",__func__);
    
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark -读取数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
     NSLog(@"%s",__func__);
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receiverStr);
    if (tag == 101) {
        
    }
    else if (tag == 102)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.msgs addObject:receiverStr];
            [self.tableview reloadData];
        });
    }
}


- (IBAction)loginBtnClick:(id)sender {
    //发送登录请求 使用输出流
    
    //拼接登录指令
    NSString *loginStr = @"iam:zhangsan";
    
    [_socket writeData:[loginStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:101];
    //(nonnull const uint8_t *) 字符数组
    
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -表格的数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //显示数据
    cell.textLabel.text = self.msgs[indexPath.row];
    return cell;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //隐藏键盘
    [self.view endEditing:YES];
}

#pragma mark TextField的返回按钮监听
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *txt = textField.text;
    
    if (txt.length == 0) return YES;
    
    //发送数据
    NSString *msg = [@"msg:" stringByAppendingString:txt];
    
    [_socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:102];
    
    return YES;
}



@end
