//
//  Img.h
//  lessonDemoThird
//
//  Created by sky on 14-6-28.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Img : NSObject

@property(nonatomic,assign) long sid;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *picStr;
@property(nonatomic,strong) NSArray *pics;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
