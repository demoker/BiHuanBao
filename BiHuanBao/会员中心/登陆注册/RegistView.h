//
//  RegistView.h
//  MaiMaiCircle
//
//  Created by elongtian on 13-11-29.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELTextField.h"
@protocol RegistViewDelegate <NSObject>

- (void)keyboardHidden;

@end

@interface RegistView : UIView <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet ELTextField *userTextField;
@property (retain, nonatomic) IBOutlet ELTextField *pwdTextField;
@property (retain, nonatomic) IBOutlet ELTextField *twopwdTextField;
@property (retain, nonatomic) IBOutlet ELTextField *emailTextField;
@property (retain, nonatomic) IBOutlet ELTextField *teleTextField;
- (IBAction)Regist:(id)sender;
@property (strong, nonatomic) IBOutlet ELTextField *verificationTextField;
- (IBAction)getVerificationCode:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *CodeBtn;
@property (assign, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIButton *corper;
@property (weak, nonatomic) IBOutlet UIButton *buyer;
@end
