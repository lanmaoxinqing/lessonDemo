//
//  ImageListViewController.m
//  lessonDemoThird
//
//  Created by sky on 14-6-28.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "Img.h"
#import "ImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ImageListHeaderView.h"

@interface ImageCollectionViewController ()

@end

@implementation ImageCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    imgList_=[NSMutableArray new];
    [super viewDidLoad];
    UINib *nib=[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil];
    [collectionView_ registerNib:nib forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    UINib *headNib=[UINib nibWithNibName:@"ImageListHeaderView" bundle:nil];
    [collectionView_ registerNib:headNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ImageListHeaderView"];
    
    BaseService *base=[[BaseService alloc] init];
    base.url=@"http://api.blbaidu.cn/API/Pic.ashx?pageSize=5";
    [base requestWithCompletionHandler:^(NSString *responseStr, NSURLResponse *response, NSError *error) {
        NSDictionary *responseDic=[responseStr objectFromJSONString];
        NSArray *arr=[responseDic objectForKey:@"result"];
        for(NSDictionary *picDic in arr){
            Img *img=[[Img alloc] initWithDictionary:picDic];
            [imgList_ addObject:img];
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    [collectionView_ reloadData];
}

#pragma mark - 
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Img *img=imgList_[indexPath.section];
    NSString *pic=img.pics[indexPath.row];
    ImageCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:pic]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    Img *img=imgList_[section];
    return img.pics?[img.pics count]:0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return imgList_?[imgList_ count]:0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        Img *img=imgList_[indexPath.section];
        ImageListHeaderView *headerView=[collectionView_ dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ImageListHeaderView" forIndexPath:indexPath];
        headerView.titleLabel.text=img.title;
        return headerView;
    }
    return nil;
}

@end
