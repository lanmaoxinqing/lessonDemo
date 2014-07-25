//
//  NSObject+Property.h
//  lessonDemoForth
//
//  Created by sky on 14-7-7.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseDomainAttributeInt @"i"
#define kBaseDomainAttributeFloat @"f"
#define kBaseDomainAttributeDouble @"d"
#define kBaseDomainAttributeLong @"l"
#define kBaseDomainAttributeLongLong @"q"
#define kBaseDomainAttributeString @"NSString"

@interface NSObject (Property)

-(NSArray *)propertyNames;
-(NSArray *)attributes;
+(NSArray *)propertyNames;
+(NSArray *)attributes;


@end
