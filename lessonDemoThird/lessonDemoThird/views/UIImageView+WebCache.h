//
//  UIImageView+WebCache.h
//  lessonTest
//
//  Created by sky on 14-5-20.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebCache)<NSURLConnectionDataDelegate>

-(void)setImageWithURL:(NSString *)url;
-(void)setImageWithURL:(NSString *)url finish:(void (^)(UIImage *image ,NSError *error))block;

@end
