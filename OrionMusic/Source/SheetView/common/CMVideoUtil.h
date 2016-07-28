//
//  CMVideoUtil.h
//  IPadCMVideoCS
//
//  Created by root on 11-3-14.
//  Copyright 2011 上海网达软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"

#import <commoncrypto/CommonDigest.h>
#define SERVER_DOMAINMAP @"http://www.cad.com.cn/app/?app=daily&controller=rss&action=dailyiphone"

@interface CMVideoUtil : NSObject {

}

+ (BOOL)verifyChinaMobile:(NSString*)userNum;
+ (void)setImageToObject:(NSDictionary *)img;
+ (UIColor *)setTextFontColor;
+ (UIColor*)getYFontColor;
+ (UIColor *)setBgColor;
//rgb:235 89 197
+ (UIColor *)fontColorRedWith197;
//rgb:140 67 125
+ (UIColor *)fontColorRedWith125;
//rgb:65 103 151
+ (UIColor *)fontColorBlueWith151;
//rgb:165 188  216
+ (UIColor *)fontColorBlueWith216;
//rgb:136 136 136
+ (UIColor *)fontColorGrayWith136;
//rgb:160 161 178
+ (UIColor *)fontColorGrayWith178;

//add by tsh 2011-10-8
//rgb:122 156 199
+ (UIColor *)colorDay;
//rgb:32 30 38
+ (UIColor *)colorNight;
//end

+ (BOOL) isLogin;

//返回值：nsdata
+ (NSData *)getDataFromDataSource:(id)rootObject;
//nsdata 转字典
+ (id)tranferDataFromData:(NSData *)data;
+ (NSString*)timeToMString:(float)time;
+ (NSString*)timeToStringWithFormat:(float)time;


+(NSMutableArray  *)arrDistinct:(NSMutableArray  *)arr;
+(void)vMergeSort:(NSMutableArray *)arr type:(NSString *)type;
+(void)vMerge_Sort:(NSMutableArray *)arr left:(int)left right:(int)right type:(NSString *)type;
+(void)vMerge:(NSMutableArray *)arr left:(int)left center:(int)center right:(int)right type:(NSString *)type;

+ (NSMutableDictionary*) parserJson: (NSString*) jsondata error: (NSError*) error;
+ (NSString*) jsonToString:(id)json error: (NSError*) error;
// 年月日获得 yyyyMMdd
+ (NSString*)getDateNow;
//是否连接网络
+ (BOOL)isReachable;
//是否连接蜂窝网络
+ (BOOL) isReachableViaWWAN;
//是否连接wifi
+ (BOOL)isReachableViaWiFi;

//是否连接网络
+ (BOOL)isReachableMap;
//是否连接蜂窝网络
+ (BOOL) isReachableViaWWANMap;
//是否连接wifi
+ (BOOL)isReachableViaWiFiMap;

//yyyyMMdd
+ (NSDate *)stringToDate:(NSString *)string;
//yyyyMMddHHmmss
+ (NSString*)dateToString:(NSDate*)date;

+ (UIImage*)imagePNGWithName:(NSString *)imageName;
+ (UIImage*)imageJPGWithName:(NSString *)imageName;

+(BOOL) isImageUrl:(NSString *)url;

// 描述：把字符串转换成URL编码
// 参数：urlStr[in] 字符串
// 返回值：对应的URL数据，如果urlStr为nil则返回nil
+ (NSURL*)stringToURL: (NSString*)urlStr;

+ (NSString*)getAppVersion;//发布版本号
+ (NSString*)getAppPublishDate;//发布时间
//+ (NSString *)getUUID;

+ (NSString*)getMachineICCID;//获取机器码

+ (NSString *)md5:(NSString *)str;

//use for location history
+ (BOOL)LessThan5FromDB: (NSString *) theDate; 

//16进制颜色值转换
+ (UIColor *)colorFromCode:(int)hexCode;
+ (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSString *) getDataStoragePath;
+ (NSString *)getHttpUrlFromDic:(NSDictionary *)dic svrUrl:(NSString *)svrUrl;
+ (NSString *) getCachePath;
+ (NSString *)getCurDateString;

//是否连接网络
+ (BOOL)isReachableUrl:(NSString *)url;
//是否连接蜂窝网络
+ (BOOL) isReachableViaWWANUrl:(NSString *)url;
//是否连接wifi
+ (BOOL)isReachableViaWiFiUrl:(NSString *)url;
+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
+ (void)setImageWithURL:(NSString *)imageUrl andDelegate:(id)delegate toView:(UIView *)v;

@end
