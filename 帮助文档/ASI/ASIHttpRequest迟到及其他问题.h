
//①②

#pragma mark - ASIHTTPRequest迟到的结果(http://seanwong.lofter.com/post/3ecae_df678/)
ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
[request setDelegate:self];
[request startAsynchronous];

这段本身没什么问题，在Navigation Controller驱动下，用户点快了之后，异步请求返回慢了，会出MyViewController respondsToSelector:]: message sent to deallocated instance这种错误。
也就是说delegate一般设置为自身，跳到另外一个view之后，自身会被回收，等到ASIHTTPRequest返回结果，准备调用requestFinished或者requestFailed代理方法的时候，找不到入口了。(等网络回来的时候 调用delegate的控制器MyViewController就不存在了，MyViewController变成了野指针，调用方法时就会崩溃 如果release之后 将detail = nil；不会出现挂机。)

解决办法：
- (void)dealloc {
    
    //在回收自身的时候，取消发出的请求，当然如果是多个request，可以都放到请求队列，一并撤销。
    [self.request cancel];
    [self.request setDelegate:nil];

    [super dealloc];
}


ViewController respondsToSelector 错误的解决方法
[****ViewController respondsToSelector:]: message sent to deallocated instance

原因解析：
某个公共类或系统提供的控件，存在delegate方法，当创建此公共控件的容器类已经销毁，
而这个控件对应的服务是在其它run loop中进行的，控件销毁或者需要进行状态通知时，依然按照
delegate的指针去通知，则会出现这个问题。

本问题解法：
创建 MKMapView时设置了delegate
容器类的dealloc方法中要，将其delegate=nil；






#pragma mark - ASIHTTPRequest使用过程中遇到的问题及解决办法：（http://www.cnblogs.com/soap1984/archive/2011/12/05/problem_about_ASIHTTPRequest.html）



#pragma mark - 对头域的提取可以使用如下方法：
[request responseStatusCode];  
[[request responseHeaders] objectForKey:@"X-Powered-By"];  
[request responseEncoding];
 

#pragma mark - ASIHTTPRequestErrorDomain Code=5的问题
NSString *string = [NSString stringWithFormat:@"%@", [request error]];
Error Domain=ASIHTTPRequestErrorDomain Code=5 "Unable to create request (bad url?)" UserInfo=0x14655610 {NSLocalizedDescription=Unable to create request (bad url?)}

答：//当URL中包含汉字(日文)、空格等字符时，需要显示的转换一下编码！！！否则会使得使用NSURL *URL = [NSURL URLWithString:URLString];时，URL值为空。
NSString *URLString = [@""stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSURL *URL = [NSURL URLWithString:URLString];
NSLog(@"URL:%@", URL);


    
    NSLog(@"%@", [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);


#pragma mark - ASIHTTPRequest请求判断顺序

①、连接失败与否的判断
if ([request error]) { //用(NSNull *)[request error] != [NSNull null] 判断是错误的
    [PrivateSetting finishAnimating];
        
    NSString *string = [NSString stringWithFormat:@"%@", [request error]];
    [[[UIAlertView alloc]initWithTitle:@"请求失败" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
    return;
}

②、连接成功后返回的statusCode
NSInteger sCode = [request responseStatusCode];

③、连接成功后返回的response
NSString *response = [request responseString];
NSDictionary *dict = [response JSONValue];




#pragma mark - 在HttpHeader添加Token
+ (ASIHTTPRequest *)requestLogout{
    NSURL *URL = [NSURL URLWithString:@"http://10.167.146.39/drupal/api/user/logout"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    if ([self sharedInstance].token) {
        [request addRequestHeader:@"X-CSRF-Token" value:[self sharedInstance].token];
    }else{
        NSLog(@"error:token = nil");
    }
    [request setRequestMethod:@"POST"];
    
    return request;
}


#pragma mark - iOS通过ASIHTTPRequest提交JSON数据(http://my.oschina.net/LangZiAiFer/blog/200742)
+ (ASIHTTPRequest *)requestURL:(NSURL *)URL params:(NSDictionary *)params{
    
    if ([NSJSONSerialization isValidJSONObject:params] == NO){
        NSLog(@"error: isNotValidJSONObject");
        return nil;
    }
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    //[request addRequestHeader:@"Accept" value:@"application/json"];//不用写
    [request setRequestMethod:@"POST"];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    //NSLog(@"Register JSON:%@",[[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding]);
    
    [request setPostBody:tempJsonData];
    
    return request;
}


+ (ASIHTTPRequest *)requestLoginByName:(NSString *)name pasd:(NSString *)pasd{

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:name forKey:@"username"];
    [params setValue:pasd forKey:@"password"];
    
    if ([NSJSONSerialization isValidJSONObject:params] == NO){
        NSLog(@"error: isNotValidJSONObject");
        return nil;
    }


    NSURL *URL = [NSURL URLWithString:@"http://10.167.146.39/drupal/api/user/login"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setRequestMethod:@"POST"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    //NSLog(@"Register JSON:%@",[[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding]);
    
    [request setPostBody:tempJsonData];
    
    return request;

}




获取statuscode        NSInteger statuscode = [request responseStatusCode];
获取errorcode         NSInteger errorcode = [[request error] code];

获取responseCookies  ([cookie name], [cookie value])
方法①：NSArray *cookies = [request responseCookies];
或者
方法②：NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
NSArray *cookies = [cookieJar cookies];

正常情况下，发给网络请求的参数，一定是json格式的。
我们我们所传的参数都要转成json格式，不过有时候不需要我们转，是因为我们所发的网址能够处理我们的参数，将它转变成json格式。

//ASIHttpRequest默认使用cookie。所以不用在代码中重新设置。附：设置 cookie 使用策略：使用（默认）
[request setUseCookiePersistence:YES];


Error Domain=ASIHTTPRequestErrorDomain Code=2

在#import "ASIHTTPRequest.h"中可查看得到：
typedef enum _ASINetworkErrorType {
    ASIConnectionFailureErrorType = 1,
    ASIRequestTimedOutErrorType = 2,
    ASIAuthenticationErrorType = 3,
    ASIRequestCancelledErrorType = 4,
    ASIUnableToCreateRequestErrorType = 5,
    ASIInternalErrorWhileBuildingRequestType  = 6,
    ASIInternalErrorWhileApplyingCredentialsType  = 7,
	ASIFileManagementError = 8,
	ASITooMuchRedirectionErrorType = 9,
	ASIUnhandledExceptionError = 10,    //未经处理的异常。需要用户决定处理方式
	ASICompressionError = 11
	
} ASINetworkErrorType;




request.defaultResponseEncoding = NSUTF8StringEncoding;
request.responseEncoding = NSUTF8StringEncoding;


