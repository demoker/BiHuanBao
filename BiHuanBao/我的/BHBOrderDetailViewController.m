//
//  BHBOrderDetailViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BHBOrderDetailViewController.h"
#import "MerchantNameTableCell.h"
#import "AddressTableCell.h"
#import "ProductTableCell.h"
#import "TotalTableViewCell.h"
#import "OrderProItem.h"
#import "EvaluateViewController.h"
#import "PrepareGoodsViewController.h"
@interface BHBOrderDetailViewController ()

@end

@implementation BHBOrderDetailViewController
@synthesize mitem;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiverNotification:(NSNotification *)noti
{
    if([noti.name isEqualToString:ReturnGoodsNotification])
    {
        OrderProItem * item = [[mitem pros] objectAtIndex:_index];
        item.is_return = @"1";
        [self update];
    }else if ([noti.name isEqualToString:DeliveryedNotification])
    {
        NSLog(@"%@",noti.userInfo);
    }
    else if ([noti.name isEqualToString:EvaluateOrderNotification])
    {
        OrderProItem * item = [[mitem pros] objectAtIndex:_index];
        item.is_comment = @"1";
        [self update];
    }
    [_mtableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:ReturnGoodsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:DeliveryedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:EvaluateOrderNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"订单详情";
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = BackGround_Color;
    
    [_cancel_btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchDown];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.view addSubview:self.indicator];

    
    [self update];
    
    NSLog(@"%@",mitem);
}
- (void)update
{
    if([mitem.is_paystatus integerValue] == 0)
    {
        if([mitem.is_status integerValue] == 4)
        {
            _cancel_btn.hidden = YES;
            _tip_btn.hidden = YES;
            [_sure_receipt setTitle:@"已取消" forState:UIControlStateNormal];
            _sure_receipt.enabled = NO;
            _sure_receipt.hidden = NO;
            [_sure_receipt setBackgroundImage:[UIImage imageNamed:@"gray_btn_bg"] forState:UIControlStateNormal];
        }
        else
        {
            [_tip_btn setTitle:@"去支付" forState:UIControlStateNormal];
            _sure_receipt.hidden = YES;
            _cancel_btn.hidden = NO;
            _tip_btn.hidden = NO;
            [_tip_btn addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchDown];
        }
    }
    else
    {
        if([mitem.is_status integerValue] == 0)//未处理
        {
            _sure_receipt.hidden = YES;
            _cancel_btn.hidden = NO;
            _tip_btn.hidden = NO;
            
            [_tip_btn setTitle:@"提醒卖家" forState:UIControlStateNormal];
            [_tip_btn addTarget:self action:@selector(tipAction:) forControlEvents:UIControlEventTouchDown];
        }
        else if ([mitem.is_status integerValue] == 1)//待发货
        {
            _sure_receipt.hidden = NO;
            _cancel_btn.hidden = YES;
            _tip_btn.hidden = YES;
            _sure_receipt.enabled = NO;
            [_sure_receipt setTitle:@"待发货" forState:UIControlStateNormal];
            [_sure_receipt setBackgroundImage:[UIImage imageNamed:@"sbyy_orange_btn"] forState:UIControlStateNormal];
        }
        else if ([mitem.is_status integerValue] == 2)//已发货
        {
            _sure_receipt.hidden = NO;
            _cancel_btn.hidden = YES;
            _tip_btn.hidden = YES;
            [_sure_receipt setTitle:@"确认签收" forState:UIControlStateNormal];
            [_sure_receipt setBackgroundImage:[UIImage imageNamed:@"sbyy_green_btn"] forState:UIControlStateNormal];
            [_sure_receipt addTarget:self action:@selector(surereceiptAction:) forControlEvents:UIControlEventTouchDown];
        }
        else if ([mitem.is_status integerValue] == 3)//已签收
        {
            _sure_receipt.hidden = NO;
            _cancel_btn.hidden = YES;
            _tip_btn.hidden = YES;
            [_sure_receipt setTitle:@"已签收" forState:UIControlStateNormal];
            [_sure_receipt setBackgroundImage:[UIImage imageNamed:@"sbyy_green_btn"] forState:UIControlStateNormal];
            _sure_receipt.enabled = NO;
        }
        else if ([mitem.is_status integerValue] == 4)//已取消
        {
            _sure_receipt.hidden = NO;
            _cancel_btn.hidden = YES;
            _tip_btn.hidden = YES;
            [_sure_receipt setTitle:@"已取消" forState:UIControlStateNormal];
            [_sure_receipt setBackgroundImage:[UIImage imageNamed:@"gray_btn_bg"] forState:UIControlStateNormal];
            _sure_receipt.enabled = NO;
        }
        else if ([mitem.is_status integerValue] == 5)//已完成
        {
            _sure_receipt.hidden = NO;
            _cancel_btn.hidden = YES;
            _tip_btn.hidden = YES;
            [_sure_receipt setTitle:@"已完成" forState:UIControlStateNormal];
            [_sure_receipt setBackgroundImage:[UIImage imageNamed:@"sbyy_green_btn"] forState:UIControlStateNormal];
            _sure_receipt.enabled = NO;
        }

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
        cell.corp_name.text = mitem.corp_name;
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
        cell.address.text = [mitem.content_address length]>0?mitem.content_address:@"无";
        [cell.address sizeToFit];
        cell.contact.text = mitem.content_linkname;
        cell.tel.text = mitem.content_mobile;
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
            
            [cell.return_btn addTarget:self action:@selector(returnGoods:) forControlEvents:UIControlEventTouchDown];
            [cell.evaluate_btn addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchDown];
        }
        cell.return_btn.tag = 1000+indexPath.row;
        cell.evaluate_btn.tag = 10000+indexPath.row;
        if(indexPath.row == [mitem.pros count]+3-2)
        {
            cell.bottom_line.hidden = YES;
        }
        else
        {
            cell.bottom_line.hidden = NO;
        }
        if([mitem.is_status integerValue] == 3||[mitem.is_status integerValue] == 5)
        {
            cell.return_btn.hidden = NO;
            cell.evaluate_btn.hidden = NO;
        }
        else
        {
            cell.return_btn.hidden = YES;
            cell.evaluate_btn.hidden = YES;
        }
        OrderProItem * pro = [mitem.pros objectAtIndex:indexPath.row-2];
        
        if([pro.is_return boolValue])
        {
            cell.return_btn.enabled = NO;
            [cell.return_btn setTitle:@"已退货" forState:UIControlStateNormal];
        }
        else
        {
            cell.return_btn.enabled = YES;
        }
        
        if([pro.is_comment boolValue])
        {
            cell.evaluate_btn.enabled = NO;
            [cell.evaluate_btn setTitle:@"已评价" forState:UIControlStateNormal];
        }
        else
        {
            cell.evaluate_btn.enabled = YES;
        }
        
        
        [cell.content_img setImageWithURL:[NSURL URLWithString:pro.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
        cell.content_name.text = pro.content_name;
        cell.content_price.text = pro.single_price;
        cell.content_num.text = pro.content_num;
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

#pragma mark - 操作
- (void)cancelAction:(UIButton *)sender
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&orderid=%@&ID=%@&PWD=%@",HTTP,CancelOrderUrl,mitem.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            mitem.is_status = @"4";
            [self update];
            [[NSNotificationCenter defaultCenter] postNotificationName:CancelOrderNotification object:nil];
        }
        [self.view makeToast:[dic objectForKey:@"msg"]];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator LoadSuccess];
    }];
    
}
- (void)tipAction:(UIButton *)sender
{
    [self.indicator startAnimatingActivit];
    NSLog(@"提醒卖家");
}

- (void)returnGoods:(UIButton *)sender
{
    //跳转到申请退货界面
    self.index = [sender tag]-1000-2;
    PrepareGoodsViewController * goods = [[PrepareGoodsViewController alloc]initWithNibName:@"PrepareGoodsViewController" bundle:nil];
    goods.is_return = YES;
    goods.mitem = [[OrderItem alloc]init];
    goods.mitem = mitem;
    goods.index = self.index;
    [self.navigationController pushViewController:goods animated:YES];
}
- (void)evaluate:(UIButton *)sender
{
    //跳转到评价界面
    int n = [sender tag]-10000-2;
    EvaluateViewController * evaluate = [[EvaluateViewController alloc]initWithNibName:@"EvaluateViewController" bundle:nil];
    evaluate.is_order = YES;
    evaluate.mitem = [[OrderProItem alloc]init];
    evaluate.mitem = [mitem.pros objectAtIndex:n];
    evaluate.content_type = @"com_shopProduct";
    [self.navigationController pushViewController:evaluate animated:YES];
}
- (void)surereceiptAction:(UIButton *)sender
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&orderid=%@&ID=%@&PWD=%@",HTTP,SureReceiptUrl,mitem.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            mitem.is_status = @"3";
            [self update];
            [_mtableview reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SureReceiptNotification object:nil];
        }
        else
        {
            
        }
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
        [self.view makeToast:NO_NET];
    }];
}

- (void)goPay:(id)sender
{
    //去支付
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
