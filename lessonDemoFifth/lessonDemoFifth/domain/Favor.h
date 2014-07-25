//
//  Favor.h
//  lessonDemoForth
//
//  Created by sky on 14-7-10.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Favor : NSObject

@property(nonatomic,assign) long sid;   //主键
@property(nonatomic,assign) long objId; //收藏对象主键
@property(nonatomic,assign) int type;   //收藏类型
@property(nonatomic,copy) NSString *title;//标题
@property(nonatomic,copy) NSString *intro;//简介

@end
