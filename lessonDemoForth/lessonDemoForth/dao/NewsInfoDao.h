//
//  NewsInfoDao.h
//  lessonDemoForth
//
//  Created by sky on 14-7-7.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "BaseDao.h"

@interface NewsInfoDao : BaseDao

-(NSArray *)selectNewsInfosbyType:(NSInteger)type AtPage:(NSInteger)page;

@end
