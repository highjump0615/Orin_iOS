//
//  ImageCacheDelegate.h
//  IPadCMVideoCS
//
//  Created by liuzhongguo on 11-3-30.
//  Copyright 2011年 上海网达软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ImageCacheDelegate <NSObject>
@optional

- (void)getImageFinished:(NSDictionary *)imageCache;
- (void)getImageFailed:(NSDictionary *)imageCache;
@end
