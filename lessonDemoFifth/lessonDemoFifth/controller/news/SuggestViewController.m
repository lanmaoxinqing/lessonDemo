//
//  SuggestViewController.m
//  lessonDemoSecond
//
//  Created by sky on 14-6-25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SuggestViewController.h"

@interface SuggestViewController ()

@end

@implementation SuggestViewController

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
    bgScrollview_.contentSize=CGSizeMake(320, 608);
    UIBarButtonItem *submitItem=[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(didSubmitBtnClick)];
    submitItem.enabled=NO;
    self.navigationItem.rightBarButtonItem=submitItem;
        // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textChanged:(id)sender{
    self.navigationItem.rightBarButtonItem.enabled=([titleField_.text length]>0 && [contentTextView_.text length]>0);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect rect=[bgScrollview_ convertRect:textField.frame toView:self.view];
    CGPoint contentoff=bgScrollview_.contentOffset;
    contentoff.y=contentoff.y-(self.view.frame.size.height-rect.origin.y-rect.size.height-300);
    [UIView animateWithDuration:.3 animations:^{
        bgScrollview_.contentOffset=contentoff;
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect rect=[bgScrollview_ convertRect:textView.frame toView:self.view];
    CGPoint contentoff=bgScrollview_.contentOffset;
    contentoff.y=contentoff.y-(self.view.frame.size.height-rect.origin.y-rect.size.height-300);
    [UIView animateWithDuration:.3 animations:^{
        bgScrollview_.contentOffset=contentoff;
    }];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    [self textChanged:nil];
}

#pragma mark - actionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag==10010){
        if(buttonIndex==0){//从相册选择
            UIImagePickerController *picker=[[UIImagePickerController alloc] init];
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate=self;
            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];
        }else if(buttonIndex==1){
            UIImagePickerController *picker=[[UIImagePickerController alloc] init];
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.delegate=self;
            picker.allowsEditing=NO;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else{
        [typeBtn_ setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
        typeBtn_.tag=buttonIndex;//通过typeBtn的tag保存投诉类型
    }
}

#pragma mark - UIImagePickerController
- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //读取图片
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //保存图片
    NSData *data=UIImageJPEGRepresentation(image, 1);//设置图片质量
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    //设置保存路径
    savePath_=[NSString stringWithFormat:@"%@/tmp/%@",NSHomeDirectory(),[formatter stringFromDate:[NSDate date]]];
    [data writeToFile:savePath_ atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [uploadBtn_ setImage:[UIImage imageWithContentsOfFile:savePath_] forState:UIControlStateNormal];
}

-(void)didSubmitBtnClick{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseService *base=[[BaseService alloc] init];
    base.url=@"http://api.blbaidu.cn/API/MessAdd.ashx";
    [base addParam:[savePath_ lastPathComponent] byKey:@"FileName"];
    [base addParam:@(typeBtn_.tag) byKey:@"xingzhi"];
    [base addParam:titleField_.text byKey:@"title"];
    [base addParam:contentTextView_.text byKey:@"content"];
    [base addParam:nameField_.text byKey:@"username"];
    [base addParam:phoneField_.text byKey:@"tel"];
    [base addParam:savePath_ byKey:@"File:Pic"];
    [base uploadWithCompletionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {
        NSString *responseStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"error:%@",[error description]);
    }];
    [base test:savePath_];
    
}

-(IBAction)didUploadBtnClick:(id)sender{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
//    NSArray *arr=@[@"从相册选择",@"拍照",@"取消"];
    actionSheet.tag=10010;//通过tag区分actionsheet
//    for(int i=0;i<arr.count;i++){
//        [actionSheet addButtonWithTitle:arr[i]];
//    }
    [actionSheet addButtonWithTitle:@"从相册选择"];
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:sender];
}

-(IBAction)didTypeBtnClick:(id)sender{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    actionSheet.tag=10011;//通过tag区分actionsheet
    [actionSheet addButtonWithTitle:@"投诉"];
    [actionSheet addButtonWithTitle:@"建议"];
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:sender];
}

@end
