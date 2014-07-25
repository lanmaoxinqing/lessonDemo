//
//  ContactListTableViewController.h
//  lessonDemoFifth
//
//  Created by sky on 14-7-22.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleInfo : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *phone;

@end

@interface ContactListTableViewController : UITableViewController{
    NSMutableArray *peoples;
}

@end
