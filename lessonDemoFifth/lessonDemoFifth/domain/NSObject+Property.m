//
//  NSObject+Property.m
//  lessonDemoForth
//
//  Created by sky on 14-7-7.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

NSMutableDictionary *propertyNameDic;
NSMutableDictionary *attributeDic;
NSMutableArray *propertyNames;
NSMutableArray *attributes;

@implementation NSObject (Property)

-(NSArray *)propertyNames{
    propertyNames=[propertyNameDic objectForKey:NSStringFromClass([self class])];
    if(!propertyNames){
        [[self class] getProperties];
    }
    return propertyNames;
}

-(NSArray *)attributes{
    attributes=[attributeDic objectForKey:NSStringFromClass([self class])];
    if(!attributes){
        [[self class] getProperties];
    }
    return attributes;
}

+(NSArray *)propertyNames{
    propertyNames=[propertyNameDic objectForKey:NSStringFromClass([self class])];
    if(!propertyNames){
        [self getProperties];
    }
    return propertyNames;
}

+(NSArray *)attributes{
    attributes=[attributeDic objectForKey:NSStringFromClass([self class])];
    if(!attributes){
        [self getProperties];
    }
    return attributes;
}

-(void)getProperties{
    if(!propertyNameDic){
        propertyNameDic=[NSMutableDictionary new];
    }
    if(!attributeDic){
        attributeDic=[NSMutableDictionary new];
    }
    propertyNames=[NSMutableArray new];
    attributes=[NSMutableArray new];
    unsigned int outCount=0;
    objc_property_t * const properties=class_copyPropertyList([self class], &outCount);
    if(outCount>0){
        for(int i=0;i<outCount;i++){
            NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            NSString *propertyAttribute = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
            NSString *attribute=[propertyAttribute componentsSeparatedByString:@","][0];
            attribute=[attribute stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"T@\""]];
            [propertyNames addObject:propertyName];
            [attributes addObject:attribute];
        }
        [propertyNameDic setObject:propertyNames forKey:NSStringFromClass([self class])];
        [attributeDic setObject:attributes forKey:NSStringFromClass([self class])];
    }
}

@end
