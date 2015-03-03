//
//  LoginView.h
//  MaiMaiCircle
//
//  Created by elongtian on 13-11-29.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet ELTextField *userTextField;
@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet ELTextField *pwdTextField;
@property (retain, nonatomic) IBOutlet UIButton *check_imageV;
- (IBAction)check:(id)sender;
- (IBAction)findBackPwd:(id)sender;

- (IBAction)Login:(id)sender;

- (IBAction)Regist:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *direct_purchase;
@end
