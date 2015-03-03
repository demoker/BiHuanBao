
//
//  LoginController.m
//  MaiMaiCircle
//
//  Created by elongtian on 13-11-29.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "RegistView.h"
#import "ForgotPwdViewController.h"
#import "CLBCustomAlertView.h"
//#import "IQKeyBoardManager.h"


#define numTextFields 5

#define BannerViewWidth 62

@interface LoginController ()

@end

@implementation LoginController
@synthesize islogin;
@synthesize from_pay;
@synthesize delegate;
@synthesize navbar;
@synthesize mtableview;
@synthesize isCorper;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.from_pay = NO;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = BackGround_Color;
    
    isCorper = NO;
    // isfirst = YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:AreRemember] == nil)
    {
     
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AreRemember];
    }
    else
    {
//        isfirst = [[[NSUserDefaults standardUserDefaults] objectForKey:AreRemember] boolValue];
    }
    
    navbar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navbar.titleLabel.text = @"登录/注册" ;
    [navbar.homebtn setHidden:YES];
    navbar.delegate = self;
    
    [self.view addSubview:navbar];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:self withType:ActivityIndicatorLogin andAction:nil];
    
    [self.view addSubview:self.indicator];
    
//    bannerView = [[[NSBundle mainBundle] loadNibNamed:@"LoginBannerView" owner:self options:nil] lastObject];
//    mtableview.tableHeaderView = bannerView;

    [_loginBtn addTarget:self action:@selector(transAction:) forControlEvents:UIControlEventTouchDown];
     [_registBtn addTarget:self action:@selector(transAction:) forControlEvents:UIControlEventTouchDown];
    
    if(islogin)
    {
        [self transAction:_loginBtn];
    }
    else
    {
        [self transAction:_registBtn];
    }
    
   
}


#pragma mark - 键盘高度
//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardheight = keyboardRect.size.height;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    mtableview.frame = CGRectMake(0.0f, NAVHEIGHT+62, mtableview.frame.size.width, SCREENHEIGHT-NAVHEIGHT-62-keyboardheight);

    [UIView commitAnimations];
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    mtableview.frame = CGRectMake(0, NAVHEIGHT+62, mtableview.frame.size.width, SCREENHEIGHT-NAVHEIGHT-62);
    [UIView commitAnimations];
}
#pragma mark - 切换注册登录
- (void)transAction:(UIButton *)sender
{
    if(sender == _loginBtn)
    {
        islogin = YES;
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"filter_no_selected"] forState:UIControlStateNormal];
    }
    else
    {
        islogin = NO;
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"filter_no_selected"] forState:UIControlStateNormal];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
    }
    [mtableview reloadData];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.contentView.backgroundColor = UIColorFromRGB(0xfafbfc);
//    cell.backgroundColor = UIColorFromRGB(0xfafbfc);
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if(islogin)
    {
        loginview = [[[NSBundle mainBundle]loadNibNamed:@"LoginView" owner:self options:nil] lastObject];
        loginview.userTextField.delegate = self;
        loginview.pwdTextField.delegate = self;
        loginview.delegate = self;
       
        NSLog(@"%@,%@",NSUserDefault_USER,NSUserDefault_PWD);
        if(is_Remember_Bool)
        {
            loginview.userTextField.text = NSUserDefault_USER;
            loginview.pwdTextField.text = NSUserDefault_PWD;
        }
        
        if(is_Remember_Bool)
        {
            
            [loginview.check_imageV setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
        }
        else
        {
            
            [loginview.check_imageV setImage:[UIImage imageNamed:@"login_no_selected"] forState:UIControlStateNormal];
        }
        
        [cell.contentView addSubview:loginview];
        
    }
    else
    {
        registview = [[[NSBundle mainBundle] loadNibNamed:@"RegistView" owner:self options:nil] lastObject];
        registview.delegate = self;
        registview.userTextField.delegate = self;
        registview.pwdTextField.delegate = self;
        registview.twopwdTextField.delegate = self;
        registview.emailTextField.delegate = self;
        registview.verificationTextField.delegate = self;
        registview.teleTextField.delegate = self;

        [registview.CodeBtn addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchDown];
        [registview.buyer addTarget:self action:@selector(selectBuyer:) forControlEvents:UIControlEventTouchDown];
        [registview.corper addTarget:self action:@selector(selectCorper:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:registview];
        
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0.0;
    if(islogin)
    {
        height = 321.0;
    }
    else
    {
        height = 263.0;
    }
    return height;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(!islogin)
    {
        
        if(textField.tag == 102)
        {
            UITextField * field = (UITextField *)[registview viewWithTag:101];
            if([field.text isEqualToString:textField.text])
            {
                NSLog(@"两次输入密码相同");
            }
            else
            {
                textField.text = @"";
            }
        }
        else if(textField.tag == 104)
        {
            if([self CheckPhoneNumInput:textField.text])
            {
                NSLog(@"手机号输入正确");
            }
            else
            {
                textField.text = @"";
            }

        }
        else if (textField.tag == 103)
        {
            if([self checkIfEmailId:textField.text])
            {
                NSLog(@"邮箱输入正确");
            }
            else
            {
                textField.text = @"";
            }
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardHidden];
    if(islogin)
    {
        if(textField.tag < 101)
        {
            [textField resignFirstResponder];
            UITextField * field = (UITextField *)[loginview viewWithTag:textField.tag+1];
            [field becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
    }
    else
    {
        if(textField.tag < 105)
        {
            [textField resignFirstResponder];
            UITextField * field = (UITextField *)[registview viewWithTag:textField.tag+1];
            [field becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
    }
    return YES;
}

- (void)selectBuyer:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
    [registview.corper setImage:[UIImage imageNamed:@"login_no_selected"] forState:UIControlStateNormal];
    isCorper = NO;
}
- (void)selectCorper:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
    [registview.buyer setImage:[UIImage imageNamed:@"login_no_selected"] forState:UIControlStateNormal];
    isCorper = YES;
}

#pragma mark - 验证输入框的内容
//判别手机号
- (BOOL)CheckPhoneNumInput:(NSString *)_text{
    
    NSString *Regex =@"(13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}";
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    return [mobileTest evaluateWithObject:_text];
    
}
//第三方判别方法(判别邮箱)

//系统自带的方法(判别邮箱)
- (BOOL)checkIfEmailId:(NSString *)string
{
    if (string == nil)
        string = [NSString string];
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return numberOfMatches     == 1;
}

/**
 *  字母和数字
 *
 *  @param string 要判别的字符串
 *
 *  @return yes or no
 */
- (BOOL)CheckIfAlphaNumeric:(NSString *)string
{
    if (string == nil)
        return NO;
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return numberOfMatches     == string.length;
}
- (void)keyboardHidden
{
    mtableview.contentOffset = CGPointMake(0, 0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
  if(islogin)
  {
      for(UIView * view in loginview.subviews)
      {
          if([view isKindOfClass:[UITextField class]])
          {
              [(UITextField * )view resignFirstResponder];
          }
      }
  }
  else
  {
      for(UIView * view in registview.subviews)
      {
          if([view isKindOfClass:[UITextField class]])
          {
              [(UITextField * )view resignFirstResponder];
          }
      }
  }
    [self keyboardHidden];
}


- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)home:(id)sender
{
    [self.indicator activityHidden];
    if(islogin)
    {
        islogin = NO;
    }
    else
    {
        islogin = YES;
    }
    [mtableview reloadData];
}
- (void)check:(id)sender {
    //勾选记住密码
    if(islogin)
    {
       if(is_Remember_Bool)
       {
            [loginview.check_imageV setImage:[UIImage imageNamed:@"login_no_selected"] forState:UIControlStateNormal];
           // isfirst = NO;
           
       }
        else
        {
             [loginview.check_imageV setImage:[UIImage imageNamed:@"login_selected"] forState:UIControlStateNormal];
          //  isfirst = YES;
        }
        [[NSUserDefaults standardUserDefaults] setBool:!is_Remember_Bool forKey:AreRemember];
    }
    
}

- (void)findBackPwd:(id)sender {
    //找回密码
    ForgotPwdViewController * forgot = [[ForgotPwdViewController alloc]initWithNibName:@"ForgotPwdViewController" bundle:nil];
    [self.navigationController pushViewController:forgot animated:YES];
}

- (void)Login:(id)sender {
      //登录成功
        //更改菜单项的个人登录信息
        //登录成功后并没有直接跳转
    if([loginview.userTextField.text length]==0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请您输入用户名" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
        [alert show];
        return;
    }
    else if ([loginview.pwdTextField.text length]==0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请您输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
        [alert show];
        return;
    }
    else
    {
        [self.indicator startAnimatingActivit];
        NSString * login_url = nil;
        
//        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:loginview.userTextField.text,@"usr",loginview.pwdTextField.text,@"pwd", nil];
        //在这里将登陆框中的帐户和密码储存到本地
       if(isCorper)
       {
           login_url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,LoginUrl,loginview.userTextField.text,[FileMangerObject md5:loginview.pwdTextField.text]];
           
           [[NSUserDefaults standardUserDefaults] setObject:loginview.userTextField.text forKey:@"corp_user"];
           [[NSUserDefaults standardUserDefaults] setObject:loginview.pwdTextField.text forKey:@"corp_pwd"];
       }
        else
        {
            login_url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,LoginUrl,loginview.userTextField.text,[FileMangerObject md5:loginview.pwdTextField.text]];
            
            [[NSUserDefaults standardUserDefaults] setObject:loginview.userTextField.text forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setObject:loginview.pwdTextField.text forKey:@"pwd"];
        }
        
        [[UserLoginInfoManager loginmanager] setUser:loginview.userTextField.text];
        [[UserLoginInfoManager loginmanager] setPwd:[FileMangerObject md5:loginview.pwdTextField.text]];//这里只有密码md5转码了
        
        [self loginUser:login_url];
    }
    
}


- (void)loginUser:(NSString *)url
{
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
       
            //返回登录信息，判断是否成功
            if([[dic objectForKey:@"status"] integerValue] == 1)
            {
                [[UserLoginInfoManager loginmanager] setState:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoginState"];
                if([[[dic objectForKey:@"data"] objectForKey:@"s_type"] integerValue] ==1 )
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isCorper"];//用户会员
                    [[UserLoginInfoManager loginmanager] setIsCorper:@"1"];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"isCorper"];//商家会员
                    [[UserLoginInfoManager loginmanager] setIsCorper:@"2"];
                }
                
                if(self.delegate)
                {
                    [self.delegate performSelector:@selector(loginfinished)];
                }
                [self sendNoti];
                [self back:nil];
            }
            else if([[dic objectForKey:@"status"] integerValue] == 0)
            {
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alertview show];
            }
        
        [self.indicator activityHidden];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator activityHidden];
    }];
}
- (void)Regist:(id)sender {
    if(islogin)
    {
        islogin = NO;
        //注册
        login_btn.hidden = NO;
        [mtableview reloadData];
    }
    else
    {
        if([registview.emailTextField.text length]==0)
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入邮箱" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertview show];
           
        }
        else if ([registview.pwdTextField.text length]==0)
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertview show];
        }
        else if ([registview.twopwdTextField.text length]==0)
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请再次输入密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertview show];
        }
//        else if ([registview.emailTextField.text length]==0)
//        {
//            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入邮箱" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
//            [alertview show];
//        }
//        else if([registview.teleTextField.text length]==0)
//        {
//            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
//            [alertview show];
//           
//        }
//        else if([registview.verificationTextField.text length] == 0
//                )
//        {
//            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
//            [alertview show];
//        }
        else
        {
             [self.indicator startAnimatingActivit];
            //执行注册事件
            
//            NSString * regist_url = [NSString stringWithFormat:@"%@%@&type=%@&ID=%@&PWD=%@&code=%@&email=%@&tel=%@",HTTP,RegistUrl,(isCorper?@"corp":@"personal"),registview.userTextField.text,[FileMangerObject md5:registview.pwdTextField.text],registview.verificationTextField.text,registview.emailTextField.text,registview.teleTextField.text];
             NSString * regist_url = [NSString stringWithFormat:@"%@%@&type=%@&ID=%@&PWD=%@",HTTP,RegistUrl,(isCorper?@"corp":@"personal"),registview.emailTextField.text,[FileMangerObject md5:registview.pwdTextField.text]];

            [self registUser:regist_url];
        }
 
    }
}

- (void)registUser:(NSString *)url
{
    [[ELHttpRequestOperation sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
            //返回注册响应信息
            if([[dic objectForKey:@"status"] integerValue]==1)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
                [[UserLoginInfoManager loginmanager] setState:YES];
                
                //注册完成后直接登录
                // [self.delegate performSelector:@selector(loginFinished)];
                [[UserLoginInfoManager loginmanager] setUser:registview.emailTextField.text];
                [[UserLoginInfoManager loginmanager] setPwd:[FileMangerObject md5:registview.pwdTextField.text]];
                [[UserLoginInfoManager loginmanager] setState:YES];
                
                if(isCorper)
                {
                     [[UserLoginInfoManager loginmanager] setIsCorper:@"2"];
                    [[NSUserDefaults standardUserDefaults]setValue:@"2"forKey:@"isCorper"];
                }else
                {
                    [[UserLoginInfoManager loginmanager] setIsCorper:@"1"];
                    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isCorper"];
                }
                
                    [[NSUserDefaults standardUserDefaults] setObject:registview.emailTextField.text forKey:@"user"];
                    [[NSUserDefaults standardUserDefaults] setObject:registview.pwdTextField.text forKey:@"pwd"];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LoginState"];
                
                [self sendNoti];
                
                CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"注册成功" message:@"是否立即升级为VIP会员？VIP会员享有免费救援服务，只要99元，会员资格24小时后生效，有效期1年。" leftButtonTitle:@"稍后再说" leftActionBlock:^(CLBCustomAlertView *view) {
                    [self back:nil];
                    [view dismiss];
                } rightButtonTitle:@"去看看" rightActionBlock:^(CLBCustomAlertView *view) {
                    [view dismiss];
                }];
                [alert show];
            }
            else if([[dic objectForKey:@"status"] integerValue]==0)
            {
                
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alertview show];
            }
            
            [self.indicator activityHidden];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator activityHidden];
    }];
}

#pragma mark - getVerificationCode获取验证码
- (void)getVerificationCode:(UIButton *)sender
{
    NSString * url = [NSString stringWithFormat:@"%@%@&tel=%@",HTTP,GetVerificationCodeRegistUrl,registview.teleTextField.text];
    if([registview.teleTextField.text length] == 0)
    {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertview show];
        return;
    }
    
    time = 60;
    [self.indicator startAnimatingActivit];
    
    registview.CodeBtn.enabled = NO;
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            mtime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRepeat) userInfo:nil repeats:YES];
        }
        else
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertview show];
            registview.CodeBtn.enabled = YES;
        }
        
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
       
    }];
}

- (void)timerRepeat
{
    time--;
    [registview.CodeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",time] forState:UIControlStateDisabled];
    registview.CodeBtn.enabled = NO;
    
    if(time == 0)
    {
        [registview.CodeBtn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        [mtime invalidate];
        registview.CodeBtn.enabled = YES;
    }
    
}


- (void)AnimationLogin:(id)sender
{
    //跳转到登录界面，其实就是刷新到登录界面
    islogin = YES;
    login_btn.hidden = YES;
    selectedTextFieldTag = 100;
    [mtableview reloadData];
}




- (void)sendNoti
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",[[UserLoginInfoManager loginmanager] state]] forKey:@"login_state"];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationName" object:self userInfo:dic];
}

- (void)dealloc
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
