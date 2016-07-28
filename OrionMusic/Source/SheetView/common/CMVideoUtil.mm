    //
//  CMVideoUtil.m
//  IPadCMVideoCS
//
//  Created by root on 11-3-14.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import "CMVideoUtil.h"
//#import "AppConst.h"
#import "Reachability.h"
#include <sys/xattr.h>
@implementation CMVideoUtil


+(BOOL)verifyChinaMobile:(NSString*)userNum {
    int length = [userNum length];
	
	if (length!=11) {
		return NO;
	}
    
    int index = 0;
    for (index = 0; index < length; index++)
    {
        unichar endCharacter = [userNum characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9') 
            continue;
        else
            return NO;
    }
	
	//134,135,136,137,138,139,147,150,151,152,157,158,159,182,187,188
	NSArray *mobileAry=[NSArray arrayWithObjects:@"134",@"135",@"136",@"137",@"138",@"139",@"147",@"150",@"151",@"152",@"157",@"158",@"159",@"182",@"187",@"188",nil];
	NSString *tmpNum=[userNum substringToIndex:3];
	if ([mobileAry containsObject:tmpNum]) {
		return YES;
	}
    
    return NO;
}

+(BOOL)verifyPassword:(NSString*)password {
    int length = [password length];
	
	if (length!=4) {
		return NO;
	}
    
    int index = 0;
    for (index = 0; index < length; index++)
    {
        unichar endCharacter = [password characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9') 
            continue;
        else
            return NO;
    }
    return YES;
}

+ (void)setImageToObject:(NSDictionary *)img
{
  id obj = [img valueForKey:@"object"];
  UIImage *image = [img valueForKey:@"image"];
  if ([obj isKindOfClass:[UIImageView class]])
  {
    UIImageView *imageView = (UIImageView*)obj;
    [imageView setImage:image];
  }
  else if([obj isKindOfClass:[UIButton class]])
  {
    UIButton *btn = (UIButton*)obj;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateSelected];
    [btn setBackgroundImage:image forState:UIControlStateHighlighted];
  }
}
//描述：字典转nsdata
//参数：任意的Objective-C对象、数量类型、数组、结构、字符串、及更多其它类型
//返回值：nsdata
+ (NSData *)getDataFromDataSource:(id)rootObject
{
  NSString *str = [self jsonToString:rootObject error:nil];
  if (str == nil) 
  {
    str = [NSString stringWithFormat:@""];
  }
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	return data;
}

+ (id)coverDataToDic:(NSData*)data
{
  return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

//nsdata 转字典
+ (id)tranferDataFromData:(NSData *)data
{
    NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [self parserJson:aStr error:nil];
    [aStr release];
	return dic;
	
}

//字体三种大小：14 15 18
//灰色字体RGB：235，235，235
//深灰色背景RGB:79,79,79
+ (UIColor *)setTextFontColor
{
  return [[[UIColor alloc] initWithRed:0.92 green:0.92 blue:0.92 alpha:1.0] autorelease];
}

+ (UIColor*)getYFontColor
{
    return [[[UIColor alloc] initWithRed:0.96 green:0.58 blue:0.17 alpha:1.0] autorelease];
}

+ (UIColor *)setBgColor
{
  return [[[UIColor alloc] initWithRed:0.31 green:0.31 blue:0.31 alpha:1.0] autorelease];
}

+ (NSString*)timeToMString:(float)time
{
  float i = [[NSNumber numberWithFloat:time / 60] floatValue];
  return [NSString stringWithFormat:@"%0.1f", i];
}

+ (NSString*)timeToStringWithFormat:(float)time
{
  int t = [[NSNumber numberWithFloat:time] intValue];
  NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d", t / 60, t % 60];
  return  timeStr;
}

+(NSMutableArray  *)arrDistinct:(NSMutableArray  *)arr
{
	[CMVideoUtil vMergeSort:arr type:nil];
	int cur_number = INT_MAX;
	NSMutableArray *temp = [[NSMutableArray alloc] init]; 
	for (int i = 0; i < [arr count]; ++i) 
	{
		if (cur_number != [[arr objectAtIndex:i] intValue])
		{
			[temp addObject:[arr objectAtIndex:i]];
		}
		cur_number = [[arr objectAtIndex:i] intValue];
	}
	return [temp autorelease];
}

+(void)vMergeSort:(NSMutableArray *)arr type:(NSString *)type
{
	[CMVideoUtil vMerge_Sort:arr left:0 right:[arr count] - 1 type:type];
}

+(void)vMerge_Sort:(NSMutableArray *)arr left:(int)left right:(int)right type:(NSString *)type
{
	int center = 0;
	if (left<right) {
		center = (left + right)/2;
		[CMVideoUtil vMerge_Sort:arr left:left right:center type:type];
		[CMVideoUtil vMerge_Sort:arr left:center+1 right:right type:type];
		[CMVideoUtil vMerge:arr left:left center:center right:right type:type];
	}
}

+(void)vMerge:(NSMutableArray *)arr left:(int)left center:(int)center right:(int)right type:(NSString *)type
{
	int left1 = left;
	int right1 = center;
	int left2 = center + 1;
	int right2 = right;
	
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	
	while (left1<= right1 && left2 <= right2) 
	{
		if ([type isEqual:@"tag"]) 
		{
			if (((UIView *)[arr objectAtIndex:left1]).tag < ((UIView *)[arr objectAtIndex:left2]).tag) 
			{
				[temp addObject:[arr objectAtIndex:left1++]];
			}
			else
			{
				[temp addObject:[arr objectAtIndex:left2++]];
			}
			
		}
		else 
		{
			if ([[arr objectAtIndex:left1] intValue] < [[arr objectAtIndex:left2] intValue])
			{
				[temp addObject:[arr objectAtIndex:left1++]];
			}
			else
			{
				[temp addObject:[arr objectAtIndex:left2++]];
			}	
		}
	}
	
	while (left1 <= right1) 
	{
		[temp addObject:[arr objectAtIndex:left1++]];
	}
	
	while (left2 <= right2) 
	{
		[temp addObject:[arr objectAtIndex:left2++]];
	}
	
	for (int i = 0,k= left;k<=right;k++,i++) 
	{
		[arr replaceObjectAtIndex:k withObject:[temp objectAtIndex:i]];
	}
    [temp release];
}

+ (NSMutableDictionary*) parserJson: (NSString*) jsondata error: (NSError*) error
{
    SBJSON* jsonParser = [SBJSON new];
    NSMutableDictionary *jsonObject = [jsonParser objectWithString: jsondata error: &error];
    [jsonParser release];
    return jsonObject;
}

+ (NSString*) jsonToString:(id)json error: (NSError*) error
{
    SBJSON *jsonParser = [SBJSON new];
    NSString *str = [jsonParser stringWithObject:json error:&error];
    [jsonParser release];
    return str;
}

// 年月日获得 yyyyMMdd
+(NSString*)getDateNow
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    // 年月日获得
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                        fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
//    WDLog(@"year: %d month: %d, day: %d", year, month, day);
    NSString *dateString = [NSString stringWithFormat:@"%d%02d%02d", year, month, day];
    return dateString;
}

+ (BOOL)isReachable
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", SERVER_DOMAINMAP];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachable];
    }
}

+ (BOOL) isReachableViaWWAN
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", SERVER_DOMAINMAP];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachableViaWWAN];
    }
}

+ (BOOL)isReachableViaWiFi
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", SERVER_DOMAINMAP];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachableViaWiFi];
    }
}

+ (BOOL)isReachableMap
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", SERVER_DOMAINMAP, nil];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachable];
    }
}

+ (BOOL) isReachableViaWWANMap
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", SERVER_DOMAINMAP, nil];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachableViaWWAN];
    }
}

+ (BOOL)isReachableViaWiFiMap
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", SERVER_DOMAINMAP, nil];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachableViaWiFi];
    }
}

//yyyyMMdd
+ (NSDate *)stringToDate:(NSString *)string 
{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC +8"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
    return date;
}

+ (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC +8"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (UIImage*)imagePNGWithName:(NSString *)imageName
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
}

+ (UIImage*)imageJPGWithName:(NSString *)imageName
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"]];
}

// 描述：把字符串转换成URL编码
// 参数：urlStr[in] 字符串
// 返回值：对应的URL数据，如果urlStr为nil则返回nil
+ (NSURL*)stringToURL: (NSString*)urlStr
{
    NSString* newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	return [NSURL URLWithString: newUrlStr];
}

+ (NSString*)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString*)getAppPublishDate
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Bundle version publish date"];
}

//+ (NSString *)getUUID
//{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
//}

//+ (NSString*)getMachineICCID
//{
//	return [[UIDevice currentDevice] uniqueIdentifier];
//}

+(BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

//rgb:235 89 197
+ (UIColor *)fontColorRedWith197
{
    return [UIColor colorWithRed:235.0/255.0 green:89.0/255.0 blue:197.0/255.0 alpha:1.0];
}

//rgb:140 67 125
+ (UIColor *)fontColorRedWith125
{
    return [UIColor colorWithRed:140.0/255.0 green:67.0/255.0 blue:125.0/255.0 alpha:1.0];
}

//rgb:65 103 151
+ (UIColor *)fontColorBlueWith151
{
    return [UIColor colorWithRed:65.0/255.0 green:103.0/255.0 blue:151.0/255.0 alpha:1.0]; 
}

//rgb:165 188  216
+ (UIColor *)fontColorBlueWith216
{
    return [UIColor colorWithRed:165.0/255.0 green:188.0/255.0 blue:216.0/255.0 alpha:1.0]; 
}


//rgb:136 136 136
+ (UIColor *)fontColorGrayWith136
{
    return [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]; 
}

//rgb:160 161 178
+ (UIColor *)fontColorGrayWith178
{
    return [UIColor colorWithRed:160.0/255.0 green:161.0/255.0 blue:178.0/255.0 alpha:1.0]; 
}

//add by tsh
//rgb:122 156 199
+ (UIColor *)colorDay
{
    return [UIColor colorWithRed:(122.0/255.0) green:(156.0/255.0) blue:(199.0/255.0) alpha:1.0f]; 
}
//rgb:32 30 38
+ (UIColor *)colorNight
{
    return [UIColor colorWithRed:(32.0/255.0) green:(30.0/255.0) blue:(38.0/255.0) alpha:1.0f];
}
//end

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}


+(BOOL) isImageUrl:(NSString *)url
{
    if(url!=nil&&[url length]>10)
    {
        NSRange suffixRange = [url rangeOfString:@"." options:(NSBackwardsSearch)];
        if (suffixRange.location != NSNotFound) {
            NSString *suffix =  [[url substringFromIndex:suffixRange.location+1] lowercaseString];
            if ([@"jpg" isEqualToString:suffix]||[@"png" isEqualToString:suffix]||[@"jpeg" isEqualToString:suffix]) {
                return YES;
            }
        }
        return NO;
        
    }
    else
    {
        return NO;
    }
}

+ (BOOL)LessThan5FromDB: (NSString *) theDate 
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    
    NSTimeInterval cha=now-late;
    
    if (cha/(60*5)<1) {
        return YES;
    }
    return NO;
}

/**< hex Code in RGB */
+ (UIColor *)colorFromCode:(int)hexCode 
{
    float red   = ((hexCode >> 16) & 0x000000FF)/255.0f;
    float green = ((hexCode >> 8) & 0x000000FF)/255.0f;
    float blue  = ((hexCode) & 0x000000FF)/255.0f;
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:1.0f];

}

+ (NSString *) getDataStoragePath
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 5.0)
    {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [documentPaths objectAtIndex:0];
        NSString *dataDirctoryPath = [documentsDirectoryPath stringByAppendingPathComponent:@"data"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:dataDirctoryPath]) {
            BOOL isCreated = [fileManager createDirectoryAtPath:dataDirctoryPath attributes:nil];
            if (isCreated == YES) {
                NSURL *dataUrl = [NSURL URLWithString:dataDirctoryPath];
                [CMVideoUtil addSkipBackupAttributeToItemAtURL:dataUrl];
            }
        }
        return dataDirctoryPath;
    }
    else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if ([paths count]>0) {
            return [paths objectAtIndex:0];
        }
        return @"";
    }
}

+ (NSString *)getHttpUrlFromDic:(NSDictionary *)dic svrUrl:(NSString *)svrUrl
{
    if (svrUrl==nil) {
        return @"";
    }
    if (dic==nil) {
        return svrUrl;
    }
    if ([dic count]==0) {
        return svrUrl;
    }
    NSString *url = svrUrl;
    for (int i = 0; i < [dic count]; i++) {
        NSString *key = [[dic allKeys] objectAtIndex:i];
        url = [NSString stringWithFormat:@"%@?%@=%@",url,key,[dic objectForKey:key]];
    }
    return url;
}

+ (NSString *) getCachePath
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 5.0)
    {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [documentPaths objectAtIndex:0];
        return documentsDirectoryPath;
    }
    else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if ([paths count]>0) {
            return [paths objectAtIndex:0];
        }
        return @"";
    }
}

+ (NSString *)getCurDateString
{
    NSDate *date = [NSDate date];
    NSCalendar *cal=[NSCalendar  currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *yearStr = [NSString stringWithFormat:@"%d",year];
    NSString *monthStr = [NSString stringWithFormat:@"%d",month];
    if (month<10) {
        monthStr = [NSString stringWithFormat:@"0%@",monthStr];
    }
    NSString *dayStr = [NSString stringWithFormat:@"%d",day];
    if (day<10) {
        dayStr = [NSString stringWithFormat:@"0%@",dayStr];
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@%@%@",yearStr,monthStr,dayStr];
    return dateStr;
}

//是否连接网络
+ (BOOL)isReachableUrl:(NSString *)url
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", url];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachable];
    }
}

//是否连接蜂窝网络
+ (BOOL) isReachableViaWWANUrl:(NSString *)url
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", url];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachableViaWWAN];
    }
}

//是否连接wifi
+ (BOOL)isReachableViaWiFiUrl:(NSString *)url
{
    if (TARGET_IPHONE_SIMULATOR)
    {
        return YES;
    }
    else
    {
        NSString *serverUrl = [NSString stringWithFormat:@"%@", url];
        NSURL *hostURL = [NSURL URLWithString:serverUrl];
        Reachability *hostReach = [Reachability reachabilityWithHostName:[hostURL host]];
        return [hostReach isReachableViaWiFi];
    }
}

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
    {
        return NO;
    }
    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if ((imageData == nil) || ([imageData length] <= 0))
        {
            return NO;
        }
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    return NO;
}

+ (void)setImageToView:(UIView *)v andImage:(UIImage *)img
{
    if ([v isKindOfClass:[UIImageView class]])
    {
        ((UIImageView *)v).image = img;
    }
    else if([v isKindOfClass:[UIButton class]])
    {
        [((UIButton *)v) setBackgroundImage:img forState:UIControlStateNormal];
        [((UIButton *)v) setBackgroundImage:img forState:UIControlStateHighlighted];
    }
}

+ (void)setImageWithURL:(NSString *)imageUrl andDelegate:(id)delegate toView:(UIView *)v
{
    if (imageUrl==nil) {
        [CMVideoUtil setImageToView:v andImage:nil];
        return;
    }
    NSString *cachePath = [CMVideoUtil getCachePath];
    cachePath = [NSString stringWithFormat:@"%@/cache/image",cachePath];
    NSString *fileName = [CMVideoUtil md5:imageUrl];
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@",cachePath,fileName.lowercaseString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:imgPath])
    {
        NSURL *URL = [NSURL URLWithString:imageUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (![fileManager fileExistsAtPath:imgPath])
             {
                 [CMVideoUtil writeImage:[UIImage imageWithData:data] toFileAtPath:imgPath];
             }
             [CMVideoUtil setImageToView:v andImage:[UIImage imageWithData:data]];
             if ([delegate respondsToSelector:@selector(setImgViewFinish:)])
             {
                 [delegate setImgViewFinish:self];
             }
         }];
    }
    else
    {
        [CMVideoUtil setImageToView:v andImage:[UIImage imageWithContentsOfFile:imgPath]];
        if ([delegate respondsToSelector:@selector(setImgViewFinish:)])
        {
            [delegate setImgViewFinish:self];
        }
    }
}

@end
