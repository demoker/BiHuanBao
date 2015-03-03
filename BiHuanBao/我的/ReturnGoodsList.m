//
//  ReturnGoodsList.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/27.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "ReturnGoodsList.h"
#import "OrderItem.h"
#import "OrderProItem.h"
#import "ReturnGoodsCell.h"
#import "ReturnGoodsViewController.h"
#import "OrderListController.h"
@interface ReturnGoodsList ()

@end

@implementation ReturnGoodsList
@synthesize dataarray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataarray = [[NSMutableArray alloc]init];
    
//    self.indicator = [[ActivityIndicator alloc] initWithFrame:_mtableview.frame LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
//    [self.indicator startAnimatingActivit];
//    [self.view addSubview:self.indicator];
    more = 1;
    _mtableview.pullDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:CorpSureReceiptNotification object:nil];
   
}

- (void)receiverNotification:(NSNotification *)noti
{
    if([noti.name isEqualToString:CorpSureReceiptNotification])
    {
        [self refresh];
    }
}

- (void)refresh
{
    more = 1;
    [self download];
}

- (void)download
{
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
            item.content_sn = [dict objectForKey:@"content_sn"];
            item.content_status = [dict objectForKey:@"content_status"];
//            item.content_linkname = [dict objectForKey:@"content_linkname"];
//            item.content_address = [dict objectForKey:@"content_address"];
//            item.content_mobile = [dict objectForKey:@"content_mobile"];
            item.content_total = [dict objectForKey:@"total_price"];
            item.express_name = [dict objectForKey:@"express_name"];
            item.express_no = [dict objectForKey:@"express_no"];
            item.create_time = [dict objectForKey:@"create_time"];
            
            item.corp_name = [[dict objectForKey:@"corp"] objectForKey:@"content_name"];
            item.corp_linkname = [dict objectForKey:@"corp_linkname"];
            item.corp_address = [[dict objectForKey:@"corp"] objectForKey:@"corp_address"];
            item.corp_mobile = [[dict objectForKey:@"corp"] objectForKey:@"corp_mobile"];
            
            item.is_status = [dict objectForKey:@"is_status"];
            
          OrderProItem * pro = [[OrderProItem alloc]init];
                pro.auto_id = [dict objectForKey:@"auto_id"];
                pro.content_img = [dict objectForKey:@"content_img"];
                pro.content_name = [dict objectForKey:@"content_name"];
                pro.content_num = [dict objectForKey:@"content_num"];
                pro.single_price = [dict objectForKey:@"content_price"];
                pro.oderpro_id = [dict objectForKey:@"order_id"];
                [item.pros addObject:pro];
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
        OrderItem * item = [dataarray count]?[dataarray objectAtIndex:indexPath.row/2]:nil;
            ReturnGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnGoodsCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnGoodsCell" owner:self options:nil] lastObject];
            }
            cell.corp_name.text = item.corp_name;
            cell.content_name.text = [(OrderProItem *)[item.pros lastObject] content_name];
            [cell.content_img setImageWithURL:[NSURL URLWithString:[(OrderProItem *)[item.pros objectAtIndex:0] content_img]] placeholderImage:[UIImage imageNamed:@"no_phote"]];
            cell.content_price.text = [(OrderProItem *)[item.pros lastObject] single_price];
            cell.content_num.text = [(OrderProItem *)[item.pros lastObject] content_num];
            return cell;
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
        return 87;
    }
    else
    {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReturnGoodsViewController * detail = [[ReturnGoodsViewController alloc]initWithNibName:@"ReturnGoodsViewController" bundle:nil];
    detail.mitem = [[OrderItem alloc]init];
    detail.mitem = [dataarray objectAtIndex:indexPath.row/2];
    [[(OrderListController*)self.delegate navigationController] pushViewController:detail animated:YES];
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
