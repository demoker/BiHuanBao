//
//  MyBiDestineController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/10.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "MyBiDestineController.h"
#import "MyBiDestineTableCell.h"
#import "MyBiDestineTableViewCell.h"
#import "SongBiItem.h"
#import "QrCodeScanningController.h"
@interface MyBiDestineController ()

@end

@implementation MyBiDestineController
@synthesize dataarray;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    is_close = YES;
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:ShouQuanSuccessNotification object:nil];
    
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"送币预约";
    [navBar.homebtn.imageView setFrame:CGRectMake(10, 0, 0, 0)];
    [navBar.homebtn setTitle:@"扫描" forState:UIControlStateNormal];
    
    [self.view addSubview:navBar];
    dataarray = [[NSMutableArray alloc]init];
    more = 1;
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    self.selectedIndexpath = [[NSIndexPath alloc]init];
    
    [self download];
}

- (void)receiverNotification:(NSNotification *)noti
{
    if([noti.name isEqual:ShouQuanSuccessNotification])
    {
        more = 1;
        [self download];
    }
}
- (void)download
{
    NSString * url = [NSString stringWithFormat:@"%@%@&per=1&row=10&page=%d&ID=%@&PWD=%@",HTTP,PersonalBiDestineListUrl,more,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(more == 1)
        {
            [dataarray removeAllObjects];
        }
        
        NSDictionary * dic = (NSDictionary *)responseObject;
        for(NSDictionary * dict in [dic objectForKey:@"datalist"])
        {
            SongBiItem * item = [[SongBiItem alloc]init];
//            @property (retain, nonatomic) NSString * auto_id;//预约表示
//            @property (retain, nonatomic) NSString * content_status;//是否接收
//            @property (retain, nonatomic) NSString * content_num;//预定金额
//            @property (retain, nonatomic) NSString * true_num;//实际接收金额
//            @property (retain, nonatomic) NSString * corp_name;
//            @property (retain, nonatomic) NSString * corp_address;
//            @property (retain, nonatomic) NSString * corp_mobile;
//            @property (retain, nonatomic) NSString * corp_linkname;
//            @property (retain, nonatomic) NSString * content_name;//活动名称
//            @property (retain, nonatomic) NSString * content_stotal;//送出总额
//            @property (retain, nonatomic) NSString * true_price;//实际送出总额
//            
//            @property (retain, nonatomic) NSString * book_price;//累计预约
//            @property (retain, nonatomic) NSString * content_activity;//是否活动中
            item.content_status = [dict objectForKey:@"content_status"];
            item.auto_id = [dict objectForKey:@"auto_id"];
            item.content_num = [dict objectForKey: @"content_num"];
            item.true_num = [dict objectForKey:@"true_num"];
            item.corp_name = [[dict objectForKey:@"corp"] objectForKey:@"content_name"];
            item.corp_address = [[dict objectForKey:@"corp"] objectForKey:@"content_address"];
            item.corp_mobile = [[dict objectForKey:@"corp"] objectForKey:@"content_mobile"];
            item.corp_linkname = [[dict objectForKey:@"corp"] objectForKey:@"content_linkname"];
            item.content_stotal = [[dict objectForKey:@"coin"] objectForKey:@"content_stotal"];
            item.true_price = [[dict objectForKey:@"coin"] objectForKey:@"true_price"];
            item.book_price = [[dict objectForKey:@"coin"] objectForKey:@"book_price"];
            item.content_name = [[dict objectForKey:@"coin"] objectForKey:@"content_name"];
            item.content_activity = [[dict objectForKey:@"coin"] objectForKey:@"content_status"];
            [dataarray addObject:item];
        }
        [_mtableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataarray count]*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        SongBiItem * item = [dataarray objectAtIndex:indexPath.row/2];
        NSLog(@"++++%@",self.selectedIndexpath);
        if(indexPath.section == self.selectedIndexpath.section&&indexPath.row == self.selectedIndexpath.row)
        {
            MyBiDestineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyBiDestineTableViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyBiDestineTableViewCell" owner:self options:nil] lastObject];
                [cell.souqi_btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchDown];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
            }
            cell.corp_name.text = item.corp_name;
            cell.address.text = item.corp_address;
            cell.tel.text = item.corp_mobile;
            cell.site.text = item.corp_linkname;
            
            cell.desc.text = item.content_name;
            cell.destine_num.text = [NSString stringWithFormat:@"预约:%@ BTC",item.content_num];
            cell.total.text = item.content_stotal;
            cell.yjsc_num.text = item.true_price;
            cell.ljyy_num.text = item.book_price;
            
            cell.cover_bg.backgroundColor = [cell.cover_bg.backgroundColor colorWithAlphaComponent:0.7];
            [cell.cancel_btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchDown];
            
            if([item.content_activity integerValue] == 1)//2
            {//0xfb5120橙色
                [cell.bg_img setImage:[UIImage imageNamed:@"sbyy_orange_big_bg"]];
                [cell.line1 setImage:[UIImage imageNamed:@"sbyy_orange_line"]];
                [cell.line2 setImage:[UIImage imageNamed:@"sbyy_orange_line"]];
                [cell.cancel_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_orange_btn"] forState:UIControlStateNormal];
                [cell.souqi_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_orange_souqi"] forState:UIControlStateNormal];
                cell.cover_bg.hidden = NO;
                cell.result_desc.text = @"活动已经结束";
                [cell.result_icon setImage:[UIImage imageNamed:@"sbyy_orange_delete"]];
                cell.destine_num.textColor = UIColorFromRGB(0xff602a);
            }
            else if ([item.content_status integerValue] == 1)//4
            {
                [cell.bg_img setImage:[UIImage imageNamed:@"sbyy_green_big_bg"]];
                [cell.line1 setImage:[UIImage imageNamed:@"sbyy_green_line"]];
                [cell.line2 setImage:[UIImage imageNamed:@"sbyy_green_line"]];
                [cell.cancel_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_green_btn"] forState:UIControlStateNormal];
                [cell.souqi_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_green_souqi"] forState:UIControlStateNormal];
                
                cell.cover_bg.hidden = NO;
                cell.result_desc.text = @"已经成功接收赠送";
                [cell.result_icon setImage:[UIImage imageNamed:@"sbyy_green_ok"]];
                
                cell.destine_num.textColor = UIColorFromRGB(0x57ac68);
            }
            else //6
            {

                [cell.bg_img setImage:[UIImage imageNamed:@"sbyy_orange_big_bg"]];
                [cell.line1 setImage:[UIImage imageNamed:@"sbyy_orange_line"]];
                [cell.line2 setImage:[UIImage imageNamed:@"sbyy_orange_line"]];
                [cell.cancel_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_orange_btn"] forState:UIControlStateNormal];
                [cell.souqi_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_orange_souqi"] forState:UIControlStateNormal];
                cell.destine_num.textColor = UIColorFromRGB(0xff602a);
                cell.cover_bg.hidden = YES;
            }

            
            return cell;
        }
        else
        {
            MyBiDestineTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyBiDestineTableCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyBiDestineTableCell" owner:self options:nil] lastObject];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                [cell.delete_btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchDown];
            }
            cell.corp_name.text = item.corp_name;
            cell.delete_btn.tag = 1000+indexPath.row/2;
            if([item.content_activity integerValue] == 1)//2
            {//0xfb5120橙色
                
                [cell.bg_img setImage:[UIImage imageNamed:@"sbyy_orange_bg"]];
                [cell.delete_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_orange_delete_icon"] forState:UIControlStateNormal];
                [cell.corp_name setTextColor:UIColorFromRGB(0xfb5120)];
                cell.content_result.text = @"活动已经停止";
                if(is_close)
                {
                    cell.delete_btn.hidden = NO;
                }
                else
                {
                    cell.delete_btn.hidden = YES;
                }
                
            }
            else if ([item.content_status integerValue] == 1)//4
            {
                [cell.bg_img setImage:[UIImage imageNamed:@"sbyy_green_bg"]];
                [cell.delete_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_green_delete_icon"] forState:UIControlStateNormal];
                [cell.corp_name setTextColor:UIColorFromRGB(0x58ad68)];
                cell.content_result.text = @"接收赠送成功";
                cell.delete_btn.hidden = YES;
            }
            else //6
            {
                [cell.bg_img setImage:[UIImage imageNamed:@"sbyy_gray_bg"]];
                [cell.delete_btn setBackgroundImage:[UIImage imageNamed:@"sbyy_orange_delete_icon"] forState:UIControlStateNormal];
                [cell.corp_name setTextColor:UIColorFromRGB(0x787878)];
                cell.content_result.text = @"";
                if(is_close)
                {
                    cell.delete_btn.hidden = NO;
                }
                else
                {
                    cell.delete_btn.hidden = YES;
                }

            }
            
                return cell;
        }
    }
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2==0)
    {
        if(indexPath.section == self.selectedIndexpath.section&&indexPath.row == self.selectedIndexpath.row)
        {
            return 297;
        }
        else
        {
            return 40;
        }
    }
    else
    {
        return 10;
    }
}
#pragma mark - 收起
- (void)closeAction:(UIButton *)sender
{
//    MyBiDestineTableViewCell * cell = (MyBiDestineTableViewCell *)[_mtableview cellForRowAtIndexPath:self.selectedIndexpath];
    is_close = YES;
    self.selectedIndexpath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    [_mtableview reloadData];
}
- (void)deleteAction:(UIButton *)sender
{
    int n = [sender tag]-1000;
    SongBiItem * item = [dataarray objectAtIndex:n];
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&autoid=%@&ID=%@&PWD=%@",HTTP,PersonalBiCancelUrl,item.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            more = 1;
            self.selectedIndexpath = [NSIndexPath indexPathForRow:-1 inSection:-1];
            [self download];
        }
        [self.indicator LoadSuccess];
        [self.view makeToast:[dic objectForKey:@"msg"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator LoadSuccess];
    }];

}
- (void)cancelAction:(UIButton *)sender
{
    SongBiItem * item = [dataarray objectAtIndex:self.selectedIndexpath.row/2];
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&autoid=%@&ID=%@&PWD=%@",HTTP,PersonalBiCancelUrl,item.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            more = 1;
            [self download];
        }
        [self.indicator LoadSuccess];
        [self.view makeToast:[dic objectForKey:@"msg"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator LoadSuccess];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    is_close = NO;
    self.selectedIndexpath = indexPath;
    NSLog(@"===%@",self.selectedIndexpath);
    [tableView reloadData];
}

- (void)home:(id)sender
{
    QrCodeScanningController * scan = [[QrCodeScanningController alloc]initWithNibName:@"QrCodeScanningController" bundle:nil];
    [self.navigationController pushViewController:scan animated:YES];
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
