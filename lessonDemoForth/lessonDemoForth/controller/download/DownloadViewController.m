//
//  DownloadViewController.m
//  lessonDemoForth
//
//  Created by sky on 14-7-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadCell.h"
#import "DownloadManager.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

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
    [super viewDidLoad];
    resources_=@[@"http://122.227.237.39/youku/677571A4F9A4E84658E7E5385F/030008100050F99D78E71E05CF07DD89F6E8F6-0EBA-D115-B5C5-2153AF096313.mp4",@"http://180.96.38.44/youku/69782A76F243A816BBF6B83A68/030008100150F99D78E71E05CF07DD89F6E8F6-0EBA-D115-B5C5-2153AF096313.mp4",@"http://58.211.22.207/youku/697912BC7954183642DAF649F5/030008100250F99D78E71E05CF07DD89F6E8F6-0EBA-D115-B5C5-2153AF096313.mp4"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlStr=resources_[indexPath.row];
    DownloadCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DownloadCell"];
    if(!cell){
        cell=[[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:nil options:nil][0];
    }
    cell.downloadUrl=urlStr;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resources_.count;
}

@end
