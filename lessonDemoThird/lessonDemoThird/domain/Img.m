//
//  Img.m
//  lessonDemoThird
//
//  Created by sky on 14-6-28.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "Img.h"

@implementation Img

-(void)setPicStr:(NSString *)picStr{
    _picStr=picStr;
    _pics=[_picStr componentsSeparatedByString:@","];
    _pics=[_pics arrayByAddingObject:@"http://api.blbaidu.cn/s632062.png"];

}

-(NSArray *)pics{
    if(!_pics && _picStr){
        _pics=[_picStr componentsSeparatedByString:@","];
        _pics=[_pics arrayByAddingObject:@"http://api.blbaidu.cn/s632062.png"];
    }
    return _pics;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self=[super init];
    if(self){
        self.sid=[[dic objectForKey:@"id"] longValue];
        self.title=[dic objectForKey:@"title"];
        self.picStr=[dic objectForKey:@"pics"];
    }
    return self;
}

@end
