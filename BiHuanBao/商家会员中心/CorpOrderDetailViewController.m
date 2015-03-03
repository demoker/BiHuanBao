//
//  CorpOrderDetailViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "CorpOrderDetailViewController.h"
#import "MerchantNameTableCell.h"
#import "AddressTableCell.h"
#import "ProductTableCell.h"
#import "TotalTableViewCell.h"
#import "OrderProItem.h"
#import "PrepareGoodsViewController.h"
@interface CorpOrderDetailViewController ()

@end

@implementation CorpOrderDetailViewController
@synthesize mitem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"订单详情";
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = BackGround_Color;
    
    [_stockup_btn addTarget:self action:@selector(stockupAction:) forControlEvents:UIControlEventTouchDown];
    
    if([mitem.is_status isEqual:@"0"])
    {
        [_stockup_btn setTitle:@"开始备货" forState:UIControlStateNormal];
        _stockup_btn.enabled = YES;
    }
    else if([mitem.is_status isEqual:@"1"])
    {
        [_stockup_btn setTitle:@"发货" forState:UIControlStateNormal];
        _stockup_btn.enabled = YES;
        _markLabel.hidden = YES;
    }
    else if([mitem.is_status isEqual:@"2"])
    {
        [_stockup_btn setTitle:@"待签收" forState:UIControlStateNormal];
        _stockup_btn.enabled = NO;
        _markLabel.hidden = YES;
    }
    else if([mitem.is_status isEqual:@"3"])
    {
        [_stockup_btn setTitle:@"已签收" forState:UIControlStateNormal];
        _stockup_btn.enabled = NO;
        _markLabel.hidden = YES;
    }
    else if([mitem.is_status isEqual:@"4"])
    {
        [_stockup_btn setTitle:@"已取消" forState:UIControlStateNormal];
        _stockup_btn.enabled = NO;
        _markLabel.hidden = YES;
    }
    else if([mitem.is_status isEqual:@"5"])
    {
        [_stockup_btn setTitle:@"已完成" forState:UIControlStateNormal];
        _stockup_btn.enabled = NO;
        _markLabel.hidden = YES;
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mitem.pros count]+3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        MerchantNameTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantNameTableCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MerchantNameTableCell" owner:self options:nil] lastObject];
        }
        cell.tag_label.text = @"买家:";
        cell.corp_name.text = mitem.member_user;
        cell.order_state.text = mitem.content_status;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        AddressTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressTableCell" owner:self options:nil] lastObject];
        }
        cell.address.text = [mitem.content_address length] == 0?@"无":mitem.content_address;
        cell.contact.text = mitem.content_linkname;
        cell.tel.text = mitem.content_mobile;
        [cell.address sizeToFit];
        return cell;
    }
    else if(indexPath.row == [mitem.pros count]+3-1)
    {
        TotalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TotalTableViewCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TotalTableViewCell" owner:self options:nil] lastObject];
        }
        cell.totalmoney.text = mitem.content_total;
        cell.totalnum.text = mitem.content_num;
        cell.order_sn.text = mitem.content_sn;
        cell.order_time.text = mitem.create_time;
        return cell;
    }
    else
    {
        ProductTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProductTableCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductTableCell" owner:self options:nil] lastObject];
        }
        
        if(indexPath.row == [mitem.pros count]+3-2)
        {
            cell.bottom_line.hidden = YES;
        }
        else
        {
            cell.bottom_line.hidden = NO;
        }
        OrderProItem * pro = [mitem.pros objectAtIndex:indexPath.row-2];
        [cell.content_img setImageWithURL:[NSURL URLWithString:pro.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
        cell.content_name.text = pro.content_name;
        cell.content_price.text = pro.single_price;
        cell.content_num.text = pro.content_num;
        
        cell.return_btn.hidden = YES;
        cell.evaluate_btn.hidden = YES;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 38;
    }
    else if (indexPath.row == 1)
    {
        CGSize size = [mitem.content_address getcontentsizeWithfont:[UIFont boldSystemFontOfSize:14] constrainedtosize:CGSizeMake(SCREENWIDTH-90, 80) linemode:NSLineBreakByWordWrapping];
        
        return size.height+60>76?size.height+60:76;
    }
    else if (indexPath.row == [mitem.pros count]+3-1)
    {
        return 51;
    }
    else
    {
        return 93;
    }
}

- (void)stockupAction:(UIButton *)sender
{
    NSString * url = nil;
    if([_stockup_btn.titleLabel.text isEqualToString:@"开始备货"])
    {
        url = [NSString stringWithFormat:@"%@%@&orderid=%@&ID=%@&PWD=%@",HTTP,ChangeOrderStateStock,mitem.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
        [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            if([[dic objectForKey:@"status"] integerValue] == 1)
            {
                //如若成功修改item的状态值，修改btn title
                
                [_stockup_btn setTitle:@"发货" forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter] postNotificationName:StockedUpNotification object:nil];
                _markLabel.hidden = YES;
            }
            [self.indicator LoadSuccess];
            [self.view makeToast:[dic objectForKey:@"msg"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.indicator LoadSuccess];
            [self.view makeToast:NO_NET];
        }];
    }
    else
    {
        PrepareGoodsViewController * prepare = [[PrepareGoodsViewController alloc]initWithNibName:@"PrepareGoodsViewController" bundle:nil];
        prepare.mitem = [[OrderItem alloc]init];
        prepare.mitem = self.mitem;
        prepare.is_return = NO;
        [self.navigationController pushViewController:prepare animated:YES];
    }
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
