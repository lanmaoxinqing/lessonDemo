//
//  NewsTableViewCell.h
//  lessonDemoFirst
//
//  Created by sky on 14-6-4.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property(nonatomic,assign) IBOutlet UILabel *titleLabel;
@property(nonatomic,assign) IBOutlet UILabel *contentLabel;
@property(nonatomic,assign) IBOutlet UILabel *dateLabel;
@property(nonatomic,assign) IBOutlet UIImageView *thumbImageView;

@end
