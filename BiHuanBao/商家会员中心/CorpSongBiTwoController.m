//
//  CorpSongBiTwoController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/3.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "CorpSongBiTwoController.h"
#import "DoAlertView.h"
#import "QRCodeGenerator.h"
#import "CLBCustomAlertView.h"
@interface CorpSongBiTwoController ()

@end

@implementation CorpSongBiTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BackGround_Color;
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.text = @"送币营销";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];
    
    [_qrCodeMake_btn addTarget:self action:@selector(QrCodeMaking:) forControlEvents:UIControlEventTouchDown];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.view addSubview:self.indicator];

}

- (void)download
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@&method=save&app_com=com_ccenter&task=makeCoinImg&auto_id=%@&frm[btc_price]=%@&ID=%@&PWD=%@",HTTP,self.auto_id,self.input.text,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        self.corp_id = [dic objectForKey:@"corp_id"];
        self.btc_price = [dic objectForKey:@"btc_price"];
        self.auto_id = [dic objectForKey:@"coinsent_id"];
        [self showQr];
        
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
        [self.view makeToast:NO_NET];
    }];
}

- (void)QrCodeMaking:(UIButton *)sender
{
    if([_input.text floatValue]>[_yu_e floatValue])
    {
        CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"送币数目不能大于活动剩余值" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
            [view dismiss];
        } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
            
        }];
        [alertView show];
        return;
    }
    [self download];
}
- (void)showQr
{
    NSString * code = [NSString stringWithFormat:@"&corp_id=%@&coinsent_id=%@&btc_price=%@",self.corp_id,self.auto_id,self.btc_price];
    
    UIImage * image = [QRCodeGenerator qrImageForString:code imageSize:200.0];
    
    DoAlertView * alert = [[DoAlertView alloc]init];
    alert.nAnimationType = DoTransitionStylePop;
    alert.dRound = 2.0;
    alert.iImage = image;
    alert.nContentMode = DoContentImage;
    
    alert.bDestructive = YES;
    [alert doYes:@"请用户会员扫描上面的二维码接收比特币的赠送"
             yes:^(DoAlertView *alertView) {
                 
                 NSLog(@"用户已经赠送!!!!");
                 
             }];
    alert = nil;
}
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
