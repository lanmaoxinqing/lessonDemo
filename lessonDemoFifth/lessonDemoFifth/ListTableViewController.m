//
//  ListTableViewController.m
//  lessonDemoFifth
//
//  Created by sky on 14-7-20.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "ListTableViewController.h"
#import "ContactListTableViewController.h"
#import "MapViewController.h"
#import "ZBarSDK.h"
#import "ChatViewController.h"

#define kNameNotification   @"消息推送"
#define kNameContact        @"通讯录"
#define kNameLocation       @"GPS定位"
#define kNameMap            @"地图"
#define kNameCode           @"二维码"
#define kNameChat           @"信息通讯"


@interface ListTableViewController ()

@end

@implementation ListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    nav_=[[UINavigationController alloc] init];
    backItem_=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    datas_=@[kNameContact,kNameLocation,kNameMap,kNameCode,kNameChat];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ListTableViewCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [datas_ count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text=datas_[indexPath.row];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([datas_[indexPath.row] isEqualToString:kNameContact]){
        ContactListTableViewController *contactListVC=[[ContactListTableViewController alloc] initWithNibName:@"ContactListTableViewController" bundle:nil];
        nav_.viewControllers=@[contactListVC];
        contactListVC.navigationItem.leftBarButtonItem=backItem_;
        [self presentViewController:nav_ animated:YES completion:nil];
    }else if([datas_[indexPath.row] isEqualToString:kNameLocation]){
        if(!locationService_){
            locationService_=[LocationService new];
        }
        [locationService_ startLocationWithCompleteHandle:^(CLLocation *location) {
            [locationService_ startGeoCoding:location withCompleteHandle:^(NSArray *address) {
                NSString *msg=[NSString stringWithFormat:@"经纬度:%.2f,%.2f\n地理信息:%@",location.coordinate.latitude,location.coordinate.longitude,[address componentsJoinedByString:@","]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"当前位置信息" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }];
    }else if([datas_[indexPath.row] isEqualToString:kNameMap]){
        MapViewController *mapVC=[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        nav_.viewControllers=@[mapVC];
        mapVC.navigationItem.leftBarButtonItem=backItem_;
        [self presentViewController:nav_ animated:YES completion:nil];
    }else if([datas_[indexPath.row] isEqualToString:kNameCode]){
        ZBarReaderViewController *zbar=[[ZBarReaderViewController alloc] init];
        zbar.readerDelegate=self;
        [self presentViewController:zbar animated:YES completion:nil];
    }else if([datas_[indexPath.row] isEqualToString:kNameChat]){
        ChatViewController *chatVC=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

#pragma mark - ZBar delegate method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"扫描结果" message:symbol.data delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
