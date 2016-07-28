//
//  CMUtils.m
//  CADdaily
//
//  Created by zhu yangsheng on 13-6-4.
//
//

#import "CMUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CMUtils
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

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateByString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

+ (NSString *)trimString:(NSString *)url
{
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    url = [url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return url;
}

+ (BOOL)stringIsEmpty:(NSString *)str
{
    return str == nil
    || str == NULL
    ||([str respondsToSelector:@selector(length)]
       && [(NSData *)str length] == 0)
    || ([str respondsToSelector:@selector(count)]
        && [(NSArray *)str count] == 0);
}

//+ (NSString*)stringWithUUID
//{
//    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
//    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
//    CFRelease(uuidObj);
//    return [uuidString autorelease];
//}

+ (NSString *)getCachePath:(NSString *)url
{
    NSError* error;
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/%@", path, [CMUtils md5:url]];
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
      {
        NSLog(@"create dir error: %@",error.debugDescription);
      }
    return path;
}

+ (NSString *)getDataBasePath:(NSString *)dbName
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docPath=[Paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/dbData/data/%@.sqlite", docPath,dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path])
      {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/dbData/data", docPath] withIntermediateDirectories:YES attributes:nil error:nil];
            NSString *dbPath = [[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"];
            [fileManager copyItemAtPath:dbPath toPath:path error:nil];
      }
    return path;
}

@end
