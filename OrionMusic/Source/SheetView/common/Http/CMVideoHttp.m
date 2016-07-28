//
//  CMVideoHttp.m
//  IPadCMVideoCS
//
//  Created by root on 11-3-15.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import "CMVideoHttp.h"
//#import "AppConst.h"
#import "CMVideoUtil.h"

@implementation CMVideoHttp

+ (id)requestWithURL:(NSURL *)newURL
{
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:newURL];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
   // [request setNumberOfTimesToRetryOnTimeout:0];
    [request setShouldContinueWhenAppEntersBackground:YES];
    return request;
}

+ (id)requestWithURLString:(NSString *)url
{
    NSURL *newURL = [CMVideoUtil stringToURL: url];
    return [self requestWithURL:newURL]; 
}

+ (id)requestWithURLString:(NSString *)url retryTimes:(int)times
{
    NSURL *newURL = [CMVideoUtil stringToURL: url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:newURL];
    [request setTimeOutSeconds:60.0];
    
    [request setRequestMethod:@"POST"];
    //[request setNumberOfTimesToRetryOnTimeout:times];
    return request;
}
@end
