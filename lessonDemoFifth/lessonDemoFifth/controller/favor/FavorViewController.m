//
//  FavorViewController.m
//  lessonDemoForth
//
//  Created by sky on 14-7-10.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "FavorViewController.h"
#import "NewsTableViewCell.h"
#import "NewsInfo.h"
#import "NewsInfoDao.h"
#import "NewsDetailViewController.h"

@interface FavorViewController ()

@end

@implementation FavorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Favor *info=favors_[indexPath.row];
    NewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell"];
    if(!cell){
        cell=(NewsTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil][0];
    }
    cell.titleLabel.text=info.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Favor *favor=favors_[indexPath.row];
    BaseDao *base=[BaseDao sharedDao];
    NewsInfo *info=[base selectClass:[NewsInfo class] byId:favor.objId];
    NewsDetailViewController *newsDetailVC=[[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    newsDetailVC.newsInfo=info;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return favors_?[favors_ count]:0;
}

-(void)reloadData{
    BaseDao *base=[BaseDao sharedDao];
    NSString *sql=@"select * from favor";
    FMResultSet *result=[base executeQuery:sql];
    favors_=[base generateObjects:[Favor class] byResult:result];
    [result close];
    [tableview_ reloadData];
}

@end
