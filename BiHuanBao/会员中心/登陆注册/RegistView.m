//
//  RegistView.m
//  MaiMaiCircle
//
//  Created by elongtian on 13-11-29.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import "RegistView.h"

@implementation RegistView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.delegate keyboardHidden];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
    [_twopwdTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_teleTextField resignFirstResponder];
    [_verificationTextField resignFirstResponder];
    [self.delegate keyboardHidden];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (IBAction)Regist:(id)sender {
    if([self.delegate respondsToSelector:@selector(Regist:)])
    {
        [self.delegate Regist:sender];
    }
}
- (void)dealloc {
//    [_userTextField release];
//    [_pwdTextField release];
//    [_twopwdTextField release];
//    [_emailTextField release];
//    [_teleTextField release];
//    [super dealloc];
}



- (IBAction)getVerificationCode:(id)sender {
}
@end
