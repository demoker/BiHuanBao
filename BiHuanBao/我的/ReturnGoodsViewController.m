//
//  ReturnGoodsViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/27.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "ReturnGoodsViewController.h"
#import "MerchantNameTableCell.h"
#import "Address2TableViewCell.h"
#import "ReturnGoodsCell.h"
#import "TotalTableViewCell.h"
#import "OrderProItem.h"
@interface ReturnGoodsViewController ()

@end

@implementation ReturnGoodsViewController
@synthesize mitem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"退货详情";
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = BackGround_Color;
    
    [_sure_receipt addTarget:self action:@selector(surereceiptAction:) forControlEvents:UIControlEventTouchDown];
    if([[[UserLoginInfoManager loginmanager] isCorper] integerValue] == 1)
    {
        _sure_receipt.hidden = YES;
    }
    else
    {
        _sure_receipt.hidden = NO;
    }
    
    if([mitem.is_status boolValue])
    {
        _sure_receipt.enabled = NO;
        [_sure_receipt setTitle:@"已签收" forState:UIControlStateNormal];
    }
    else
    {
        _sure_receipt.enabled = YES;
        [_sure_receipt setTitle:@"确认签收" forState:UIControlStateNormal];
    }
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.view addSubview:self.indicator];

    NSLog(@"%@",mitem);
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
        Address2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Address2TableViewCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Address2TableViewCell" owner:self options:nil] lastObject];
        }
        cell.address.text = [mitem.corp_address length]>0?mitem.corp_address:@"无";
        cell.contact.text = mitem.corp_name;
        cell.tel.text = mitem.corp_mobile;
        cell.express_name.text = [NSString stringWithFormat:@"%@ %@",mitem.express_name,mitem.express_no];
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
//        cell.num_tag.hidden = YES;
        cell.order_sn.text = mitem.content_sn;
        cell.order_time.text = mitem.create_time;
        cell.totalnum.text = mitem.content_num;
        cell.order_sn_tag.text = @"退货编号:";
        return cell;
    }
    else
    {
        ReturnGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnGoodsCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnGoodsCell" owner:self options:nil] lastObject];
            cell.bottom_line.hidden = YES;
        }
        
        OrderProItem * pro = [mitem.pros objectAtIndex:indexPath.row-2];
        [cell.content_img setImageWithURL:[NSURL URLWithString:pro.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
        cell.corp_name.text = mitem.corp_name;
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
        return 117;
    }
    else if (indexPath.row == [mitem.pros count]+3-1)
    {
        return 51;
    }
    else
    {
        return 87;
    }
}

#pragma mark - 操作
- (void)cancelAction:(UIButton *)sender
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&orderid=%@&ID=%@*PWD=%@",HTTP,CancelOrderUrl,mitem.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            
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
//    NSString * url = [NSString stringWithFormat:@"%@%@&orderid=%@&ID=%@&PWD=%@",HTTP,CancelOrderUrl,mitem.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
//    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary * dic = (NSDictionary *)responseObject;
//        if([[dic objectForKey:@"status"] integerValue] == 1)
//        {
//            
//        }
//        [self.view makeToast:[dic objectForKey:@"msg"]];
//        [self.indicator LoadSuccess];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self.view makeToast:NO_NET];
//        [self.indicator LoadSuccess];
//    }];
}

- (void)surereceiptAction:(UIButton *)sender
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&orderid=%@&ID=%@&PWD=%@",HTTP,CorpSureReceiptUrl,[[mitem.pros lastObject] oderpro_id],[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            //如若成功修改item的状态值，修改btn title
            
            [_sure_receipt setTitle:@"退货签收成功" forState:UIControlStateNormal];
            _sure_receipt.enabled = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:CorpSureReceiptNotification object:nil];
        }
        [self.indicator LoadSuccess];
        [self.view makeToast:[dic objectForKey:@"msg"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
        [self.view makeToast:NO_NET];
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
