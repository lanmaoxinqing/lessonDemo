//
//  BaseDao.h
//  lessonDemoForth
//
//  Created by sky on 14-7-4.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface BaseDao : FMDatabase

+(instancetype)sharedDao;

-(BOOL)createTableByClass:(Class)className;

-(BOOL)executeSQL:(NSString *)sqlStr;
-(BOOL)batchExecuteSQLs:(NSArray *)sqlArr;

-(BOOL)insert:(NSObject *)obj;
-(BOOL)update:(NSObject *)obj;
-(BOOL)insertOrUpdate:(NSObject *)obj;
-(BOOL)batchInsertOrUpdate:(NSArray *)objects;

-(NSArray *)generateObjects:(Class)className byResult:(FMResultSet *)result;

@end
