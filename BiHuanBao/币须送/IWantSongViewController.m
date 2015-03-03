//
//  IWantSongViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/7.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "IWantSongViewController.h"
#import "BixvSongDescTableCell.h"
#import "BixvSongInputTableCell.h"
#import "CLBCustomAlertView.h"
@interface IWantSongViewController ()

@end

@implementation IWantSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"我要预约";
    [self.view addSubview:navBar];
    
    [self download];
}
- (void)download
{
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&ID=%@&PWD=%@",HTTP,CoinBookUrl,self.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        self.corp_name = [[dic objectForKey:@"corp"] objectForKey:@"content_name"];
        self.sub_title = [[dic objectForKey:@"coin"] objectForKey:@"content_name"];
        self.giving = [[dic objectForKey:@"coin"] objectForKey:@"content_sprice"];
        self.total = [[dic objectForKey:@"coin"] objectForKey:@"content_stotal"];
        self.current = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"coin"] objectForKey:@"ye_price"]];
        self.all_yuyue = [[dic objectForKey:@"coin"] objectForKey:@"book_price"];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadFailed];
        [self.view makeToast:NO_NET];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"顺电三里屯店";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        BixvSongDescTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BixvSongDescTableCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BixvSongDescTableCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.row == 2)
    {
        BixvSongInputTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BixvSongInputTableCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BixvSongInputTableCell" owner:self options:nil] lastObject];
            cell.input.delegate = self;
        }
        return cell;
    }
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15, 15, SCREENWIDTH-30, 44);
            btn.center = CGPointMake(SCREENWIDTH/2, 88/2);
            [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
            [btn setTitle:@"我要预约" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"orange_btn"] forState:UIControlStateNormal];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:btn];
            
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 60;
    }
    else if (indexPath.row == 1)
    {
         return 88;
    }
    else if (indexPath.row == 2)
    {
        return 125;
    }
    else
    {
         return 88;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UItextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.number_btc = textField.text;
}

#pragma mark - 确定操作
- (void)sureAction:(UIButton *)sender
{
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&frm[content_num]=%@&ID=%@&PWD=%@",HTTP,CoinBookCommitUrl,self.auto_id,self.number_btc,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"预约成功" message:@"请尽快去消费，以获得赠送。" leftButtonTitle:@"返回继续预约" leftActionBlock:^(CLBCustomAlertView *view) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            alert.titleLabel.textColor = UIColorFromRGB(0x58b76a);
            alert.messageLabel.textColor = UIColorFromRGB(0x919191);
            [alert show];
        }
        else
        {
            [self.view makeToast:[dic objectForKey:@"msg"]];
        }
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator LoadSuccess];
    }];
    
    
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
