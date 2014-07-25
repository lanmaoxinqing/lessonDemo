//
//  FavorDao.m
//  lessonDemoForth
//
//  Created by sky on 14-7-10.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "FavorDao.h"

@implementation FavorDao

-(BOOL)isFavorExistsById:(long)objId type:(int)type{
    BaseDao *dao=[BaseDao sharedDao];
    NSString *sql=[NSString stringWithFormat:@"select * from favor where objid=? and type=?"];
    FMResultSet *result=[dao executeQuery:sql,@(objId),@(type)];
    BOOL hasNext=[result next];
    [result close];
    return hasNext;
}

@end
