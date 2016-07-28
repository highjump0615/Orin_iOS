//
//  DBOperator.m
//  JiehuiBusiness
//
//  Created by zhu yangsheng on 13-4-1.
//  Copyright (c) 2013年 joyintech. All rights reserved.
//

#import "DBOperator.h"


static FMDatabase *db = nil;
static NSRecursiveLock *lock = nil;

@implementation DBOperator

@synthesize pk;


-(id)init{
	if((self = [super init]) != nil){
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

/***********************************
 Class functions
 ***********************************/
#pragma mark -
+ (void)useDatabase:(FMDatabase *)databaseToUse
{
	db = [databaseToUse retain];
	//[db setLogsErrors:YES];
}

+ (void)useLock:(NSRecursiveLock *)lockToUse
{
	lock = [lockToUse retain];
}

#pragma mark DB-related Methods

+ (NSMutableArray *)selectAllInfo:(NSString *)sql
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    [lock lock];
    NSLog(@"%@",sql);
	FMResultSet *rs = [db executeQuery:sql,nil];
	while ([rs next])
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (int i = 0; i<[rs columnCount]; i++)
          {
            NSString *colName = [rs columnNameForIndex:i];
            NSObject *obj = [rs objectForColumnName:colName];
            if (![obj isKindOfClass:[NSNull class]])
              {
                [dic setObject:[NSString stringWithFormat:@"%@",obj] forKey:colName];
            }
          }
        [array addObject:dic];
        [dic release];
    }
	[rs close];
	[lock unlock];
	return array;
}

+ (int)selectRecodeCount:(NSString *)sql
{
    [lock lock];
    NSLog(@"%@",sql);
    int count = 0;
	FMResultSet *rs = [db executeQuery:sql,nil];
    if ([rs next])
    {
      count = [rs intForColumnIndex:0];
    }
	[rs close];
	[lock unlock];
    return count;
}

+ (BOOL)dbexecuteQuery:(NSString *)sql
{
	BOOL success;
	[lock lock];
    success = [db executeUpdate:sql,nil];
	[lock unlock];
	return success;
}

+ (BOOL)closeDb
{
    return [db close];
}

+(BOOL)BeginS{
    return [db beginTransaction];
}
+ (BOOL)CommitS{
    return [db commit];
}
+ (NSString *)getInsertSqlFromDic:(NSMutableDictionary *)dic andTableName:(NSString *)tableName
{
    NSString *sql = @"";
    if (dic!=nil)
      {
        NSArray *ar = [dic allKeys];
        if ([ar count]==0) {
            return sql;
        }
        sql = [NSString stringWithFormat:@"insert into %@",tableName];
        NSString *keys = @"(";
        NSString *values = @"(";
        for (int i = 0; i < [ar count];i++)
          {
            NSString *key = (NSString *)[ar objectAtIndex:i];
            NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
            if (i!=[ar count]-1) {
                keys = [NSString stringWithFormat:@"%@%@,",keys,key];
                values = [NSString stringWithFormat:@"%@'%@',",values,value];
            }
            else {
                keys = [NSString stringWithFormat:@"%@%@)",keys,key];
                values = [NSString stringWithFormat:@"%@'%@')",values,value];
            }
          }
        sql = [NSString stringWithFormat:@"%@ %@ values%@",sql,keys,values];
      }
    return sql;
}

+ (NSString *)getUpdateSqlFromDic:(NSMutableDictionary *)dic andTableName:(NSString *)tableName andMainKey:(NSDictionary *)main
{
    NSString *sql = @"";
    if (dic!=nil)
      {
        NSArray *ar = [dic allKeys];
        if ([ar count]==0) {
            return sql;
        }
        sql = [NSString stringWithFormat:@"update %@ ",tableName];
        NSString *keys = @"set ";
        for (int i = 0; i < [ar count];i++)
          {
            NSString *key = (NSString *)[ar objectAtIndex:i];
            NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
            if (i!=[ar count]-1) {
                keys = [NSString stringWithFormat:@"%@%@ = '%@',",keys,key,value];
            }
            else
              {
                keys = [NSString stringWithFormat:@"%@%@ = '%@' ",keys,key,value];
              }
          }
        sql = [NSString stringWithFormat:@"%@%@",sql,keys];
        NSArray *ar1 = [main allKeys];
        NSString *key1 = (NSString *)[ar1 objectAtIndex:0];
        NSString *v1 = [NSString stringWithFormat:@"%@",[main objectForKey:key1]];
        sql = [NSString stringWithFormat:@"%@ where %@='%@'",sql,key1,v1];
      }
    return sql;
}

@end
