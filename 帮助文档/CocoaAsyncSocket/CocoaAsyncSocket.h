//
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#pragma mark - CocoaAsyncSocket

CocoaAsyncSocket支持tcp和udp。
其中：
    AsyncSocket类是支持TCP的
    AsyncUdpSocket是支持UDP的

AsyncSocket是封装了CFSocket和CFSteam的TCP/IP socket网络库。它提供了异步操作，本地cocoa类的基于delegate的完整支持。
主要有以下特性：
    队列的非阻塞的读和写，而且可选超时。你可以调用它读取和写入，它会当完成后告知你自动的socket接收。如果你调用它接收连接，它将为每个连接启动新的实例，当然，也可以立即关闭这些连接委托（delegate）支持。错误、连接、接收、完整的读取、完整的写入、进度以及断开连接，都可以通过委托模式调用基于run loop的，而不是线程的。虽然可以在主线程或者工作线程中使用它，但你不需要这样做。它异步的调用委托方法，使用NSRunLoop。委托方法包括 socket的参数，可让你在多个实例中区分自包含在一个类中。你无需操作流或者socket，这个类帮你做了全部支持基于IPV4和IPV6的TCP流。
以下内容是根据官方网站参考:https://github.com/robbiehanson/CocoaAsyncSocket

编写的示例。
准备工作：如何在iOS项目中使用
    可按照上述官方网站链接：https://github.com/robbiehanson/CocoaAsyncSocket来执行
基本上是两步：
将CocoaAsyncSocket项目中的.h和.m文件拖拽到自己项目的Classes目录中
添加framework：CFNetwork
