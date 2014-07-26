//
//  ChatViewController.m
//  lessonDemoFifth
//
//  Created by sky on 14-7-26.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

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
    chats_=[NSMutableArray new];
    [super viewDidLoad];
    [self openUDPServer];
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
-(IBAction)didSendBtnClick:(id)sender{
    [self sendMassage:textField_.text];
}

#pragma mark - UITableView delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [chats_ count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatCell"];
    }
    cell.textLabel.text=chats_[indexPath.row];
    return cell;
}

#pragma mark -
//建立基于UDP的Socket连接
-(void)openUDPServer{
	//初始化udp
	AsyncUdpSocket *tempSocket=[[AsyncUdpSocket alloc] initWithDelegate:self];
	udpSocket_=tempSocket;
	//绑定端口
	NSError *error = nil;
	[udpSocket_ bindToPort:4333 error:&error];
    
    //发送广播设置
    [udpSocket_ enableBroadcast:YES error:&error];
    
    //加入群里，能接收到群里其他客户端的消息
    [udpSocket_ joinMulticastGroup:@"224.0.0.2" error:&error];
    
   	//启动接收线程
	[udpSocket_ receiveWithTimeout:-1 tag:0];
    
}

//通过UDP,发送消息
-(void)sendMassage:(NSString *)message
{
	NSMutableString *sendString=[NSMutableString stringWithCapacity:100];
	[sendString appendString:message];
	//开始发送
	BOOL res = [udpSocket_ sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding]
                             toHost:@"224.0.0.2"
                               port:4333
                        withTimeout:-1
                
                                tag:0];
   	if (!res) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"发送失败"
													   delegate:self
											  cancelButtonTitle:@"取消"
											  otherButtonTitles:nil];
		[alert show];
	}
//	[chats_ addObject:message];
//    [tableView_ reloadData];
}

#pragma mark UDP Delegate Methods
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    
    [udpSocket_ receiveWithTimeout:-1 tag:0];
	NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
	[chats_ addObject:info];
    [tableView_ reloadData];
	//已经处理完毕
	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法发送时,返回的异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:[error description]
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];
	
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法接收时，返回异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:[error description]
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];
}


@end
