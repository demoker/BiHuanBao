//
//  ForgotPwdViewController.m
//  MaiMaiCircle
//
//  Created by aikaka on 13-12-1.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "RegularManager.h"
#define TIME 60.0
@interface ForgotPwdViewController ()

@end

@implementation ForgotPwdViewController

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
    
    // Do any additional setup after loading the view from its nib.
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONLOGINBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"账户安全";
    [self.view addSubview:navBar];

    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:@"正在获取..." withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.view addSubview:self.indicator];
}


-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_teleTextField resignFirstResponder];
    [_verificationTextfield resignFirstResponder];
    [_twoPwdField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   // selectedTextFieldTag = textField.tag;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - usermanagerdelegate
- (void)returnfindbackpwdData:(id)data
{
    //返回找回密码的响应信息
    NSDictionary * dic = (NSDictionary *)data;
    if([[dic objectForKey:@"status"] isEqualToString:@"1"])
    {
        [[UserLoginInfoManager loginmanager] setState:NO];
        [self sendNoti];
        [self back:nil];
    }
    else
    {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertview show];
    }
}

- (void)sendNoti
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",[[UserLoginInfoManager loginmanager] state]] forKey:@"login_state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationName" object:self userInfo:dic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if([mtime isValid])
    {
        [mtime invalidate];
    }
//    [_teleTextField release];
//    [navBar release];
//    [_verificationTextfield release];
//    [_newPwdField release];
//    [_verificationCode release];
//    [super dealloc];
}
- (void)viewDidUnload {
    [self setTeleTextField:nil];
    [self setVerificationTextfield:nil];
    [self setTwoPwdField:nil];
    [self setVerificationCode:nil];
    [super viewDidUnload];
}
- (IBAction)getVerificationCode:(id)sender {
    
    
    
    time = TIME;
    //获取验证码
//    [usermanager getCaptcha:@"" withTelephone:@"" andkey:@""];
//    NSLog(@"%@",[usermanager getCaptcha:@"" withTelephone:@"" andkey:@""]);
    if([_teleTextField.text length]==0)
    {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入您的手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertview show];
        return;
    }
    else if(![RegularManager validateMobile:_teleTextField.text])
    {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertview show];
        return;
    }

   
   [self.indicator startAnimatingActivit];
    
    NSString * url = [NSString stringWithFormat:@"%@&method=save&app_com=com_passport&method=save&app_com=com_passport&task=app_pwdCode&ID=%@",HTTP,_teleTextField.text];

    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
             mtime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        }
        else
        {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertview show];
        }
        [self.indicator LoadSuccess];
        [self.view makeToast:[dic objectForKey:@"msg"]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator LoadSuccess];
    }];

}

- (void)refresh
{
    
     [_verificationCode setTitle:[NSString stringWithFormat:@"%d秒后重新获取",time] forState:UIControlStateDisabled];
    _verificationCode.enabled = NO;

    
   
    if(time == 0)
    {
        [_verificationCode setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        [mtime invalidate];
        _verificationCode.enabled = YES;
    }
    time--;
    
}

- (IBAction)findBackPwd:(id)sender {
    if([_teleTextField.text length]>0&&[_verificationTextfield.text length]>0 &&[_twoPwdField.text length]>0&&[_oldPwdField.text length]>0&&[_threePwdField.text length]>0)
    {
        //找回密码
        [self.indicator startAnimatingActivit];
        NSString * url = [NSString stringWithFormat:@"%@&method=save&app_com=com_passport&task=app_resetPwd&tel=%@&PWD=%@&code=%@",HTTP,_teleTextField.text,[FileMangerObject md5:_twoPwdField.text],_verificationTextfield.text];
       
        [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            if([[dic objectForKey:@"status"] integerValue] == 1)
            {
                [[UserLoginInfoManager loginmanager] setState:NO];
                [self sendNoti];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.view makeToast:[dic objectForKey:@"msg"]];
            }
            else
            {
                [self.view makeToast:[dic objectForKey:@"msg"]];
            }
            [self.indicator LoadSuccess];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:NO_NET];
            
        }];
    }
    else
    {
        [self.view makeToast:@"请输入完整信息"];
    }
}




@end
