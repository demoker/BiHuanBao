//
//  ViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/8.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "MyMemberViewController.h"
#import "MyCouponViewController.h"
#import "MyBiDestineController.h"
#import "OrderListController.h"
#import "EvaluateViewController.h"
#import "UserInfoViewController.h"
#import "ForgotPwdViewController.h"

#import "CorpMemberViewController.h"
#import "TransactionRecordsViewController.h"
#import "CLBCustomAlertView.h"
#import "CommitTableViewCell.h"
@interface MyMemberViewController ()

@end

@implementation MyMemberViewController
@synthesize dataarray;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"我的";
    navBar.backbtn.hidden = YES;
    [navBar.homebtn setImage:[UIImage imageNamed:@"refresh_icon"] forState:UIControlStateNormal];
    navBar.homebtn.frame = CGRectMake(navBar.frame.size.width-44, navBar.homebtn.frame.origin.y, 44, 44);
    [self.view addSubview:navBar];
    dataarray = [[NSMutableArray alloc]initWithObjects:@[@"订单中心",@"送币预约"],@[@"比特币充值",@"交易记录"],@[@"账户安全",@"账户信息"], @[@"注销"],nil];
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = BackGround_Color;
    
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchDown];
    [_registBtn addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchDown];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:@"myNotificationName" object:nil];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(my_quanAction:)];
    [_my_quan addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(my_walletAction:)];
    [_my_wallet addGestureRecognizer:tap2];
    
    infoView = [[[NSBundle mainBundle] loadNibNamed:@"WalletInfoView" owner:self options:nil] lastObject];
    infoView.center = CGPointMake(_headview.frame.size.width/2, _headview.frame.size.height/2);
    [self.headview addSubview:infoView];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.view addSubview:self.indicator];

  
    
    
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
        
        _my_quan.hidden = NO;
        _my_wallet.hidden = NO;
        _mtableview.hidden = NO;
        _line.hidden = NO;
    }
    else
    {
        infoView.hidden = YES;
        _loginBtn.hidden = NO;
        _registBtn.hidden = NO;
        _descLabel.hidden = NO;
        
        _my_quan.hidden = YES;
        _my_wallet.hidden = YES;
        _mtableview.hidden = YES;
        _line.hidden = YES;
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
- (void)my_quanAction:(UITapGestureRecognizer *)tap
{
    MyCouponViewController * couponlist = [[MyCouponViewController alloc]initWithNibName:@"MyCouponViewController" bundle:nil];
    [self.navigationController pushViewController:couponlist animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
}
- (void)my_walletAction:(UITapGestureRecognizer *)tap
{
    //跳转到我的钱包

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
    
    CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"暂未开通，敬请期待！" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
        [view dismiss];
    } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
        
    }];
    [alert show];
}
#pragma mark - 登录／注册
- (void)loginAction:(UIButton *)sender
{
    AppDelegate * dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [dele goLoginUser:YES];
}
- (void)registAction:(UIButton *)sender
{
    AppDelegate * dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [dele goLoginUser:NO];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataarray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataarray objectAtIndex:section] count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if(indexPath.section == 3)
    {
        CommitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommitTableViewCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:self options:nil] lastObject];
            [cell.yuyueBtn setTitle:@"注销" forState:UIControlStateNormal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.yuyueBtn.userInteractionEnabled = NO;
        }
        return cell;
    }
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
            imageV.tag = 101311;
            [imageV setImage:[UIImage imageNamed:@"level_line"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:imageV];
        }
        UIImageView * imageV = (UIImageView *)[cell.contentView viewWithTag:101311];
        switch (indexPath.section) {
            case 0:
            {
                if(indexPath.row!=2)
                {
                    imageV.hidden = NO;
                }
                else
                {
                    imageV.hidden = YES;
                }
            }
                break;
            case 1:
            {
                if(indexPath.row!=2)
                {
                    imageV.hidden = NO;
                }
                else
                {
                    imageV.hidden = YES;
                }
            }
                break;
            case 2:
            {
                if(indexPath.row!=2)
                {
                    imageV.hidden = NO;
                }
                else
                {
                    imageV.hidden = YES;
                }
            }
                break;
                
            default:
                break;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x787878);
        cell.textLabel.text = [[dataarray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 10;
    }
    else
    {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 1)
        {
            OrderListController * order = [[OrderListController alloc] initWithNibName:@"OrderListController" bundle:nil];
            order.app_com = @"com_pcenter";
            [self.navigationController pushViewController:order animated:YES];
        }
        else if(indexPath.row == 2)
        {
            MyBiDestineController * bidestine = [[MyBiDestineController alloc] initWithNibName:@"MyBiDestineController" bundle:nil];
            [self.navigationController pushViewController:bidestine animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 1)
        {
            //比特币提取
//            [self.view makeToast:@"暂未开通，敬请期待！"];
            CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"暂未开通，敬请期待！" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            [alert show];
            return;
        }
        else if(indexPath.row == 2)
        {
            //交易记录TransactionRecordsViewController
            TransactionRecordsViewController * trans = [[TransactionRecordsViewController alloc]initWithNibName:@"TransactionRecordsViewController" bundle:nil];
            trans.app_com = @"com_pcenter";
            [self.navigationController pushViewController:trans animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 1)
        {
            ForgotPwdViewController * forget = [[ForgotPwdViewController alloc]initWithNibName:@"ForgotPwdViewController" bundle:nil];
            [self.navigationController pushViewController:forget animated:YES];
        }
        else if (indexPath.row == 2)
        {
            UserInfoViewController * userInfo = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
            [self.navigationController pushViewController:userInfo animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
    }
    else if(indexPath.section == 3)
    {
        [[UserLoginInfoManager loginmanager] setState:NO];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"LoginState"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_NAME];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_PWD];
        [self transAction];
    }
    
    
}
- (void)home:(id)sender
{
//    EvaluateViewController *evaluate = [[EvaluateViewController alloc]initWithNibName:@"EvaluateViewController" bundle:nil];
//    [self.navigationController pushViewController:evaluate animated:YES];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
    [self download];
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
