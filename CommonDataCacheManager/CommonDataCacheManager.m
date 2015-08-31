//
//  CommonDataCacheManager.m
//  SDWebData
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonDataCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

#define kCacheData  @"data"
#define kCacheKey   @"dataKey"
#define kCacheDelegate  @"delegate"
#define kCacheUserInfo  @"userinfo"

static NSString *const kDataCacheDirectory = @"DataCache";
static NSString *const kImageCacheDirector = @"ImageCache";

static CommonDataCacheManager *sharedCacheInstance;

@implementation CommonDataCacheManager
@synthesize memoryCacheMaxage, memoryCacheMaxsize;


#pragma mark SDDataCache (class methods)

+ (CommonDataCacheManager *)sharedCacheManager
{
    @synchronized (self) {
        if (nil == sharedCacheInstance) {
            sharedCacheInstance = [[CommonDataCacheManager alloc] init];
        }
        return sharedCacheInstance;
    }
}

- (id)init
{
    self = [super init];
    if (self){
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDataCacheDirectory];
        imageCachePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:kImageCacheDirector];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:imageCachePath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:imageCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        // Init the memory cache
        memoryCache = [[NSMutableDictionary alloc] init];
        memoryCacheKeyArray = [[NSMutableArray alloc] init];
        
        memoryCacheMaxage = 7*24*60*60;     //default:1 week
        memoryCacheMaxsize = 2*1024*1024;   //default:2 M
		
        
		//clean pass cache
//        [self cleanDisk];

        // Init the operation queue
        cacheInQueue = [[NSOperationQueue alloc] init];
        cacheInQueue.maxConcurrentOperationCount = 1;
        cacheOutQueue = [[NSOperationQueue alloc] init];
        cacheOutQueue.maxConcurrentOperationCount = 1;
        
#if TARGET_OS_IPHONE//如果是真机
        //①内存警告：清理内存；
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemoryCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        */
    #ifdef __IPHONE_4_0
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported)
        {
            //②进入后台：清理内存；
            // When in background, clean memory in order to have less chance to be killed
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clearMemoryCache)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
		
        /*
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        */
    #endif
#endif
    }
	
    return self;
}



#pragma mark DataCache

- (void)cacheData:(NSData *)cacheData forCacheKey:(NSString *)cacheKey
{
	[self cacheData:cacheData forCacheKey:cacheKey toDisk:YES];
}

- (void)cacheData:(NSData *)cacheData forCacheKey:(NSString *)cacheKey toDisk:(BOOL)toDisk
{
    if (!cacheData){
        NSLog(@"无数据可用于保存");
        return;
    }
    
    if (!cacheKey){
        NSLog(@"无设置保存地址，无法保存");
        return;
    }
	
    
    NSDictionary *arguments = @{kCacheData : cacheData,
                                kCacheKey  : cacheKey};
    
    //保存到内存
    [self cacheDataToMemory:arguments];
	
    //是否保存到磁盘
    if (toDisk){
        //用NSInvocationOperation建了一个后台线程，并且放到NSOperationQueue中。后台线程执行cacheDataToDisk:方法。
        [cacheInQueue addOperation:[[NSInvocationOperation alloc]initWithTarget:self
                                                                       selector:@selector(cacheDataToDisk:)
                                                                         object:arguments]];
    }else{
        NSLog(@"不保存到磁盘，只保存到内存");
    }
    
}

- (void)cacheDataToMemory:(NSDictionary *)arguments{
    NSData *data = [arguments objectForKey:kCacheData];
    NSString *key = [arguments objectForKey:kCacheKey];
    
    if (data.length > memoryCacheMaxsize){
        NSLog(@"当前该条数据过大，超过缓存最大值(默认2M)，无法保存");
        return;
    }
    
    //block统计当前已缓存的数据的大小的方法
    unsigned long long(^block)(void);
    block = ^{
        unsigned long long  curMemoryCacheSize = 0;
        for (id object in [memoryCache allValues])
        {
            if ([object isKindOfClass:[NSData class]]){
                curMemoryCacheSize += [(NSData *)object length];
            }
        }
        return curMemoryCacheSize;
    };
    
    //当之前数据加上现要缓存的数据超过最大缓存空间时，对缓存空间进行如下清理：即删除旧缓存的数据以腾出空间来存储新数据，旧缓存数据的删除方法为从最老的缓存数据开始清理，直至所腾出的空间足够当前值存储。
    while ([memoryCacheKeyArray count]>0 && block()+data.length>memoryCacheMaxsize)
    {
        id firstKey = [memoryCacheKeyArray objectAtIndex:0];
        [memoryCache removeObjectForKey:firstKey];
        [memoryCacheKeyArray removeObject:firstKey];
    }
    
    //开始进行缓存（其中：先删除当前缓存数据所对应的地址key,再增加的目的是为了能够在缓存key数组中判别出当前数据的新旧程度，越新越后面）
    [memoryCache setObject:data forKey:key];
    [memoryCacheKeyArray removeObject:key];
    [memoryCacheKeyArray addObject:key];
}


- (void)cacheDataToDisk:(NSDictionary *)arguments
{
    // Can't use defaultManager another thread
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSData *data = [arguments objectForKey:kCacheData];
    NSString *key = [arguments objectForKey:kCacheKey];
    if (data){
        NSString *cachePath = [self diskCachePathForKey:key];
        NSLog(@"磁盘缓存路径为：%@",cachePath);
        
        [fileManager createFileAtPath:cachePath contents:data attributes:nil];
    }
}


- (NSString *)diskCachePathForKey:(NSString *)key
{
    NSString *filename = [key MD5]; //确保key中不含不规则字符，如斜杠冒号等
    NSString *cachePath = [diskCachePath stringByAppendingPathComponent:filename];
    return cachePath;
}




#pragma mark - 根据key获取缓存数据
- (NSData *)dataFromKey:(NSString *)key
{
    return [self dataFromKey:key isMemoryCacheNil_then_getFromDisk:YES];
}

- (NSData *)dataFromKey:(NSString *)key isMemoryCacheNil_then_getFromDisk:(BOOL)isMemoryCacheNil_then_getFromDisk
{
    if (key == nil){
        NSLog(@"取值地址为空，请重新输入");
        return nil;
    }
	
	NSData *data = [memoryCache objectForKey:key];//先从内存中取值
    if (data != nil) {
        return data;
    }else{          //如果内存中的值为空，再尝试中磁盘中取值
        if (isMemoryCacheNil_then_getFromDisk) {
            NSLog(@"内存中未读到数据，又未从磁盘中读取数据，所以这里返回Nil");
            return nil;
        }
        
        data = [[NSData alloc] initWithContentsOfFile:[self diskCachePathForKey:key]];
        if (data){ //之前内存中可能由于清理内存等缘故，该数据所对的key已被清理，所以当能从磁盘中读到该key所对的数据时，记得顺便存到内存中，因为下次可以从内存中直接读取数据，那样更快
            NSDictionary *m_arguments = @{kCacheData : data,
                                          kCacheKey  : key};
            [self cacheDataToMemory:m_arguments];
        }
        return data;
    }
}


#pragma mark - 内存和磁盘的清理
- (void)removeMemoryCacheForKey:(NSString *)cacheKey
{
    if (cacheKey == nil){
        return;
    }
	
    [memoryCache removeObjectForKey:cacheKey];
    [memoryCacheKeyArray removeObject:cacheKey];
    
    [[NSFileManager defaultManager] removeItemAtPath:[self diskCachePathForKey:cacheKey] error:nil];
}

- (void)clearMemoryCache
{
    [cacheInQueue cancelAllOperations]; // won't be able to complete
    
    [memoryCache removeAllObjects];
    [memoryCacheKeyArray removeAllObjects];
}


- (void)clearDiskCache
{
    [cacheInQueue cancelAllOperations];
    
    //clear data
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];

    [[NSFileManager defaultManager] removeItemAtPath:imageCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

- (void)cleanDiskCache//清理过期的缓存
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-memoryCacheMaxage];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
		if ([[attrs fileModificationDate] compare:expirationDate]==NSOrderedAscending)
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }

    NSDirectoryEnumerator *fileEnumerator_imageCache = [[NSFileManager defaultManager] enumeratorAtPath:imageCachePath];
    for (NSString *fileName in fileEnumerator_imageCache)
    {
        NSString *filePath = [imageCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
		if ([[attrs fileModificationDate] compare:expirationDate]==NSOrderedAscending)
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }



}

#pragma mark - 内存信息获取
- (float)cacheFileSize{ //内存大小获取
    float dataSize = [self folderSizeAtPath:diskCachePath];
    float imageSize = [self folderSizeAtPath:imageCachePath];
    return (dataSize + imageSize);
}

//遍历文件夹获得文件夹大小，返回多少M
- (float )folderSizeAtPath:(NSString *)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}




#pragma mark 获取数据
- (void)queryDiskCacheForKey:(NSString *)cacheKey delegate:(id <CommonDataCacheManagerDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    if (!delegate){
        return;
    }
    
    if (!cacheKey){
        NSLog(@"未设置搜索地址，提示未找到相关数据");
        if ([delegate respondsToSelector:@selector(dataCache:didNotFindDataForKey:userInfo:)]){
            [delegate dataCache:self didNotFindDataForKey:cacheKey userInfo:userInfo];
        }
        return;
    }
    
    // First check the in-memory cache...
    NSData *data = [memoryCache objectForKey:cacheKey];
    if (data){
        // ...notify delegate immediately, no need to go async
        if ([delegate respondsToSelector:@selector(dataCache:didFindData:forKey:userInfo:)]){
            [delegate dataCache:self didFindData:data forKey:cacheKey userInfo:userInfo];
        }
        return;
    }
    
    //If no find data in memory, then check in disk
    NSMutableDictionary *arguments = [NSMutableDictionary dictionaryWithCapacity:3];
    [arguments setObject:cacheKey forKey:kCacheKey];
    [arguments setObject:delegate forKey:kCacheDelegate];
    if (userInfo){
        [arguments setObject:userInfo forKey:kCacheUserInfo];
    }
    [cacheOutQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(queryDiskCacheOperation:) object:arguments]];
}

- (void)queryDiskCacheOperation:(NSDictionary *)arguments
{
    NSMutableDictionary *mutableArguments = [arguments mutableCopy];
    
    NSString *cacheKey = [arguments objectForKey:kCacheKey];
    NSString *filePath = [self diskCachePathForKey:cacheKey];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    if (data){
        [mutableArguments setObject:data forKey:kCacheData];
    }
    
    [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:mutableArguments waitUntilDone:NO];
}

- (void)notifyDelegate:(NSDictionary *)arguments
{
    id <CommonDataCacheManagerDelegate> delegate = [arguments objectForKey:kCacheDelegate];
    NSDictionary *userInfo = [arguments objectForKey:kCacheUserInfo];
    
    NSString *cacheKey = [arguments objectForKey:kCacheKey];
    NSData *data = [arguments objectForKey:kCacheData];
    
    if (data){
        NSDictionary *m_arguments = @{kCacheData : data,
                                      kCacheKey  : cacheKey};
        [self cacheDataToMemory:m_arguments];
        
        if ([delegate respondsToSelector:@selector(dataCache:didFindData:forKey:userInfo:)]){
            [delegate dataCache:self didFindData:data forKey:cacheKey userInfo:userInfo];
        }
    }
    else{
        if ([delegate respondsToSelector:@selector(dataCache:didNotFindDataForKey:userInfo:)]){
            [delegate dataCache:self didNotFindDataForKey:cacheKey userInfo:userInfo];
        }
    }
}


- (void)dealloc
{
//    memoryCache = nil;
//    diskCachePath = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
