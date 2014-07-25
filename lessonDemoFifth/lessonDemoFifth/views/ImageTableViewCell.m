//
//  ImageTableViewCell.m
//  lessonDemoThird
//
//  Created by sky on 14-6-29.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "ImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"

@implementation ImageTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    UINib *nib=[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil];
    [collectionView_ registerNib:nib forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    collectionView_.dataSource=self;
    collectionView_.delegate=self;
    photos=[NSMutableArray new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *pic=_pics[indexPath.row];
    ImageCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:pic]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    ImageCollectionViewCell *cell=(ImageCollectionViewCell *)[collectionView_ cellForItemAtIndexPath:indexPath];
    MJPhotoBrowser *browser=[[MJPhotoBrowser alloc] init];
    browser.photos=photos;
    browser.currentPhotoIndex=indexPath.row;
    [browser show];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _pics?_pics.count:0;
}

-(void)setPics:(NSArray *)pics{
    _pics=pics;
    if(!photos){
        photos=[NSMutableArray new];
    }
    [photos removeAllObjects];
    for(NSString *pic in _pics){
        MJPhoto *photo=[[MJPhoto alloc] init];
        photo.url=[NSURL URLWithString:pic];
        photo.title=[NSString stringWithFormat:@"test%d",rand()];
        [photos addObject:photo];
    }
    [collectionView_ reloadData];
    
}

@end
