//
//  NewsInfoService.h
//  lessonDemoForth
//
//  Created by sky on 14-7-9.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsInfo.h"
#import "NewsInfoDao.h"

@interface NewsInfoService : NSObject

+(void)requestNewsInfosByType:(NSInteger)type atPage:(NSInteger)page complete:(CompleteHandle)handle;

@end
