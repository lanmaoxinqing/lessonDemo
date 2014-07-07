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

+(BaseDao *)sharedDao;

-(BOOL)executeSQL:(NSString *)sqlStr;

-(BOOL)createTableByClass:(Class)className;

@end
