//
//  BaseDao.m
//  lessonDemoForth
//
//  Created by sky on 14-7-4.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "BaseDao.h"
#import <objc/objc-runtime.h>
#import "NSObject+Property.h"

@implementation BaseDao

+(instancetype)sharedDao{
    static BaseDao *sharedDao=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDao=[self databaseWithPath:[BaseDao databaseFilePath]];
    });
    return sharedDao;
}

-(id)init{
    self=[self initWithPath:[BaseDao databaseFilePath]];
    if(self){
        
    }
    return self;
}

-(BOOL)createTableByClass:(Class)className{
    BOOL result;
    if([self open]){
        NSMutableString *sql=[NSMutableString stringWithFormat:@"CREATE TABLE %@(sid INTEGER PRIMARY KEY AUTOINCREMENT",NSStringFromClass(className)];
        NSInteger outCount=[className propertyNames].count;
        if(outCount>0){
            for(int i=0;i<outCount;i++){
                NSString *propertyName = [className propertyNames][i];
                if([propertyName isEqualToString:@"sid"]){
                    continue;
                }
                NSString *attribute=[className attributes][i];
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
        //建表
        result=[self executeUpdate:sql];
        //建索引
        if(result){
            NSString *indexSQL=[NSString stringWithFormat:@"CREATE UNIQUE INDEX INDEX_SID ON %@(SID)",NSStringFromClass(className)];
            result=[self executeUpdate:indexSQL];
        }else{
            NSLog(@"%@\n%@",sql,[[self lastError] description]);
            
        }
    }
    return result;
}

-(BOOL)executeSQL:(NSString *)sqlStr{
    if([self open]){
        return [self executeUpdate:sqlStr];
    }
    return NO;
}

-(BOOL)batchExecuteSQLs:(NSArray *)sqlArr{
    BOOL result=YES;
    NSInteger i=0;
    if([self open]){
        [self beginTransaction];
        for(NSString *sql in sqlArr){
            result=[self executeUpdate:sql];
            if(!result){
                NSLog(@"第%d条语句执行出错\n%@\n%@",i,[[self lastError] description],sql);
                break;
            }
            ++i;
        }
        if(result){
            [self commit];
        }else{
            [self rollback];
        }
    }else{
        result=NO;
    }
    return result;
}

-(BOOL)insert:(NSObject *)obj{
    BOOL result;
    if([self open]){
        NSMutableArray *params=[NSMutableArray new];
        NSMutableArray *values=[NSMutableArray new];
        NSMutableArray *placeholders=[NSMutableArray new];
        for(NSString *propertyName in [obj propertyNames]){
            id value=[obj valueForKey:propertyName];
            //主键为空,跳过主键
            if([propertyName isEqualToString:@"sid"] && (!value || [value intValue]==0)){
                continue;
            }
            if(value){
                [params addObject:propertyName];
                [values addObject:value];
                [placeholders addObject:@"?"];
            }
        }
        NSMutableString *sql=[NSMutableString stringWithFormat:@"REPLACE INTO %@ (%@) values (%@)",NSStringFromClass([obj class]),[params componentsJoinedByString:@","],[placeholders componentsJoinedByString:@","]];
        result=[self executeUpdate:sql withArgumentsInArray:values];
        if(!result){
            NSLog(@"%@\n%@",sql,[[self lastError] description]);
        }
    }
    return result;
}

-(BOOL)update:(NSObject *)obj{
    BOOL result;
    if([self open]){
        NSMutableArray *params=[NSMutableArray new];
        NSMutableArray *values=[NSMutableArray new];
        for(NSString *propertyName in [obj propertyNames]){
            //跳过主键
            if([propertyName isEqualToString:@"sid"]){
                continue;
            }
            id value=[obj valueForKey:propertyName];
            if(value){
                [params addObject:[NSString stringWithFormat:@"'%@'=?",propertyName]];
                [values addObject:value];
            }
        }
        [values addObject:[obj valueForKey:@"sid"]];
        NSMutableString *sql=[NSMutableString stringWithFormat:@"UPDATE %@ SET %@ where sid=?",NSStringFromClass([obj class]),[params componentsJoinedByString:@","]];
        result=[self executeUpdate:sql withArgumentsInArray:values];
        if(!result){
            NSLog(@"%@\n%@",sql,[[self lastError] description]);
        }
    }
    return result;

}

-(BOOL)insertOrUpdate:(NSObject *)obj{
    BOOL result;
    if([self open]){
        NSMutableArray *params=[NSMutableArray new];
        NSMutableArray *values=[NSMutableArray new];
        NSMutableArray *placeholders=[NSMutableArray new];
        for(NSString *propertyName in [obj propertyNames]){
            id value=[obj valueForKey:propertyName];
            if(value){
                [params addObject:propertyName];
                [values addObject:value];
                [placeholders addObject:@"?"];
            }
        }
        NSMutableString *sql=[NSMutableString stringWithFormat:@"REPLACE INTO %@ (%@) values (%@)",NSStringFromClass([obj class]),[params componentsJoinedByString:@","],[placeholders componentsJoinedByString:@","]];
        result=[self executeUpdate:sql withArgumentsInArray:values];
        if(!result){
            NSLog(@"%@\n%@",sql,[[self lastError] description]);
        }
    }
    return result;
}

-(BOOL)batchInsertOrUpdate:(NSArray *)objects{
    BOOL result=YES;
    if([self open]){
        NSInteger i=0;
        [self beginTransaction];
        for(NSString *obj in objects){
            NSMutableArray *params=[NSMutableArray new];
            NSMutableArray *values=[NSMutableArray new];
            NSMutableArray *placeholders=[NSMutableArray new];
            for(NSString *propertyName in [obj propertyNames]){
                id value=[obj valueForKey:propertyName];
                if(value){
                    [params addObject:propertyName];
                    [values addObject:value];
                    [placeholders addObject:@"?"];
                }
            }
            NSMutableString *sql=[NSMutableString stringWithFormat:@"REPLACE INTO %@ (%@) values (%@)",NSStringFromClass([obj class]),[params componentsJoinedByString:@","],[placeholders componentsJoinedByString:@","]];
            result=[self executeUpdate:sql withArgumentsInArray:values];
            if(!result){
                NSLog(@"第%d条语句执行出错\n%@\n%@",i,[[self lastError] description],sql);
                break;
            }
            ++i;
        }
        if(result){
            [self commit];
        }else{
            [self rollback];
        }
    }else{
        result=NO;
    }
    return result;
}

-(id)selectClass:(Class)className byId:(long)sid{
    NSString *sql=[NSString stringWithFormat:@"select * from %@ where sid=?",NSStringFromClass(className)];
    FMResultSet *result=[self executeQuery:sql,@(sid)];
    NSArray *results=[self generateObjects:className byResult:result];
    if(results && [results count]>0){
        return results[0];
    }
    return nil;
}

-(NSArray *)generateObjects:(Class)className byResult:(FMResultSet *)result{
    NSMutableArray *objs=[NSMutableArray new];
    NSInteger outCount=[className propertyNames].count;
    while ([result next]) {
        if(outCount>0){
            id obj=[[className alloc] init];
            for(int i=0;i<outCount;i++){
                NSString *propertyName = [className propertyNames][i];
                NSString *attribute=[className attributes][i];
                if([attribute isEqualToString:@"i"] && ![result columnIsNull:propertyName]){
                    [obj setValue:@([result intForColumn:propertyName]) forKey:propertyName];
                }else if([attribute isEqualToString:@"f"] && ![result columnIsNull:propertyName]){
                    [obj setValue:@([result doubleForColumn:propertyName]) forKey:propertyName];
                }if([attribute isEqualToString:@"d"] && ![result columnIsNull:propertyName]){
                    [obj setValue:@([result doubleForColumn:propertyName]) forKey:propertyName];
                }if([attribute isEqualToString:@"l"] && ![result columnIsNull:propertyName]){
                    [obj setValue:@([result longForColumn:propertyName]) forKey:propertyName];
                }if([attribute isEqualToString:@"q"] && ![result columnIsNull:propertyName]){
                    [obj setValue:@([result longLongIntForColumn:propertyName]) forKey:propertyName];
                }if([attribute isEqualToString:@"NSString"] && ![result columnIsNull:propertyName]){
                    [obj setValue:[result stringForColumn:propertyName] forKey:propertyName];
                }
            }
            [objs addObject:obj];
        }
    }
    [result close];
    return objs;
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
