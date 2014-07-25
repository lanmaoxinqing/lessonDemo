//
//  ListTableViewController.h
//  lessonDemoFifth
//
//  Created by sky on 14-7-20.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationService.h"

@interface ListTableViewController : UITableViewController{
    UINavigationController *nav_;
    UIBarButtonItem *backItem_;
    NSArray *datas_;
    LocationService *locationService_;
}

@end
