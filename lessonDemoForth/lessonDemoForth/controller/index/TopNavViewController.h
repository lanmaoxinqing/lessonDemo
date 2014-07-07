//
//  TopNavViewController.h
//  lessonDemoSecond
//
//  Created by sky on 14-6-14.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopNavViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIScrollView *titleScrollView_;
    IBOutlet UIScrollView *contentScrollView_;
    UIView *titleSelectBg_;

}

@end
