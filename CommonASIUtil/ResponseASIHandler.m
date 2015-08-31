//
//  ResponseASIHandler.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ResponseASIHandler.h"
#import "NSString+Encoding.h"
#import "CommonHUD.h"

@implementation ResponseASIHandler

+ (void)onSuccess:(ASIHTTPRequest *)request callback:(id<WebServiceASIDelegate>)delegate{
    [delegate onRequestSuccess:request];
}

//注意：这里将错误信息的提示统一写到这个文件下，是为了防止使用delegate和block的时候要重写一遍.
//并且：这里再进一步将错误信息的UI提示写到BaseViewController中,然后之后所有会调用网络请求的页面都要继承自这个BaseViewController。但尤其注意实际类中要添加[super onRequestFail:request];来操作super。否则无效。
+ (void)onFailure:(ASIHTTPRequest *)request callback:(id<WebServiceASIDelegate>)delegate{
    NSLog(@"======分割线======");
    NSInteger errorCode = [[request error] code];
    //NSError *error = request.error;
    NSString *errorMesg = [self getErrorMesgFromRequestErrorCode:request];
    NSLog(@"errorCode = %zd, errMesg = %@", errorCode, errorMesg); //[error description]、[error localizedDescription]、[error userInfo]
    
    NSInteger statusCode = [request responseStatusCode];
    NSString *failMesg = [self getFailMesgFromRequestStatusCode:request];
    NSLog(@"statusCode = %zd, failMesg = %@", statusCode, failMesg);
    NSLog(@"======分割线======");
    
    if (delegate && [delegate respondsToSelector:@selector(onRequestFailure:)]) {
        [delegate onRequestFailure:request];
    }else{
        [CommonHUD hud_showErrorText:failMesg];
    }
}


//根据status code 获取错误信息
+ (NSString *)getFailMesgFromRequestStatusCode:(ASIHTTPRequest *)request{
    
    int errorCode = [[request error] code];
    NSLog(@"errorCode = %d", errorCode);
    
    NSInteger statusCode = [request responseStatusCode];
    NSLog(@"statusCode = %d", statusCode);
    NSString *response = [request responseString];
    if (statusCode == 500) {
        response = NSLocalizedString(@"服务器内部错误", nil);//参照服务器状态码大全
    }else{
        response = [response Unicode_To_Chinese];
    }
    
    NSString *failMesg = [NSString stringWithFormat:@"%@", response];
    return failMesg;
}

//根据error code 获取错误信息
+ (NSString *)getErrorMesgFromRequestErrorCode:(ASIHTTPRequest *)request{
    NSString *errorString = [NSString stringWithFormat:@"%@", [request error]];
    //NSLog(@"errorString = %@", errorString);
    
    NSString *errorMesg = errorString;
    /*
     ASIConnectionFailureErrorType = 1,
     ASIRequestTimedOutErrorType = 2,
     ASIAuthenticationErrorType = 3,
     ASIRequestCancelledErrorType = 4,
     ASIUnableToCreateRequestErrorType = 5,
     ASIInternalErrorWhileBuildingRequestType  = 6,
     ASIInternalErrorWhileApplyingCredentialsType  = 7,
     ASIFileManagementError = 8,
     ASITooMuchRedirectionErrorType = 9,
     ASIUnhandledExceptionError = 10,
     ASICompressionError = 11
     */
    switch ([[request error] code]) {
        case ASIConnectionFailureErrorType:
            errorMesg = NSLocalizedString(@"网络连接失败，请检查您的网络", nil);
            break;
        case ASIRequestTimedOutErrorType:
            errorMesg = NSLocalizedString(@"网络连接超时，请检查您的网络", nil);
            break;
        case ASIAuthenticationErrorType:
            errorMesg = NSLocalizedString(@"用户名或密码错误，请重新输入", nil);
            break;
        case ASIRequestCancelledErrorType:
            
            break;
        case ASIUnableToCreateRequestErrorType:
            
            break;
        case ASIInternalErrorWhileBuildingRequestType:
            
            break;
        case ASIInternalErrorWhileApplyingCredentialsType:
            
            break;
        case ASIFileManagementError:
            
            break;
        case ASITooMuchRedirectionErrorType:
            
            break;
        case ASIUnhandledExceptionError:
            
            break;
        case ASICompressionError:
            
            break;
        default:
            break;
    }
    
    
    
    NSLog(@"请求失败: %@", errorMesg);
    
    return errorMesg;
}


@end
