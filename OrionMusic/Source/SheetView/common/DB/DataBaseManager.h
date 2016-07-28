//
//  DataBaseManager.h
//  JiehuiBusiness
//
//  Created by zhu yangsheng on 13-3-21.
//  Copyright (c) 2013年 joyintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBOperator.h"
@class FMDatabase;

@interface DataBaseManager : NSObject

+(FMDatabase*)initializeDatabase:(NSString *) dbPath version:(NSString *)version;

+(void)bindAtomEntry:(NSString *)dbPath;

@end
