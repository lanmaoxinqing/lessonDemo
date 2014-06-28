//
//  NewsInfo.m
//  lessonDemoFirst
//
//  Created by sky on 14-6-4.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NewsInfo.h"

@implementation NewsInfo

-(id)initWithDictionary:(NSDictionary *)dic{
    self=[super init];
    if(self && dic){
        _newsId=[[dic objectForKey:@"id"] longValue];
        _pic=[dic objectForKey:@"pic"];
        _pubDate=[dic objectForKey:@"pubDate"];
        _source=[dic objectForKey:@"source"];
        _summary=[dic objectForKey:@"summary"];
        _author=[dic objectForKey:@"author"];
        _title=[dic objectForKey:@"title"];
    }
    return self;
}

@end
