//
//  MyModifyViewController.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-20.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "MyModifyViewController.h"

@interface MyModifyViewController ()

@end

@implementation MyModifyViewController
@synthesize titleName;
@synthesize delegate;
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
    
    navBar = [[JRNavgationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
//    navBar.homebtn.frame = CGRectMake(navBar.homebtn.frame.origin.x-6, IOS7?20:0, 44, 44);
    [navBar.homebtn setTitle:@"保存" forState:UIControlStateNormal];
    [navBar.homebtn setBackgroundImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [navBar.homebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    navBar.titleLabel.text = self.titleName;
    navBar.delegate = self;
    [self.view addSubview:navBar];
    //&ID=elongtian1&PWD=e10adc3949ba59abbe56e057f20f883e&EMAIL=12312%40qq.com&frm[content_name]=aa

    switch (self.type) {
        case 1:
        {
        //用户名修改
            _TextFieldTwo.hidden = YES;
            _TextFieldThree.hidden = YES;
            _TextFieldOne.text = self.name;
            
        }
            break;
        case 2:
        {
        //邮箱修改
            _TextFieldTwo.hidden = YES;
            _TextFieldThree.hidden = YES;
            _TextFieldOne.text = self.email;
        }
            break;
        case 3:
        {
            //手机号修改
            _TextFieldTwo.hidden = YES;
            _TextFieldThree.hidden = YES;
            _TextFieldOne.text = self.mobile;
             _TextFieldOne.keyboardType = UIKeyboardTypePhonePad;
            
        }
            break;
        case 10:
        {
            //密码修改
            _TextFieldTwo.hidden = NO;
            _TextFieldThree.hidden = NO;
            _TextFieldOne.placeholder = @"请输入原始密码";
            _TextFieldTwo.placeholder = @"请输入新密码";
            _TextFieldThree.placeholder = @"请再次输入新密码";
            _TextFieldOne.secureTextEntry = YES;
            _TextFieldTwo.secureTextEntry = YES;
            _TextFieldThree.secureTextEntry = YES;
            _TextFieldOne.keyboardType = UIKeyboardTypeASCIICapable;
            _TextFieldTwo.keyboardType = UIKeyboardTypeASCIICapable;
            _TextFieldThree.keyboardType = UIKeyboardTypeASCIICapable;
       
        }
            break;
        default:
            break;
    }
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:nil withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.view addSubview:self.indicator];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_TextFieldOne resignFirstResponder];
    [_TextFieldTwo resignFirstResponder];
    [_TextFieldThree resignFirstResponder];
}

- (void)download:(NSString *)url withDic:(NSDictionary *)dic
{
    DLog(@"%@\n%@",url,dic);
    [self.indicator startAnimatingActivit];
    [[ELHttpRequestOperation sharedClient] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = (NSDictionary *)responseObject;
        
        DLog(@"%@",dict);
        
        if(self.type == 10)//修改密码
            {
                //                    [[UserLoginInfoManager loginmanager] setUser:@""];
                //                    [[UserLoginInfoManager loginmanager] setPwd:@""];
                if(is_Remember_Bool)
                {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:_TextFieldTwo.text forKey:USER_PWD];
                }
                [[UserLoginInfoManager loginmanager] setState:NO];
                [self sendNoti];
            }
            else
            {
                if([self.delegate respondsToSelector:@selector(modifyFinished:index:)])
                {
                    [self.delegate modifyFinished:_TextFieldOne.text index:self.type];
                }
                
            }
        
        [self.view makeToast:[dict objectForKey:@"msg"]];
       
        [self.indicator activityHidden];
        
        [self back:nil];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator activityHidden];

    }];
    
}

- (void)sendNoti
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",[[UserLoginInfoManager loginmanager] state]] forKey:@"login_state"];
    [dic setValue:@"1" forKey:@"modify"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationName" object:self userInfo:dic];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)home:(id)sender
{
    [self.indicator startAnimatingActivit];
    [_TextFieldOne resignFirstResponder];
    [_TextFieldTwo resignFirstResponder];
    [_TextFieldThree resignFirstResponder];
    NSString *  url = [NSString stringWithFormat:@"%@&method=save&app_com=com_passport",HTTP];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[UserLoginInfoManager loginmanager].user forKey:@"ID"];
    [dic setValue:[UserLoginInfoManager loginmanager].pwd forKey:@"PWD"];
    switch (self.type) {
        case 1:
        {
            //用户名修改
            [dic setValue:_TextFieldOne.text forKey:@"frm[content_name]"];
             [dic setValue:@"app_editInfo" forKey:@"task"];
        }
            break;
        case 2:
        {
            //邮箱修改
            [dic setValue:_TextFieldOne.text forKey:@"EMAIL"];
             [dic setValue:@"app_editInfo" forKey:@"task"];
        }
            break;
        case 3:
        {
            //手机号修改
            [dic setValue:_TextFieldOne.text forKey:@"frm[content_mobile]"];
            [dic setValue:@"app_editInfo" forKey:@"task"];
        }
            break;
        case 10:
        {
            //密码修改
            [dic setValue:[FileMangerObject md5:_TextFieldTwo.text] forKey:@"frm[PWD]"];
            [dic setValue:@"app_editPwd" forKey:@"task"];
        }
            break;
        default:
            break;
    }
    [self download:url withDic:dic];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_TextFieldOne release];
//    [_TextFieldTwo release];
//    [_TextFieldThree release];
//    [navBar release];
//    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextFieldOne:nil];
    [self setTextFieldTwo:nil];
    [self setTextFieldThree:nil];
    [super viewDidUnload];
}
@end
