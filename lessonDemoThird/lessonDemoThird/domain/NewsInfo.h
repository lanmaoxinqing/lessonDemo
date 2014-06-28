//
//  NewsInfo.h
//  lessonDemoFirst
//
//  Created by sky on 14-6-4.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject

@property(nonatomic,assign) long newsId;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *pic;
@property(nonatomic,copy) NSString *pubDate;
@property(nonatomic,copy) NSString *source;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) NSString *description;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
