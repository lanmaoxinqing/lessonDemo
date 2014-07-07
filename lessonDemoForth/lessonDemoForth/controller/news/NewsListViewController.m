//
//  NewsListViewController.m
//  lessonDemoFirst
//
//  Created by sky on 14-6-3.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsInfo.h"
#import "NewsTableViewCell.h"
#import "NewsDetailViewController.h"

@interface NewsListViewController ()

@end

@implementation NewsListViewController

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
    news_=[NSMutableArray new];
    [super viewDidLoad];
    [self requestNewsInfos];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    news_=nil;
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate method
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsInfo *info=news_[indexPath.row];
    NewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell"];
    if(!cell){
        cell=(NewsTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil][0];
    }
    cell.titleLabel.text=info.title;
    cell.contentLabel.text=info.summary;
    //日期格式转换
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date=[formatter dateFromString:info.pubDate];
    NSDateFormatter *strFormatter=[NSDateFormatter new];
    [strFormatter setDateFormat:@"MM-dd HH:mm"];
    cell.dateLabel.text=[strFormatter stringFromDate:date];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsInfo *info=news_[indexPath.row];
    NSLog(@"id:%ld",info.newsId);
    NewsDetailViewController *newsDetailVC=[[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    newsDetailVC.newsInfo=info;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return news_?[news_ count]:0;
}


#pragma mark - 加载网络数据
-(void)requestNewsInfos{
    BaseService *base=[[BaseService alloc] init];
    //http://api.blbaidu.cn/API/News.ashx?pageSize=10&pageNo=2&cid=170
    base.url=@"http://api.blbaidu.cn/API/News.ashx?pageSize=10&pageNo=2&cid=170";
    [base requestWithCompletionHandler:^(NSString *responseStr, NSURLResponse *response, NSError *error) {
        NSDictionary *responseDic=[responseStr objectFromJSONString];
        if(responseDic){
            NSArray *results=[responseDic objectForKey:@"result"];
            if(results){
                [news_ removeAllObjects];
                for(NSDictionary *newsDic in results){
                    NewsInfo *newsInfo=[[NewsInfo alloc] initWithDictionary:newsDic];
                    [news_ addObject:newsInfo];
                }
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            }
        }
    }];
}

-(void)reload{
    [tableview_ reloadData];
}

@end
