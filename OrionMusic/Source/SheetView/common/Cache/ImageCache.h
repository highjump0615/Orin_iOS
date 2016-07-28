//
//  ImageCache.h
//  IPadCMVideoCS
//
//  Created by liuzhongguo on 11-3-29.
//  Copyright 2011年 上海网达软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCacheDelegate.h"

#import "SDWebImageManagerDelegate.h"

extern NSString *const IMAGE_RESULT_KEY;
extern NSString *const IMAGE_URL_KEY;
extern NSString *const IMAGE_OBJECT_KEY;

@interface ImageCache : NSObject <SDWebImageManagerDelegate>{
  id<ImageCacheDelegate> delegate;
  BOOL isCache;
  
  NSString *imageUrl;
  id object;
    int tag;
  SEL didGetImageFinishSelector;
  SEL didGetImageFailSelector;
}


@property (assign) SEL didGetImageFinishSelector;
@property (assign) SEL didGetImageFailSelector;
@property (assign) int tag;

//- (void)getImageStarted;
- (void)getImageFinished:(NSDictionary *)imageCache;
- (void)getImageFailed;

- (id)initWithURLString: (NSString*)url imageObj:(id)imageObj;
/**
 * 设置是否缓存，默认为YES
 */
- (void)setIsCache:(BOOL)cache;
- (void)setDelegate:(id)newDelegate;

- (UIImage*)getImageFromNet:(NSString *)url;
- (UIImage*)getImageFromCache:(NSString *)url;
- (BOOL)saveImageToCache:(NSData *)image imgUrl :(NSString *)url;
+ (NSString *)imageCachePath:(NSString *)url;
- (NSString *)imageCacheName:(NSString *)url;

+ (ImageCache*)getInstance;
- (void) initwithStringAndObject:(NSString*)url imageObj:(id)imageObj delegate:(id)myDelegate;
- (void) initwithStringAndObjectOld:(NSString*)url imageObj:(id)imageObj delegate:(id)myDelegate;
- (void) clearpicM;
@end
