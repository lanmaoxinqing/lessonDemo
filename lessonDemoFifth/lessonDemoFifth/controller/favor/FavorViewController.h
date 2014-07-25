//
//  FavorViewController.h
//  lessonDemoForth
//
//  Created by sky on 14-7-10.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favor.h"

@interface FavorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tableview_;
    NSArray *favors_;
}

@end
