//
//  Sysconfig.h
//  lessonTest
//
//  Created by sky on 14-5-21.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBundleKeyDB @"database"

@interface Sysconfig : NSObject

+(NSObject *)bundleValueForKey:(NSString *)key;
+(NSString *)filePathByName:(NSString *)fileName;

@end
