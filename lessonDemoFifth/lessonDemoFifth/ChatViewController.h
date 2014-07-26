//
//  ChatViewController.h
//  lessonDemoFifth
//
//  Created by sky on 14-7-26.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tableView_;
    IBOutlet UITextField *textField_;
    IBOutlet UIButton *sendBtn_;
    AsyncUdpSocket *udpSocket_;
    NSMutableArray *chats_;
}

@end
