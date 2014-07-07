//
//  SuggestViewController.h
//  lessonDemoSecond
//
//  Created by sky on 14-6-25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>{
    IBOutlet UIScrollView *bgScrollview_;
    IBOutlet UIButton *uploadBtn_;
    IBOutlet UIButton *typeBtn_;
    IBOutlet UITextField *titleField_;
    IBOutlet UITextView *contentTextView_;
    IBOutlet UITextField *nameField_;
    IBOutlet UITextField *phoneField_;
    
    NSString *savePath_;
}

@end
