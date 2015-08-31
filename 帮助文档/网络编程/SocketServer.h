//
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#pragma mark -

//摘自：ios编程笔记：CFSocket http://blog.csdn.net/uxyheaven/article/details/7909601

//ios编程笔记：CFSocket(服务端）

CFSockteRef _socket;
CFWriteStreamRef outputStream = NULL; //输出流



int setupSocket(){
    
    #pragma mark 第一步：创建
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerAcceptCallBack, NULL);
    if (NULL == _socket) {
        NSLog(@"Cannot create socket!");
        return 0;
    }
    //主要函数①：CFSocketCreate(CFAllocatorRef allocator, SInt32 protocolFamily, SInt32 socketType, SInt32 protocol, CFOptionFlags callBackTypes, CFSocketCallBack callout, const CFSocketContext *context);
    /*
      CFAllocatorRef allocator, //内存分配类型一般为默认KCFAllocatorDefault
      SInt32 protocolFamily, //协议族,一般为Ipv4:PF_INET,(Ipv6,PF_INET6)
      SInt32 socketType,     //套接字类型TCP:SOCK_STREAM UDP:SOCK_DGRAM
      SInt32 protocol,       //套接字协议TCP:IPPROTO_TCP UDP:IPPROTO_UDP;
      CFOptionFlags callBackTypes, //回调事件触发类型
      CFSocketCallBack callout,      // 触发时调用的函数
      Const CFSocketContext *context //  用户定义数据指针
     //附：回调事件触发类型
     Enum CFSocketCallBACKType{
     KCFSocketNoCallBack = 0,
     KCFSocketReadCallBack =1,
     KCFSocketAcceptCallBack = 2,(常用)
     KCFSocketDtatCallBack = 3,
     KCFSocketConnectCallBack = 4,
     KCFSocketWriteCallBack = 8
     }
    */
    
    
    
    #pragma mark 第二步：初始化（对socket进行定义设置）
    int optval = 1;
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR,(void *)&optval, sizeof(optval));
    //其中：CFSocketGetNative(_socket)，//返回系统原生套接字,补齐缺省；SO_REUSEADDR代表允许重用本地地址和端口
    
    
    #pragma mark 第三步：地址
    struct sockaddr_in addr4;   // 定义监听地址以及端口
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(12345);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    CFDataRef dataAddr4 = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
    

     CFSocketError rst = CFSocketSetAddress(socket, dataAddr4);//将设置数据设入socket
    if (rst != KCFSocketSuccess) {
        NSLog(@"Bind to address failed!");
        if (_socket)
            CFRelease(_socket);
        _socket = NULL;
        return 0;
    }
    
    
    #pragma mark 第四步：执行
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent(); //获取当前的运行循环
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);//创建一个运行循环源对象
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);//以该对象运行到当前运行循环中
    CFRelease(source);
    
    return 1;
}







服务端响应
CFSocketCallBack callout,      // 触发时调用的函数
该函数会在接收到客户端请求连接时触发：
ServerAcceptCallBack(       //名字可以任意取，但参数是固定的
                     CFSoceketRef        socket     ,
                     CFSocketCallBackType callbacktype,
                     CFDataRef           address,
                     const void * data,      //与回调函数有关的特殊数据指针，
                     对于接受连接请求事件，这个指针指向该socket的句柄，
                     对于连接事件，则指向Sint32类型的错误代码
                     
                     void      *info)         //与套接字关联的自定义的任意数据
{ //实现函数
    If(kCFSocketAcceptCallBack = = callbacktype ){
        CFSocketNativeHandle nativeSocketHandle = (CFSocketNativeHandle*)data;
        
        ////////////////////////////////以下片段用于输出来访者地址//////////////////////////////////
        Uint8_t name[SOCK_MAXADDRLEN]
        Socklen_t namelen = sizeof(name);
        If(0 != getpeername(nativeSocketHandle ,(struct sockaddr_in*)name,&namelen)) //获取地址
        {
            exit(1)
        }
        Printf(“%s connected\n”,inet_ntoa((struct sockaddr_in *)name)->sin_addr);
        ////////////////////////////////////////////////////////////////////////////////////////
        
        
        CFReadStreamRef  iStream;
        CFWriteStreamRef  oStream;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &iStream, &oStream);// 创建一个可读写的socket连接
        If(iStream && oStream){
            CFStreamClinetContext streamCtxt = {0,NULL, NULL, NULL, NULL};
            If(!CFReadStreamSetClient(iStream,
                                      kCFStreamEventHasBytesAvailable //有可用数据则执行
                                      readStream,                      //设置读取时候的函数
                                      &steamCtxt))
            {exit(1);}
            
            If(!CFWriteStreamSetClient(       //为流指定一个在运行循环中接受回调的客户端
                                       oStream,
                                       kCFStreamEventCanAcceptBytes, //输出流准备完毕，可输出
                                       writeStream,                    //设置写入时候的函数
                                       &steamCtxt))
            {exit(1);}
            
            
        }
    }
}

//读取流操作(触发式，被动技能)
readStream(CFReadStreamRef stream,CFStreamEventType eventType, void *client CallBackInfo)
{
    UInt8 buff[255];
    CFReadStreamRead(stream,buff,255); //将输入流中数据存入buff
    Printf(“received %s”,buff);
}


//写入流操作（仍然被动技能，在输出流准备好的时候调用）
writeStream (CFWriteStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo)
{
    outputStream = stream;   //输出流被指定
}


//主动输出,在输出流准备好之后才能调用
FucForWrite()
{
    UInt8 buff[] = “Hunter21,this is Overlord”;
    If(outputStream != NULL)
    {
        CFWriteStreamWrite(outputStream,buff,strlen(buff)+1);
    }
}

------------------------------------------------------------------------------------------




