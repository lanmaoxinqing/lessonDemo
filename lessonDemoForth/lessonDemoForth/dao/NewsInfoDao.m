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
    FMResultSet *result=[self executeQuery:@"select * from newsInfo where type=%d and rownum>%d and rownum<%d",type,(page-1)*10,page*10];
    while ([result next]) {
        <#statements#>
    }
};

@end
