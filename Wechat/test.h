//
//  test.h
//  Wechat
//
//  Created by 陈宁权 on 16/4/5.
//  Copyright © 2016年 陈宁权. All rights reserved.
//

//- (void)text
//{
//    //2.定义输入输出流
//    CFReadStreamRef readStream;
//    CFWriteStreamRef writeStream;
//
//    //3.分配输入输出流的内存空间
//    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)(host), port, &readStream, &writeStream);
//
//    //4.把C语言的输入输出流转换成OC对象
//    _inputStream = (__bridge NSInputStream *)(readStream);
//    _outputStream = (__bridge NSOutputStream *)(writeStream);
//
//    //5.设置代理来监听数据接收的状态
//    _outputStream.delegate = self;
//    _inputStream.delegate = self;
//
//    //6.把输入输出流添加到主运行循环（RunLoop）：它是监听网络状态的
//    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//
//    //7.打开输入输出流
//    [_inputStream open];
//    [_outputStream open];
//}

//-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
//{
////    NSStreamEventNone = 0,
////    NSStreamEventOpenCompleted = 1UL << 0,
////    NSStreamEventHasBytesAvailable = 1UL << 1,
////    NSStreamEventHasSpaceAvailable = 1UL << 2,
////    NSStreamEventErrorOccurred = 1UL << 3,
////    NSStreamEventEndEncountered = 1UL << 4
//
//    switch (eventCode) {
//        case NSStreamEventOpenCompleted:
//            NSLog(@"成功建立连接，形成输入输出流的传输通道");
//            break;
//        case NSStreamEventHasBytesAvailable:
//            NSLog(@"有数据可读");
//            [self readData];
//            break;
//        case NSStreamEventHasSpaceAvailable:
//            NSLog(@"可以发送数据");
//            break;
//        case NSStreamEventErrorOccurred:
//            NSLog(@"有错误发生，连接失败");
//            break;
//        case NSStreamEventEndEncountered:
//            NSLog(@"正常断开连接");
//            //把输入输出流关闭并从主运行循环中移除
//            [_inputStream close];
//            [_outputStream close];
//            [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//            [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//            break;
//        default:
//            break;
//    }
//}

#pragma mark 读取服务器返回的数据
- (void)readData
{
    //定义缓冲区 这个缓冲区只能存储1024个字节
    uint8_t buf[1024];
    //读取数据
    //length为服务器读取到的实际字节数
    NSInteger length = [_inputStream read:buf maxLength:sizeof(buf)];
    
    //把缓冲区里的实际字节数转换成字符串
    NSString *recevierStr = [[NSString alloc] initWithBytes:buf length:length encoding:NSUTF8StringEncoding];
    [self.msgs addObject:recevierStr];
    
    [self.tableview reloadData];
    
    NSLog(@"recevierStr = %@",recevierStr);
}

