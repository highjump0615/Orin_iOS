//
//  DBOperator.h
//  JiehuiBusiness
//
//  Created by zhu yangsheng on 13-4-1.
//  Copyright (c) 2013年 joyintech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "FMDatabase.h"

@interface DBOperator : NSObject
{
    int pk;
    
}

@property (nonatomic, assign) int pk;


/***********************************
 Class functions
 ***********************************/
+ (void)initializeDatabase:(NSString *) dbName FMDB:(FMDatabase *)db;

+ (void)useLock:(NSRecursiveLock *)lockToUse;
+ (void)useDatabase:(FMDatabase *)databaseToUse;

+ (NSMutableArray *)selectAllInfo:(NSString *)sql;
+ (int)selectRecodeCount:(NSString *)sql;
+ (BOOL)dbexecuteQuery:(NSString *)sql;
+ (BOOL)closeDb;

+ (BOOL)BeginS;
+ (BOOL)CommitS;
+ (NSString *)getInsertSqlFromDic:(NSMutableDictionary *)dic andTableName:(NSString *)tableName;
+ (NSString *)getUpdateSqlFromDic:(NSMutableDictionary *)dic andTableName:(NSString *)tableName andMainKey:(NSDictionary *)main;
@end
