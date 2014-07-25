//
//  ImageTableViewCell.h
//  lessonDemoThird
//
//  Created by sky on 14-6-29.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ImageTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>{
    IBOutlet UICollectionView *collectionView_;
    NSMutableArray *photos;
}

@property(nonatomic,strong) NSArray *pics;

@end
