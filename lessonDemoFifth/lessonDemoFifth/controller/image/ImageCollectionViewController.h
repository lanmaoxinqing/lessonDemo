//
//  ImageListViewController.h
//  lessonDemoThird
//
//  Created by sky on 14-6-28.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *imgList_;
    IBOutlet UICollectionView *collectionView_;
}

@end
