//
//  ListViewController.h
//  lessonDemoFirst
//
//  Created by sky on 14-6-3.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *news_;
    IBOutlet UITableView *tableview_;
    
}

@end
