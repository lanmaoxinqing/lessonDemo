//
//  GuideViewController.m
//  lessonTest
//
//  Created by sky on 14-5-22.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "GuideViewController.h"
#import "BaseService.h"
#import "UIImageView+WebCache.h"
#import "TopNavViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GuideViewController ()

@end

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestImages];
}

-(void)dealloc{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl_.currentPage=scrollView_.contentOffset.x/scrollView_.frame.size.width;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%f",(pageControl_.numberOfPages+1/10.0)*scrollView.frame.size.width);
    if(scrollView.contentOffset.x>(pageControl_.numberOfPages-1+1/5.0)*scrollView.frame.size.width){
        [UIView animateWithDuration:.5 animations:^{
            self.view.alpha=0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}

#pragma mark - 
-(void)requestImages{
    [self reloadImages:@[@"0.png",@"0.png",@"0.png"]];
}

-(void)reloadImages:(NSArray *)imagePaths{
    for(id subview in scrollView_.subviews){
        [subview removeFromSuperview];
    }
    pageControl_.numberOfPages=imagePaths.count;
    scrollView_.contentSize=CGSizeMake(scrollView_.frame.size.width*[imagePaths count], scrollView_.frame.size.height);
    for(int i=0;i<[imagePaths count];i++){
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:scrollView_.frame];
        imageView.center=CGPointMake(scrollView_.center.x+scrollView_.frame.size.width*i, scrollView_.center.y);
        [scrollView_ addSubview:imageView];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:imagePaths[i]]];
    }
}

@end
