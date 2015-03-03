//
//  LoginView.m
//  MaiMaiCircle
//
//  Created by elongtian on 13-11-29.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
   
}

- (IBAction)check:(id)sender {
    if([self.delegate respondsToSelector:@selector(check:)])
    {
        [self.delegate check:sender];
    }
}

- (IBAction)findBackPwd:(id)sender {
    if([self.delegate respondsToSelector:@selector(findBackPwd:)])
    {
        [self.delegate findBackPwd:sender];
    }
}

- (IBAction)Login:(id)sender {
  if([self.delegate respondsToSelector:@selector(Login:)])
  {
      [self.delegate Login:sender];
  }
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
//    [_check_imageV release];
//    [_direct_purchase release];
//    [super dealloc];
}
@end
