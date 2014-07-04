//
//  ImageListViewController.m
//  lessonDemoThird
//
//  Created by sky on 14-6-29.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "ImageListViewController.h"
#import "ImageTableViewCell.h"
#import "Img.h"

@interface ImageListViewController ()

@end

@implementation ImageListViewController

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
    UINib *nib=[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil];
    [imageTableView registerNib:nib forCellReuseIdentifier:@"ImageTableViewCell"];
    
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
    [imageTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Img *img=imgList_[indexPath.section];
    ImageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell" forIndexPath:indexPath];
    
//    ImageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell"];
//    if(!cell){
//        cell=(ImageTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"ImageTableViewCell" owner:nil options:nil][0];
//    }
    
    cell.pics=img.pics;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return imgList_?imgList_.count:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"%d",section);
    Img *img=imgList_[section];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
    titleLabel.backgroundColor=[UIColor whiteColor];
    titleLabel.numberOfLines=0;
    titleLabel.text=img.title;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:titleLabel];
    return view;
}

@end
