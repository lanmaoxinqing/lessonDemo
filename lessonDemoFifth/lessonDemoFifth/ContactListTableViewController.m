//
//  ContactListTableViewController.m
//  lessonDemoFifth
//
//  Created by sky on 14-7-22.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "ContactListTableViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation PeopleInfo

@end

@interface ContactListTableViewController ()

@end

@implementation ContactListTableViewController

- (void)viewDidLoad
{
    peoples=[NSMutableArray new];
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ContactListCell"];
    [self readAllPeoples];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [peoples count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeopleInfo *people=peoples[indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ContactListCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"ContactListCell"];
    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactListCell" forIndexPath:indexPath];
    cell.textLabel.text=people.name;
    cell.detailTextLabel.text=people.phone;
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

//读取所有联系人
-(void)readAllPeoples
{
    /*取得本地通信录名柄*/
    //判断系统版本
    ABAddressBookRef addressBook=nil;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0){
        addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    }else{
        addressBook=ABAddressBookCreate();
    }
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if(!error && granted){
            CFArrayRef peopleArr=ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex count=ABAddressBookGetPersonCount(addressBook);
            for(int i=0;i<count;i++){
                ABRecordRef record=CFArrayGetValueAtIndex(peopleArr, i);
                //kABPersonCreationDateProperty
                PeopleInfo *info=[PeopleInfo new];
                NSString *firstName=(__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                NSString *lastName=(__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
                info.name=[firstName?firstName:@"" stringByAppendingString:lastName?lastName:@""];
                ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
                if(ABMultiValueGetCount(phone)>0){
                    NSString *phoneNum=(__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, 0);
                    info.phone=phoneNum;
                }
                [peoples addObject:info];
            }
            [self.tableView reloadData];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法访问通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        CFRelease(addressBook);
    });
}


@end
