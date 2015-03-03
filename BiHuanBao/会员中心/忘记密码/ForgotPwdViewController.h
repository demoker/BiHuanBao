//
//  ForgotPwdViewController.h
//  MaiMaiCircle
//
//  Created by aikaka on 13-12-1.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPwdViewController : BaseViewController <UITextFieldDelegate>
{
    int selectedTextFieldTag;
    JRNavgationBar * navBar;
    NSTimer * mtime;
    int time;
}
@property (retain, nonatomic) IBOutlet ELTextField *teleTextField;
@property (retain, nonatomic) IBOutlet ELTextField *verificationTextfield;//验证码
- (IBAction)getVerificationCode:(id)sender;

- (IBAction)findBackPwd:(id)sender;
@property (retain, nonatomic) IBOutlet ELTextField *twoPwdField;
@property (retain, nonatomic) IBOutlet UIButton *verificationCode;
@property (weak, nonatomic) IBOutlet ELTextField *oldPwdField;
@property (weak, nonatomic) IBOutlet ELTextField *threePwdField;

@end
