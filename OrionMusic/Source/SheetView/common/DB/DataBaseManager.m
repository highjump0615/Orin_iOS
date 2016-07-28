//
//  DataBaseManager.m
//  JiehuiBusiness
//
//  Created by zhu yangsheng on 13-3-21.
//  Copyright (c) 2013年 joyintech. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDatabase.h"

@implementation DataBaseManager

#pragma mark -
#pragma DB-related Methods

// Open the database connection and retrieve minimal information for all objects.
+(FMDatabase*)initializeDatabase:(NSString *) dbPath version:(NSString *)version
{
	NSLog(@"initializeDatabase %@", dbPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:dbPath];
    if (isExist)
    {
      NSLog(@"File Exist.");
    }

	FMDatabase* currentDB = [FMDatabase databaseWithPath:dbPath];
	if (![currentDB open]) {
		NSLog(@"Could not open db.");
        return nil;
	}else{
        return currentDB;
    }
}

+(void)bindAtomEntry:(NSString *)dbPath
{
    NSLog(@"bindAtomEntry");
    //设置数据库
    FMDatabase* db=[DataBaseManager initializeDatabase:dbPath version:@""];
	NSRecursiveLock *currentLock = [[NSRecursiveLock alloc] init];
	[DBOperator useDatabase:db];
	[DBOperator useLock:currentLock];
	[db setBusyRetryTimeout:50000];
    [currentLock release];
}

@end
