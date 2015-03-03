//
//  WalletViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/7.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletRecordCell.h"
#import "GivingBTCViewController.h"
#import "CLBCustomAlertView.h"
#import "ShouBTCViewController.h"
@interface WalletViewController ()

@end

@implementation WalletViewController


- (void)viewWillAppear:(BOOL)animated
{
    [self transAction];
    //获取本地记住的用户名和密码，登录,然后获取个人信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appearTabbar" object:nil];
    
}

- (void)receiverNotification:(NSNotification *)noti
{
    if([noti.name isEqualToString:@"myNotificationName"])
    {
        [self transAction];
    }
}


- (void)transAction
{
    _mtableview.contentOffset = CGPointMake(0, 0);
    if([[UserLoginInfoManager loginmanager] state])
    {
        [self download];
        _loginBtn.hidden = YES;
        _registBtn.hidden = YES;
        _descLabel.hidden = YES;
        infoView.hidden = NO;
        
        _comeMoneyBtn.hidden = NO;
        _goMoneyBtn.hidden = NO;
        _mtableview.hidden = NO;
    }
    else
    {
        infoView.hidden = YES;
        _loginBtn.hidden = NO;
        _registBtn.hidden = NO;
        _descLabel.hidden = NO;
        
        _comeMoneyBtn.hidden = YES;
        _goMoneyBtn.hidden = YES;
        _mtableview.hidden = YES;
    }
}
- (void)download
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,UserInfoUrl,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        [infoView.content_img setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_face"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        infoView.content_name.text = [dic objectForKey:@"content_user"];
        infoView.yu_e.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"myaccount"]];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator LoadSuccess];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:@"myNotificationName" object:nil];
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"钱包";
    navBar.backbtn.hidden = YES;
    [navBar.homebtn setImage:[UIImage imageNamed:@"refresh_icon"] forState:UIControlStateNormal];
    navBar.homebtn.frame = CGRectMake(navBar.frame.size.width-44, navBar.homebtn.frame.origin.y, 44, 44);
    [self.view addSubview:navBar];
    
    _mtableview.pullDelegate = self;
    
    
    infoView = [[[NSBundle mainBundle] loadNibNamed:@"WalletInfoView" owner:self options:nil] lastObject];
    infoView.center = CGPointMake(_headView.frame.size.width/2, _headView.frame.size.height/2);
    [self.headView addSubview:infoView];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.view addSubview:self.indicator];
    
    _loginBtn.hidden = YES;
    _registBtn.hidden = YES;
    _descLabel.hidden = YES;
    [_goMoneyBtn addTarget:self action:@selector(goMoneyAction:) forControlEvents:UIControlEventTouchDown];
    [_comeMoneyBtn addTarget:self action:@selector(comeMoneyAction:) forControlEvents:UIControlEventTouchDown];
  
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
//    [self.indicator startAnimatingActivit];
//    [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:@"暂未开通，敬请期待！"];
    [self.view addSubview:self.indicator];
    
}
- (void)goMoneyAction:(UIButton *)sender
{
    GivingBTCViewController * giving = [[GivingBTCViewController alloc]initWithNibName:@"GivingBTCViewController" bundle:nil];
    [self.navigationController pushViewController:giving animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
}
- (void)comeMoneyAction:(UIButton *)sender
{
    ShouBTCViewController * shou = [[ShouBTCViewController alloc]initWithNibName:@"ShouBTCViewController" bundle:nil];
    [self.navigationController pushViewController:shou animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WalletRecordCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WalletRecordCell" owner:self options:nil] lastObject];
    }
    if(indexPath.row%2==0)
    {
        [cell.fangxiang_Img setImage:[UIImage imageNamed:@"go_money"]];
        cell.time_label.textColor = UIColorFromRGB(0xfb5120);
        cell.number_label.textColor = UIColorFromRGB(0xfb5120);
        cell.btc_label.textColor = UIColorFromRGB(0xfb5120);
    }
    else
    {
        [cell.fangxiang_Img setImage:[UIImage imageNamed:@"come_money"]];
        cell.time_label.textColor = UIColorFromRGB(0x5db66e);
        cell.number_label.textColor = UIColorFromRGB(0x5db66e);
        cell.btc_label.textColor = UIColorFromRGB(0x5db66e);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.f;
}
- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{

}
- (void)pullTableViewDidTriggerRefresh:(TableView *)pullTableView
{
    
}
- (void)home:(id)sender
{

    //[self refresh];刷新
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
