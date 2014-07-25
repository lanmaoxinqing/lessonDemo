//
//  NewsInfoDao.m
//  lessonDemoForth
//
//  Created by sky on 14-7-7.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NewsInfoDao.h"

@implementation NewsInfoDao

-(NSArray *)selectNewsInfosbyType:(NSInteger)type AtPage:(NSInteger)page{
    BaseDao *baseDao=[BaseDao sharedDao];
    NSString *sql=[NSString stringWithFormat:@"select * from newsInfo where type=%d limit %d,%d",type,(page-1)*10,page*10];
    FMResultSet *result=[baseDao executeQuery:sql];
    return [baseDao generateObjects:[NewsInfo class] byResult:result];
};

@end
