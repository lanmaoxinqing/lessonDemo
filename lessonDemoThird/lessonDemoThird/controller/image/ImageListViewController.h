//
//  ImageListViewController.h
//  lessonDemoThird
//
//  Created by sky on 14-6-29.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *imgList_;
    __weak IBOutlet UITableView *imageTableView;
    

}

@end
