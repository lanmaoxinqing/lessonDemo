//
//  AnnouncementListViewController.h
//  lessonDemoSecond
//
//  Created by sky on 14-6-10.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface AnnouncementListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    __weak IBOutlet UITableView *tableView_;
    NSInteger currentPage_;
    NSMutableArray *announcements_;
    
    MJRefreshBaseView *refreshView_;
}

@end
