//
//  PrepareGoodsViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "PrepareGoodsViewController.h"
#import "PrepareGoodsTableCell.h"
#import "OrderProItem.h"
#import "QrCodeScanningController.h"
#import "OrderListController.h"
#import "CorpOrderDetailViewController.h"
#import "BHBOrderDetailViewController.h"
@interface PrepareGoodsViewController ()

@end

@implementation PrepareGoodsViewController
@synthesize mitem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    if(_is_return)
    {
        navBar.titleLabel.text = @"退货";
    }
    else
    {
        navBar.titleLabel.text = @"发货";
    }
    [self.view addSubview:navBar];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrepareGoodsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PrepareGoodsTableCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PrepareGoodsTableCell" owner:self options:nil] lastObject];
        [cell.scan_btn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchDown];
        [cell.sure_btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchDown];
        [cell.cancel_btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchDown];
    }
    if(_is_return)
    {
        cell.username_tag.text = @"商家:";
        cell.username.text = mitem.corp_name;
        cell.content_address.text = mitem.corp_address;
        cell.consignee.text = mitem.corp_name;
        cell.content_mobile.text = mitem.corp_mobile;
        cell.content_num.text = [[mitem.pros objectAtIndex:_index] content_num];
    }
    else
    {
        cell.username_tag.text = @"买家ID:";
        cell.username.text = mitem.member_user;
        cell.content_address.text = mitem.content_address;
        cell.consignee.text = mitem.content_linkname;
        cell.content_mobile.text = mitem.content_mobile;
        cell.content_num.text = [[mitem.pros objectAtIndex:_index] content_num];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 257;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scanAction:(UIButton *)sender
{
    QrCodeScanningController * qr = [[QrCodeScanningController alloc]initWithNibName:@"QrCodeScanningController" bundle:nil];
    qr.delegate = self;
    qr.is_shouquan = NO;
    [self.navigationController pushViewController:qr animated:YES];
}

#pragma mark - QrCodeScanDelegate
- (void)returnQrCode:(NSString *)code
{
    PrepareGoodsTableCell * cell = (PrepareGoodsTableCell *)[_mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.express_id_textField.text = code;
}
#pragma mark - 操作
- (void)sureAction:(UIButton *)sender
{
    PrepareGoodsTableCell * cell = (PrepareGoodsTableCell *)[_mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if([cell.expressName.text length] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入快递名称" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    else if ([cell.express_id_textField.text length] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入快递单号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    NSString * url = nil;
    if(_is_return)
    {
        url = [NSString stringWithFormat:@"%@%@&auto_id=%@&frm[express_name]=%@&frm[express_no]=%@&ID=%@&PWD=%@",HTTP,ReturnGoodsUrl,[(OrderProItem *)[mitem.pros objectAtIndex:_index] oderpro_id],[cell.expressName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],cell.express_id_textField.text,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@&auto_id=%@&frm[express_name]=%@&frm[express_no]=%@&ID=%@&PWD=%@",HTTP,DeliveryUrl,[mitem auto_id],[cell.expressName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],cell.express_id_textField.text,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    }
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            if(_is_return)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:ReturnGoodsNotification object:nil];//发送退货通知
                
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DeliveryedNotification object:@"2"];//发送发货通知
            }
            
            NSMutableArray * arr = [[NSMutableArray alloc]init];
            for(UIViewController * vc in [self.navigationController viewControllers])
            {
                if([vc isKindOfClass:[CorpOrderDetailViewController class]]||[vc isKindOfClass:[BHBOrderDetailViewController class]])
                {
                    continue;
                }
                [arr addObject:vc];
            }
            
            self.navigationController.viewControllers = arr;
            [self back:nil];
            
        }
        else
        {
            
        }
        [self.view makeToast:[dic objectForKey:@"msg"]];
        [self performSelector:@selector(afterDelay) withObject:nil afterDelay:1.0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
    }];
}
- (void)afterDelay
{
    [self back:nil];
}
- (void)cancelAction:(UIButton *)sender
{
    [self back:nil];
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
