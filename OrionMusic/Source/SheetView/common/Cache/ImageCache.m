//
//  ImageCache.m
//  IPadCMVideoCS
//
//  Created by liuzhongguo on 11-3-29.
//  Copyright 2011年 上海网达软件有限公司. All rights reserved.
//

#import "ImageCache.h"
#import "CMVideoHttp.h"
#import "CMVideoUtil.h"
#import "SDWebImageManager.h"
//#import "YoutubeAppDelegate.h"

NSString *const IMAGE_RESULT_KEY = @"image";
NSString *const IMAGE_URL_KEY = @"url";
NSString *const IMAGE_OBJECT_KEY = @"object";

@implementation ImageCache
@synthesize tag;
+ (void)initialize
{
    //	if (self == [ImageCache class]) {
    //    WDLog(@"11==000");
    //    sharedQueue = [[NSOperationQueue alloc] init];
    //		[sharedQueue setMaxConcurrentOperationCount:IMAGE_OPERATION_COUNT];
    //  }
}

+ (ImageCache*)getInstance
{
    static ImageCache* instance = nil;
    @synchronized(self)
    {
        if (instance == nil)
        {
//            WDLog(@"img cache instance");
            instance = [[ImageCache alloc] init];
        }
    }
    return instance;
}

//- (void) initwithStringAndObject:(NSString*)url imageObj:(id)imageObj delegate:(id)myDelegate
//{
//    if (url != nil && ![@"" isEqualToString:url])
//    {
//        delegate = myDelegate;
//        
//        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
//        [result setValue:url forKey:IMAGE_URL_KEY];
//        [result setValue:imageObj forKey:IMAGE_OBJECT_KEY];
//        UIImage *img = [self getImageFromCache:url];
//        if (img) 
//        {
//            [result setValue:img forKey:IMAGE_RESULT_KEY];
//            if ([delegate respondsToSelector:@selector(getImageFinished:)])
//            {
//                [delegate getImageFinished:result];
//            }
//        }
//        else
//        {
//            CMVideoHttp *request = [CMVideoHttp requestWithURLString:url retryTimes:1];
//            [request setUserInfo:result];
//            [request setDelegate:self];
//            [request setDidFinishSelector:@selector(requestFinished:)];
//            [request setDidFailSelector:@selector(requestFailed:)];
//            [request startAsynchronous];
//        }
//        
//        [result release];
//    }
//}

//modify by tsh 2011-9-23
- (void) initwithStringAndObject:(NSString*)url imageObj:(id)imageObj delegate:(id)myDelegate
{
    if (url != nil && ![@"" isEqualToString:url])
    {
        delegate = myDelegate;
        SDWebImageManager *manaer = [SDWebImageManager sharedManager];
        [manaer downloadWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if ([imageObj isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView = (UIImageView*)imageObj;
                [imageView setImage:image];
            }
            else if([imageObj isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton*)imageObj;
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn setBackgroundImage:image forState:UIControlStateSelected];
                [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            }
        }];
    }
}

- (void) clearpicM
{
//    SDWebImageManager *manaer = [SDWebImageManager sharedManager];
//    [manaer clearM];
    [[SDImageCache sharedImageCache] clearMemory];
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithObject:(id)result
{
    [CMVideoUtil setImageToObject:result];
}
//end


- (void) initwithStringAndObjectOld:(NSString*)url imageObj:(id)imageObj delegate:(id)myDelegate
{
    if (url != nil && ![@"" isEqualToString:url])
    {
        delegate = myDelegate;
        
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setValue:url forKey:IMAGE_URL_KEY];
        [result setValue:imageObj forKey:IMAGE_OBJECT_KEY];
        UIImage *img = [self getImageFromCache:url];
        if (img) 
        {
            [result setValue:img forKey:IMAGE_RESULT_KEY];
            if ([delegate respondsToSelector:@selector(getImageFinished:)])
            {
                [delegate getImageFinished:result];
            }
        }
        else
        {
            CMVideoHttp *request = [CMVideoHttp requestWithURLString:url retryTimes:1];
            [request setUserInfo:result];
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(requestFinished:)];
            [request setDidFailSelector:@selector(requestFailed:)];
            [request startAsynchronous];
        }
        
        [result release];
    }
}

- (void)requestFailed:(CMVideoHttp*)request
{
    request.userInfo = nil;
}

- (void)requestFinished:(CMVideoHttp*)request
{
    NSMutableDictionary *result = (NSMutableDictionary*)[request userInfo];
    UIImage *image = [UIImage imageWithData:[request responseData]];
    [self saveImageToCache:[request responseData] imgUrl:[result objectForKey:IMAGE_URL_KEY]];
    [result setValue:image forKey:IMAGE_RESULT_KEY];
    if ([delegate respondsToSelector:@selector(getImageFinished:)])
    {
        [delegate getImageFinished:result];
    }
    request.userInfo = nil;
}

- (id)initWithURLString: (NSString*)url imageObj:(id)imageObj
{
    self = [super init];
    if (self) {
        isCache = YES;
        imageUrl = [url retain];
        object = imageObj;
        [self setDidGetImageFinishSelector:@selector(getImageFinished:)];
        //[self setDidGetImageFailSelector:@selector(getImageFailed:)];
    }
    return self;
}

- (void)setDelegate:(id)newDelegate
{  
	delegate = newDelegate;
}

/**
 * 设置是否缓存，默认为YES
 */
- (void)setIsCache:(BOOL)cache
{
    isCache = cache;
}

- (void)getImageFinished:(NSDictionary *)imageCache
{
//	WDLog(@"get image finished!!!");
    [CMVideoUtil setImageToObject:imageCache];
}

- (void)getImageFailed
{
//	WDLog(@"get image failed!!!");
}

- (UIImage*)getImageFromCache:(NSString *)url
{
    NSString* imagePath = [NSString stringWithFormat:@"%@/%@",[ImageCache imageCachePath:url], [self imageCacheName:url]];
	NSData *data = [[NSData alloc] initWithContentsOfFile:imagePath];
	UIImage *image = [UIImage imageWithData:data];
   
	[data release];
	return image;
}

- (UIImage*)getImageFromNet:(NSString *)url
{
    UIImage *image = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    if ((data != nil) && ([data length] > 0))
    {
        image = [[UIImage alloc] initWithData:data];
        [self saveImageToCache:data imgUrl:url];
        
    }
    [data release]; 
    return image;
}

- (BOOL)saveImageToCache:(NSData *)image imgUrl :(NSString *)url
{
    NSString* imagePath = [ImageCache imageCachePath:url];
//    WDLog(@"image cache path:%@",imagePath);
    if ((image == nil) || (imagePath == nil) || ([imagePath isEqualToString:@""]))
        return NO;
    BOOL createPath =[[NSFileManager defaultManager] createDirectoryAtPath:imagePath 
                                               withIntermediateDirectories:YES attributes:nil error:nil];
    if (createPath) 
    {
        @try
        {
            NSString* dataPath = [NSString stringWithFormat:@"%@/%@",imagePath, [self imageCacheName:url]];
            if ((image == nil) || ([image length] <= 0))
                return NO;
            [image writeToFile:dataPath atomically:YES];
            return YES;
        }
        @catch (NSException *e)
        {    
//            WDLog(@"create thumbnail exception.");
        }
    }
    else
    {
        return createPath;
    }
    return NO;
}

+ (NSString *)imageCachePath:(NSString *)url
{
    NSString *documentsDirectory = [CMVideoUtil getCachePath];
    NSString* imagePath = [NSString stringWithFormat:@"%@/cache/image", documentsDirectory];
    return imagePath;
}

- (NSString *)imageCacheName:(NSString *)url
{
    return [NSString stringWithFormat:@"%@", [CMVideoUtil md5:url]];
}

- (void)dealloc
{
    [imageUrl release];
    [super dealloc];
}

@synthesize didGetImageFinishSelector;
@synthesize didGetImageFailSelector;
@end