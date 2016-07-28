//
//  CMUtils.h
//  
//
//  Created by zhu yangsheng on 13-6-4.
//
//

#import <Foundation/Foundation.h>

@interface CMUtils : NSObject

+ (NSString *)md5:(NSString *)str;

+ (NSString *)getCachePath:(NSString *)url;

+ (NSString *)getDataBasePath:(NSString *)dbName;

+ (NSString *)dateToString:(NSDate *)date;

+ (NSDate *)dateByString:(NSString *)dateStr;

+ (NSString *)trimString:(NSString *)url;

+ (BOOL)stringIsEmpty:(NSString *)str;

//+ (NSString*)stringWithUUID;
@end
