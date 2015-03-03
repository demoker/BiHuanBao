//
//  LoginController.h
//  MaiMaiCircle
//
//  Created by elongtian on 13-11-29.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistView.h"
#import "LoginView.h"
#import "ActivityIndicator.h"
@protocol LoginDelegate<NSObject>
- (void)loginfinished;// 这里在直接购买那里有用到
@end
@interface LoginController : BaseViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,RegistViewDelegate,JRNavDelegate>
{
    RegistView * registview;
    LoginView * loginview;
    
    UIButton * back_btn;
    UIButton * login_btn;
    
    int selectedTextFieldTag;
   // BOOL isfirst;
    
    
    
    float keyboardheight;
    
    NSTimer * mtime;
    int time;
    
}
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (assign, nonatomic) BOOL islogin;
@property (retain, nonatomic) JRNavgationBar * navbar;
@property (assign, nonatomic) id<LoginDelegate>delegate;
@property (assign, nonatomic) BOOL from_pay;//从支付界面点进

@property (assign, nonatomic) BOOL isCorper;
@property (retain, nonatomic) UITextField * currentTextField;

//yes表示是商家会员
- (void)keyboardHidden;
@end
