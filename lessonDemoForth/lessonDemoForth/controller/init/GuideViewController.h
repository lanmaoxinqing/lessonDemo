//
//  GuideViewController.h
//  lessonTest
//
//  Created by sky on 14-5-22.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIScrollView *scrollView_;
    IBOutlet UIPageControl *pageControl_;
}

@end
