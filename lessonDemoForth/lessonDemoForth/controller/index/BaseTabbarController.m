//
//  BaseTabbarController.m
//  leziyou-iphone
//
//  Created by wangt on 12-3-12.
//  Copyright 2012年 teemax. All rights reserved.
//

#import "BaseTabbarController.h"
#define kTabbarHeight  50
#define  kDefaultTag 22222

@implementation UIButton(Addons)

-(id)initWithTitle:(NSString *)title icon:(NSString *)icon{
    self=[super init];
    if(self){
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        UIImage *image=[UIImage imageNamed:icon];
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

@end

@interface BaseTabbarController(Private)
-(void)hiddenSysTabBar;
-(void)addCustomTabBarElements;
-(void)buttonClick:(id)sender;
@end

@implementation BaseTabbarController
@synthesize bgView_;

#pragma mark - View lifecycle
-(id)init{
    self=[super init];
    if(self){
        _height=kTabbarHeight;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!hide_) {
          [self addCustomTabBarElements];
          hide_ =YES;
  }
  
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hiddenSysTabBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarShow) name:kNotificationNameTabbarShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarHidden) name:kNotificationNameTabbarHidden object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    hide_=NO;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - getter & setter

-(void)setSelectedImage:(UIImage *)selectedImage{
    _selectedImage = selectedImage;
    if (_tabBarBtnArray !=nil &&[_tabBarBtnArray count]>0) {
        for (UIButton *bt in _tabBarBtnArray) {
            [bt setBackgroundImage:_selectedImage forState:UIControlStateHighlighted];
            [bt setBackgroundImage:_selectedImage forState:UIControlStateSelected];
        }
    }else{
         NSLog(@"warning:no buttons in this controller,make sure 'selectedImage' property is called after button added");
    }
}
-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage=backgroundImage;
    if(_tabBarBtnArray!=nil && [_tabBarBtnArray count]>0){
        for(UIButton *bt in _tabBarBtnArray){
            [bt setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        }
    }else{
        NSLog(@"warning:no buttons in this controller,make sure 'backgroundImage' property is called after button added");
    }

}
-(void)setTabBarBtnArray:(NSMutableArray *)tabBarBtnArray{
     _tabBarBtnArray=[[NSMutableArray alloc] initWithArray:tabBarBtnArray];
}

#pragma mark -

-(void)hiddenSysTabBar{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITabBar class]]){
            view.hidden =YES;
            break;
        }
    }
}

-(void)addCustomTabBarElements{
    CGRect  rect =[[UIScreen mainScreen]bounds];
    float height = rect.size.height;
    float width = rect.size.width;
    bgView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, height -  _height, width, _height)];
    bgView_.image = _tabBarBackgroundImage;
    bgView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [self.view addSubview:bgView_]; 

    if (_tabBarBtnArray!=nil && [_tabBarBtnArray count]>0) {
        NSInteger count = [_tabBarBtnArray count];
        for (int i = 0;i<count;i++){
            UIButton *btn = [_tabBarBtnArray objectAtIndex:i];
            [btn setFrame:CGRectMake( i*width/count,height -_height  , width/count, _height)];
            btn.contentMode=UIViewContentModeScaleAspectFit;
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            float imgHeight=btn.imageView.frame.size.height;
            float imgWidth=btn.imageView.frame.size.width;
            float titleHeight=btn.titleLabel.frame.size.height;
            float titleWidth=btn.titleLabel.frame.size.width;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-titleHeight,0,0,-titleWidth)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, -imgHeight, 0)];
            [btn setTag:i+kDefaultTag];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            
        }
    }
}

-(void)tabbarShow{
    [bgView_ setHidden:NO];
    for (int i = 0;i<[_tabBarBtnArray count]; i++) {
        UIButton *button  = (UIButton *)[self.view viewWithTag:i+kDefaultTag];
        [button setHidden:NO];
        if (i==_currentIndex){
            [button setSelected:YES];
        }
    }
}
-(void)tabbarHidden{
//    hide = YES;
    [bgView_ setHidden:YES];
    for (int i = 0;i<[_tabBarBtnArray count]; i++) {
        UIButton *button  = (UIButton *)[self.view viewWithTag:i+kDefaultTag];
        [button setHidden:YES];
    }
}
-(void)buttonClick:(id)sender{
    NSInteger tagNum = [sender tag]-kDefaultTag;
    _currentIndex = tagNum;
    [self tabbarSelectAtIndex:tagNum];
}
-(void)tabbarSelectAtIndex:(NSInteger)index{
    NSLog(@"%@",[[self.viewControllers objectAtIndex:index] class]);
    if(self.selectedIndex==index){
        UIViewController *vc=self.viewControllers[index];
        if([vc isKindOfClass:[UINavigationController class]]){
            [(UINavigationController *)vc popToRootViewControllerAnimated:YES];
        }
        else if(vc.navigationController){
            [vc.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        if (_tabBarBtnArray!=nil &&[_tabBarBtnArray count]>0) {
            for (UIButton *bt  in _tabBarBtnArray) {
                bt.selected = (bt.tag ==index+kDefaultTag)?YES:NO;
            }
        }
        [self setSelectedIndex:index];
    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)toggleTabbarHidden:(BOOL)hidden animated:(BOOL)animated{
    if(hidden!=isHidden_){//传入状态与当前状态不同
        isHidden_=hidden;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        UITabBar *sysTabbar;
        UIView *contentView;
        for (UIView *view in self.view.subviews) {
            if([view isKindOfClass:[UITabBar class]]){
                sysTabbar=(UITabBar *)view;
                break;
            }else if(![view isKindOfClass:[UIImageView class]]){
                contentView=view;
            }
        }
        if(hidden){
            sysTabbar.frame=CGRectMake(0, self.view.frame.size.height, sysTabbar.frame.size.width, sysTabbar.frame.size.height);
            bgView_.frame=CGRectMake(0, self.view.frame.size.height, bgView_.frame.size.width, bgView_.frame.size.height);
            contentView.frame=CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height+_height);
        }else{
            sysTabbar.frame=CGRectMake(0, self.view.frame.size.height-_height, sysTabbar.frame.size.width, sysTabbar.frame.size.height);
            bgView_.frame=CGRectMake(0, self.view.frame.size.height-_height, bgView_.frame.size.width, bgView_.frame.size.height);
            contentView.frame=CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height-_height);
        }
    }
    
    
    [UIView commitAnimations];
}

@end
