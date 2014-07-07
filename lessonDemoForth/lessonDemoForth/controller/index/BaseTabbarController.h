//
//  BaseTabbarController.h
//  leziyou-iphone
//
//  Created by wangt on 12-3-12.
//  Copyright 2012年 teemax. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNotificationNameTabbarShow @"kNotificationNameTabbarShow"
#define kNotificationNameTabbarHidden @"kNotificationNameTabbarHidden"

@interface UIButton(Addons)

-(id)initWithTitle:(NSString *)title icon:(NSString *)icon;

@end

@interface BaseTabbarController : UITabBarController {
    BOOL  hide_;
    BOOL isHidden_;

}
@property(nonatomic,retain) UIImageView *bgView_;
@property(nonatomic,assign,readonly) NSInteger currentIndex;
@property(nonatomic,retain) UIImage *backgroundImage;//未被选中时的背景图
@property(nonatomic,retain) UIImage *selectedImage;//选中时的背景图片
@property(nonatomic,retain) UIImage *tabBarBackgroundImage;//tabBar的背景图片
@property(nonatomic,retain) NSMutableArray *tabBarBtnArray;
@property(nonatomic,assign) NSInteger height;

-(void)tabbarSelectAtIndex:(NSInteger)index;
-(void)tabbarHidden;
-(void)tabbarShow;
-(void)toggleTabbarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
