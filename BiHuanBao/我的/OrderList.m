//
//  OrderList.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/22.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "OrderList.h"
#import "OrderListOneProCell.h"
#import "OrderListThreeProCell.h"
#import "BHBOrderDetailViewController.h"
#import "OrderListController.h"
#import "OrderItem.h"
#import "OrderProItem.h"
#import "CorpOrderDetailViewController.h"
@interface OrderList ()

@end

@implementation OrderList
@synthesize dataarray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataarray = [[NSMutableArray alloc]init];
    
//    self.indicator = [[ActivityIndicator alloc] initWithFrame:self.view.bounds LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
//    [self.indicator startAnimatingActivit];
//    [self.view addSubview:self.indicator];
    more = 1;
    _mtableview.pullDelegate = self;
    
}
- (void)refresh
{
    more = 1;
    [self download];
}

- (void)download
{
    NSLog(@"%@",self.indicator);
    
    if(more == 1)
    {
        [self.indicator startAnimatingActivit];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@&app_com=%@&task=%@&per=1&page=%d&row=10&ID=%@&PWD=%@",HTTP,OrderListUrl,self.app_com,self.task,more,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(more == 1)
        {
            [dataarray removeAllObjects];
            [_mtableview setPullTableIsRefreshing:NO];
        }
        else
        {
            [_mtableview setPullTableIsLoadingMore:NO];
        }
        NSDictionary * dic = (NSDictionary *)responseObject;
        for(NSDictionary * dict in [dic objectForKey:@"datalist"])
        {
            OrderItem * item = [[OrderItem alloc]init];
            item.auto_id = [dict objectForKey:@"auto_id"];
            item.content_sn = [dict objectForKey:@"content_sn"];
            item.content_status = [dict objectForKey:@"content_status"];
            item.content_linkname = [dict objectForKey:@"content_linkname"];
            item.content_address = [dict objectForKey:@"content_address"];
            item.content_mobile = [dict objectForKey:@"content_mobile"];
            item.is_pay = [dict objectForKey:@"is_pay"];
            item.is_status = [dict objectForKey:@"is_status"];
            item.is_paystatus = [dict objectForKey:@"is_paystatus"];
            item.member_user = [dict objectForKey:@"member_user"];
            item.content_total = [dict objectForKey:@"content_total"];
            item.express_name = [dict objectForKey:@"express_name"];
            item.express_no = [dict objectForKey:@"express_no"];
            item.create_time = [dict objectForKey:@"create_time"];
            item.corp_name = [[dict objectForKey:@"corp"] objectForKey:@"content_name"];
            item.corp_linkname = [dict objectForKey:@"corp_linkname"];
            item.corp_address = [dict objectForKey:@"corp_address"];
            item.corp_mobile = [dict objectForKey:@"corp_mobile"];
            
            int n = 0;
            for(NSDictionary * d in [dict objectForKey:@"pros"])
            {
                OrderProItem * pro = [[OrderProItem alloc]init];
                pro.auto_id = [d objectForKey:@"auto_id"];
                pro.product_id = [d objectForKey:@"product-id"];
                 pro.content_img = [d objectForKey:@"content_img"];
                 pro.content_name = [d objectForKey:@"content_name"];
                 pro.content_num = [d objectForKey:@"content_num"];
                 pro.single_price = [d objectForKey:@"single_price"];
                 pro.oderpro_id = [d objectForKey:@"orderpro_id"];
                 pro.is_comment = [d objectForKey:@"is_comment"];
                 pro.is_return = [d objectForKey:@"is_return"];
                [item.pros addObject:pro];
                
                n+=[pro.content_num integerValue];
            }
            item.content_num = [NSString stringWithFormat:@"%d",n];
            [dataarray addObject:item];
        }
        if([[dic objectForKey:@"datalist"] count]==0&&more>1)
        {
            more --;
            [self.view makeToast:NO_MORE_DATA];
        }
        
        if([dataarray count]!=0)
        {
            [_mtableview reloadData];
           [self.indicator LoadSuccess];
        }
        else
        {
            [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:NO_DATA_DESC];
        }
        NSLog(@"%@",dataarray);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(more == 1)
        {
            [self.indicator LoadFailed];
        }
        else
        {
            more --;
            [self.view makeToast:NO_NET];
        }

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataarray count]*2;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2==0)
    {
        OrderItem * item = [dataarray count]>0?[dataarray objectAtIndex:indexPath.row/2]:nil;
        if([item.pros count]>=3)
        {
            OrderListThreeProCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListThreeProCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListThreeProCell" owner:self options:nil] lastObject];
            }
            
            if([dataarray count]!=0)
            {
                cell.corp_name.text = item.corp_name;
                [cell.content_img1 setImageWithURL:[NSURL URLWithString:[(OrderProItem *)[item.pros objectAtIndex:0] content_img]] placeholderImage:[UIImage imageNamed:@"no_phote"]];
                [cell.content_img2 setImageWithURL:[NSURL URLWithString:[(OrderProItem *)[item.pros objectAtIndex:1] content_img]] placeholderImage:[UIImage imageNamed:@"no_phote"]];
                [cell.content_img3 setImageWithURL:[NSURL URLWithString:[(OrderProItem *)[item.pros objectAtIndex:2] content_img]] placeholderImage:[UIImage imageNamed:@"no_phote"]];
                cell.content_total.text = item.content_total;
                cell.content_num.text = item.content_num;
                cell.content_sn.text = item.content_sn;
                cell.create_time.text = item.create_time;
                cell.order_state.text = item.content_status;
            }
            return cell;
        }
        else
        {
            OrderListOneProCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListOneProCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListOneProCell" owner:self options:nil] lastObject];
            }
            if([dataarray count]!=0)
            {
                cell.corp_name.text = item.corp_name;
                [cell.content_img setImageWithURL:[NSURL URLWithString:[(OrderProItem *)[item.pros objectAtIndex:0] content_img]] placeholderImage:[UIImage imageNamed:@"no_phote"]];
                cell.content_total.text = item.content_total;
                cell.content_num.text = item.content_num;
                cell.content_sn.text = item.content_sn;
                cell.create_time.text = item.create_time;
                cell.order_state.text = item.content_status;
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
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        OrderItem * item = [dataarray count]!=0?[dataarray objectAtIndex:indexPath.row/2]:nil;
        if([item.pros count]>=3)
        {
            return 174;
        }
        else
        {
            return 85;
        }
        
    }
    else
    {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.app_com isEqualToString:@"com_ccenter"])
    {
        CorpOrderDetailViewController * detail = [[CorpOrderDetailViewController alloc]initWithNibName:@"CorpOrderDetailViewController" bundle:nil];
        detail.mitem = [[OrderItem alloc]init];
        detail.mitem = [dataarray objectAtIndex:indexPath.row/2];
        [[(OrderListController*)self.delegate navigationController] pushViewController:detail animated:YES];
    }
    else
    {
        BHBOrderDetailViewController * detail = [[BHBOrderDetailViewController alloc]initWithNibName:@"BHBOrderDetailViewController" bundle:nil];
        detail.mitem = [[OrderItem alloc]init];
        detail.mitem = [dataarray objectAtIndex:indexPath.row/2];
        [[(OrderListController*)self.delegate navigationController] pushViewController:detail animated:YES];
    }
   
}

#pragma mark - TableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{
    more++;
    [self download];
}
- (void)pullTableViewDidTriggerRefresh:(TableView *)pullTableView
{
    more = 1;
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
