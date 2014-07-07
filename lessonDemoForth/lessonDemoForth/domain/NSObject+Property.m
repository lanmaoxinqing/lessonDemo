//
//  NSObject+Property.m
//  lessonDemoForth
//
//  Created by sky on 14-7-7.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

static NSMutableArray *propertyNames;
static NSMutableArray *attributes;

@implementation NSObject (Property)

-(NSArray *)propertyNames{
    if(!propertyNames){
        [[self class] getProperties];
    }
    return propertyNames;
}

-(NSArray *)attributes{
    if(!attributes){
        [[self class] getProperties];
    }
    return attributes;
}

+(NSArray *)propertyNames{
    if(!propertyNames){
        [self getProperties];
    }
    return propertyNames;
}

+(NSArray *)attributes{
    if(!attributes){
        [self getProperties];
    }
    return attributes;
}

+(void)getProperties{
    if(!propertyNames){
        propertyNames=[NSMutableArray new];
    }
    if(!attributes){
        attributes=[NSMutableArray new];
    }
    [propertyNames removeAllObjects];
    [attributes removeAllObjects];
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
    }
    
}

@end
