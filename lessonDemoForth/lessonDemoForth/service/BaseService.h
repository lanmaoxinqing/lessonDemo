//
//  BaseService.h
//  lessonTest
//
//  Created by sky on 14-5-22.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 服务器通信基类,使用NSURLSession与服务器异步交互，并通过block返回结果
 自定义Service需继承该类
 属性对应api路径位置：
 http:url/action!method
 */
@interface BaseService : NSObject{
    NSMutableDictionary *params_;
}

@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *action;
@property(nonatomic,copy) NSString *method;
@property(nonatomic,strong) NSArray/*Param.key*/ *params;

-(void)addParam:(id)paramValue byKey:(NSString *)key;
-(void)requestWithCompletionHandler:(void (^)(NSString *responseStr, NSURLResponse *response, NSError *error))completionHandler;

-(void)uploadWithCompletionHandler:(void (^)(NSData *responseData, NSURLResponse *response, NSError *error))completionHandler;

-(void)test:(NSString *)filePath;

@end
