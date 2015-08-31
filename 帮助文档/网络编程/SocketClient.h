//
//  Copyright (c) 2014年 lichq. All rights reserved.
//


//优先参考：ios编程笔记：CFSocket http://blog.csdn.net/uxyheaven/article/details/7909601
//ios编程笔记：CFSocket(客户端）


//以下内容来自： IOS上的socket通信 CFsocket（http://blog.csdn.net/chang6520/article/details/7874804）
//更详细的可参考：CFSocket相关 http://www.2cto.com/kf/201502/374948.html


#pragma mark - 1、创建连接
- (void)createConnect{
    
    CFSocketContext sockContext= {0, self, NULL, NULL, NULL};
    /*
    //CFSocketContext的初始化方法二：
    CFSocketContext sockContext;
    memset(&sockContext, 0, sizeof(sockContext));
    sockContext.info = (void*)CFBridgingRetain(self);
    */
    
    CFSocketRef socket =
    CFSocketCreate(kCFAllocatorDefault, // 为新对象分配内存，可以为nil
                   PF_INET,             // 协议族，如果为0或者负数，则默认为PF_INET
                   SOCK_STREAM,         // 套接字类型，如果协议族为PF_INET,则它会默认为SOCK_STREAM
                   IPPROTO_TCP, // 套接字协议，如果协议族是PF_INET且协议是0或者负数，它会默认为IPPROTO_TCP
                   kCFSocketConnectCallBack, // 触发回调函数的socket消息类型，具体见Callback Types
                   TCPServerConnectCallBack, // 上面情况下触发的回调函数
                   &sockContext // 一个持有CFSocket结构信息的对象，可以为nil
                   );
    //CFSocketCreateWithNative方法，可以使用一个已经存在的BSD套接字来创建CRSocket，
    
    
    if (NULL == socket) {//socket == nil
        [[[UIAlertView alloc] initWithTitle:@"" message:@"创建套接字失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];
    }
 
    //配置sockaddr_in
    struct sockaddr_in addr4;   // IPV4
    
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);//这两行可直接写成1行：bzero(&addr4,sizeof(addr4));也可以这两行直接不写
    
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(8888);
    addr4.sin_addr.s_addr = inet_addr([@"192.168.1.10" UTF8String]);//把字符串的地址转换为机器可识别的网络地址
    
    
    //把sockaddr_in结构体中的地址转换为Data，并将其与sock进行绑定
    CFDataRef dataAddr4 = CFDataCreate(nil, (const uint8_t*)&addr4, sizeof(addr4));
    
    //CFSocketConnectToAddress 建立和服务器的连接：
     CFSocketError error = CFSocketConnectToAddress(socket, dataAddr4, 10);
     //参数①：连接的socket；参数②：CFDataRef类型的包含上面socket的远程地址的对象；参数③：连接超时时间:一般写-1，如果为负，则不尝试连接，而是把连接放在后台进行.如果_socket消息类型为kCFSocketConnectCallBack，将会在连接成功或失败的时候在后台触发回调函数
    //注意：这里由于下面要发送请求，所以，连接超时时间一般不写-1,而是写为一个正数，否则它不会尝试重新连接
    if (error != kCFSocketSuccess){
        NSLog(@"bind to address error %d", (int) error);
        return;
    }
    
    
    
    [self sendMessage];//参考：CFSocket使用CFStream进行读写的问题 http://bbs.feng.com/read-htm-tid-340559.html
    
    CFRelease(dataAddr4);
    
    /*
     利用 CFSocketCreate 功能从头开始创建一个 CFSocket 对象，或者利用 CFSocketCreateWithNative 函数从 BSD socket 创建一个 CFSocket 对象后。我们还需要利用函数 CFSocketCreateRunLoopSource 和以创建的socket创建一个“运行循环”源，并利用函数CFRunLoopAddSource 把它加入一个“运行循环”(一般选择当前线程的循环源)。这样不论 CFSocket 对象是否接收到信息， CFSocket 回调函数都可以运行。
     */
    CFRunLoopRef cRunRef = CFRunLoopGetCurrent();    //获取当前线程的循环
    // 创建一个循环，但并没有真正加如到循环中，需要调用CFRunLoopAddSource
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
    CFRunLoopAddSource(cRunRef, sourceRef, kCFRunLoopCommonModes);
    //CFRunLoopAddSource中参数①:运行循环; 参数②:增加的运行循环源, 它会被retain一次; 参数③://增加的运行循环源的模式
    
    CFRelease(sourceRef);
}




#pragma mark - 2、设置回调函数
// socket回调函数的格式：
static void TCPServerConnectCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    
    switch (callbackType)
    {
        case kCFSocketDataCallBack:
            NSLog(@"....DataCallBack");
            //            [conn onSocketData:(CFDataRef) data];
            [conn performSelectorInBackground:@selector(readStream) withObject:nil];
            break;
        case kCFSocketConnectCallBack:
            NSLog(@"....ConnectCallBack");
            if (data != NULL) {
                // 当socket为kCFSocketConnectCallBack时，失败时回调失败会返回一个错误代码指针，其他情况返回NULL
                NSLog(@"连接失败");
                return;
            }else{
                NSLog(@"连接成功");
            }
            //            [conn sendMessage];
            
            
            if (data != NULL) {
                // 当socket为kCFSocketConnectCallBack时，失败时回调失败会返回一个错误代码指针，其他情况返回NULL
                NSLog(@"连接失败");
                [[[UIAlertView alloc] initWithTitle:@"" message:@"连接失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];
                return;
            }else{
                NSLog(@"连接成功");
            }
            
            /*
             //客户端读取接收数据
             TCPClient *client = (TCPClient *)info;
             [info performSelectorInBackground:@selector(readStream) withObject:nil];
             */
            
            break;
        case kCFSocketReadCallBack:
            NSLog(@"Read...CallBack");
            break;
        case kCFSocketWriteCallBack:
            NSLog(@"Write...CallBack");
            break;
        default:
            NSLog(@"unexpected socket event");
            break;
    }
    
    
    
    
    
}

#pragma mark - 3、接收、发送数据
/////////////////////监听来自服务器的信息///////////////////
- (void)readStream {
    char buffer[1024];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CFSocketNativeHandle sH = CFSocketGetNative(_s);
    NSLog(@"sH = %d", sH);
    
    while (recv(CFSocketGetNative(_socket),  buffer, sizeof(buffer), 0)) {//CFSocketGetNative(_socket)与本机关联的Socket 如果已经失效返回－1:INVALID_SOCKET
        NSLog(@"%@", [NSString stringWithUTF8String:buffer]);
    }
}

/////////////////////////发送信息给服务器////////////////////////
- (void)sendMessage {
    //NSString *stringTosend = @"你好";
    NSString *stringTosend = @"OPTIONS rtsp://192.168.18.203:5554/live/test001 RTSP/1.0\r\nCseq: 1\r\n";
    
    //发送方法①：
    const char *data = (char *)[stringTosend UTF8String];
    int res = send(CFSocketGetNative(_socket), data, strlen(data) + 1, 0);
    if (res == -1) {
        NSLog(@"发送失败：Error in Sending");
    }else{
        NSLog(@"成功发送：%@", stringTosend);
    }
    
    
    //发送方法②：
    NSData* dataResponse = [stringTosend dataUsingEncoding:NSUTF8StringEncoding];
    CFSocketError e = CFSocketSendData(_socket, NULL, (__bridge CFDataRef)(dataResponse), 2);
    if (e)
    {
        NSLog(@"发送失败：send %ld", e);
    }else{
        NSLog(@"发送成功");
    }
}




