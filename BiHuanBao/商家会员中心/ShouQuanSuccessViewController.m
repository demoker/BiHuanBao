//
//  ShouQuanFailedViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "ShouQuanSuccessViewController.h"
#import "CLBCustomAlertView.h"
@interface ShouQuanSuccessViewController ()

@end

@implementation ShouQuanSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.text = @"收券";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];
    
    [_cancel_btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [_sure_btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.content_img setImageWithURL:[NSURL URLWithString:_mitem.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
    self.content_name.text = _mitem.content_name;
    self.content_code.text = _mitem.s_code;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sureAction:(id)sender
{
    //收券
    NSString * url = [NSString stringWithFormat:@"%@%@&autoid=%@&s_code=%@&ID=%@&PWD=%@",HTTP,CorpSureShouQuanUrl,self.autoid,self.s_code,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:[dic objectForKey:@"msg"] leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            
            [alertView show];
        }
        else
        {
            CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:[dic objectForKey:@"msg"] leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            
            [alertView show];
        }
        
        [self.view makeToast:[dic objectForKey:@"msg"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
