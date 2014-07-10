//
//  FavorDao.h
//  lessonDemoForth
//
//  Created by sky on 14-7-10.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavorDao : NSObject

-(BOOL)isFavorExistsById:(long)objId type:(int)type;

@end
