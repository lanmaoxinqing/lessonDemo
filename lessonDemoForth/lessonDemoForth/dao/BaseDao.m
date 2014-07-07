//
//  BaseDao.m
//  lessonDemoForth
//
//  Created by sky on 14-7-4.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "BaseDao.h"
#import <objc/objc-runtime.h>

@implementation BaseDao

+(BaseDao *)sharedDao{
    static BaseDao *sharedDao=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDao=(BaseDao *)[self databaseWithPath:[BaseDao databaseFilePath]];
    });
    return sharedDao;
}

-(id)init{
    self=[self initWithPath:[BaseDao databaseFilePath]];
    if(self){
        
    }
    return self;
}

-(BOOL)createTable{
    NSAssert(nil, @"抽象方法,不允许直接调用,请子类实现该方法");
    return NO;
}

-(BOOL)executeSQL:(NSString *)sqlStr{
    if([self open]){
        return [self executeUpdate:sqlStr];
    }
    return NO;
}

-(BOOL)createTableByClass:(Class)className{
    if([self open]){
        NSMutableString *sql=[NSMutableString stringWithFormat:@"CREATE TABLE %@(sid INTEGER PRIMARY KEY AUTOINCREMENT",NSStringFromClass(className)];
        unsigned int outCount=0;
        objc_property_t * const properties=class_copyPropertyList(className, &outCount);
        if(outCount>0){
            for(int i=0;i<outCount;i++){
                NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
                NSString *propertyAttribute = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
                NSString *attribute=[propertyAttribute componentsSeparatedByString:@","][0];
                attribute=[attribute stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"T@\""]];
                NSLog(@"%@:%@",propertyName,attribute);
                if([attribute isEqualToString:@"i"]){
                    [sql appendFormat:@",%@ INTEGER",propertyName];
                }else if([attribute isEqualToString:@"f"]){
                    [sql appendFormat:@",%@ REAL",propertyName];
                }if([attribute isEqualToString:@"d"]){
                    [sql appendFormat:@",%@ REAL",propertyName];
                }if([attribute isEqualToString:@"l"]){
                    [sql appendFormat:@",%@ NUMERIC",propertyName];
                }if([attribute isEqualToString:@"q"]){
                    [sql appendFormat:@",%@ NUMERIC",propertyName];
                }if([attribute isEqualToString:@"NSString"]){
                    [sql appendFormat:@",%@ TEXT",propertyName];
                }
            }
        }
        [sql appendString:@")"];
        NSLog(@"%@",sql);
        return [self executeUpdate:sql];
    }
    return NO;
}

#pragma mark - 私有方法
+(NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:(NSString *)[Sysconfig bundleValueForKey:kBundleKeyDB]];
    return dbFilePath;
    
}

@end
