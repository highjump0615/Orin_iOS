//
//  CMVideoHttp.h
//  IPadCMVideoCS
//
//  Created by root on 11-3-15.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface CMVideoHttp : ASIHTTPRequest {
}

+ (id)requestWithURL:(NSURL *)newURL;

+ (id)requestWithURLString:(NSString *)url;

+ (id)requestWithURLString:(NSString *)url retryTimes:(int)times;
@end
