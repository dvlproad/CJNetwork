# CommonAFNUtil
AFN基类

#### Screenshots
![Example](./Screenshots/Demo.gif "Demo")
![Example](./Screenshots/Demo.png "Demo")

CommonAFNInstance需

```
#import "NetworkManager.h"
#import "CommonDataCacheManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking.h>
```

CommonDataCacheManager需

```
#import "NSDictionary+Convert.h"
#import "NSData+Convert.h"
#import "NSString+MD5.h"
```

##基础知识了解
1、单例：dispatch_once （使用dispatch_once时，不用使用@synchronized）
单例是一种用于实现单例的数学概念，即将类的实例化限制成仅一个对象的设计模式。
或者我的理解是：单例是一种类，该类只能实例化一个对象。

实现单例模式的函数就是void dispatch_once( dispatch_once_t *predicate, dispatch_block_t block);
该函数接收一个dispatch_once用于检查该代码块是否已经被调度的谓词（是一个长整型，实际上作为BOOL使用）。它还接收一个希望在应用的生命周期内仅被调度一次的代码块，对于本例就用于shared实例的实例化。
dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的，这就意味着你不需要使用诸如@synchronized之类的来防止使用多个线程或者队列时不同步的问题。
Apple的GCD Documentation证实了这一点:
如果被多个线程调用，该函数会同步等等直至代码块完成。

示例：在整个应用中访问某个类的共享实例
```
+ (NetworkManager *)sharedInstance
{
    static NetworkManager *sharedManager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetworkManager alloc] init];
    });

    return sharedManager;
}
```
就这些，你现在在应用中就有一个共享的实例，该实例只会被创建一次。
下次你任何时候访问共享实例，需要做的仅是：NetworkManager *networkManager = [NetworkManager sharedInstance];

2、线程的同步执行@synchronized
为了防止多个线程同时执行同一个代码块，OC提供了@synchronized()指令。使用@synchronized()指令可以锁住在线程中执行的某一个代码块。存在被保护（即被锁住）的代码块的其他线程，将被阻塞，这也就意味着，他们将在@synchronized()代码块的最后一条语句执行结束后才能继续执行。
@synchronized()指令的唯一参数可以使用任何OC对象，包括self。这个对象就是我们所谓的信号量。