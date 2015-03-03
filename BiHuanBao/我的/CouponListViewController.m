//
//  CouponListViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/9.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponListCollectionCell.h"
#import "CouponDetailViewController.h"
#import "MyCouponViewController.h"
#import "CouponListItem.h"
#import "EvaluateViewController.h"
#import "MyFlowLayout.h"
#import "CouponListCellView.h"
@interface CouponListViewController ()

@end

@implementation CouponListViewController
@synthesize dataarray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataarray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    _mtableview.pullDelegate = self;
    
   

    more = 1;
    [self download];
}
- (void)download
{
    NSString * url = [NSString stringWithFormat:@"%@%@&task=%@&ID=%@&PWD=%@&per=1&row=10&page=%d",HTTP,UserMyCouponUrl,self.task,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd],more];
    if(more == 1)
    {
        
    }
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if(more == 1)
        {
            [_mtableview setPullTableIsRefreshing:NO];
            [dataarray removeAllObjects];
        }
        for(NSDictionary * dict in [dic objectForKey:@"datalist"])
        {
            CouponListItem * item = [[CouponListItem alloc]init];
            item.content_name = [dict objectForKey:@"content_name"];
            item.content_img = [dict objectForKey:@"content_img"];
            item.s_code = [dict objectForKey:@"s_code"];
            item.shop_type = [dict objectForKey:@"shop_type"];
            item.is_use = [dict objectForKey:@"is_use"];
            item.is_comment = [dict objectForKey:@"is_comment"];
            item.auto_id = [dict objectForKey:@"auto_id"];
            item.product_id = [dict objectForKey:@"product_id"];
            item.is_return = [dict objectForKey:@"is_return"];
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

        [_mtableview reloadData];
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
#pragma mark - UICollectionViewDelegate
#pragma mark - UItableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([dataarray count]%3==0)
    {
        return [dataarray count]/3;
    }
    else
    {
        return [dataarray count]/3+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=0;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        for(int i = 0;i<3;i++)
        {
            CouponListCellView * view = [[[NSBundle mainBundle] loadNibNamed:@"CouponListCellView" owner:self options:nil] lastObject];
            int width = (SCREENWIDTH-3*100)/4;
            view.tag = 100+i;
            view.layer.borderColor = UIColorFromRGB(0xc9c9c9).CGColor;
            view.layer.borderWidth = 1;
            view.frame = CGRectMake(width+(100+width)*(i%3), 0, 100, 180);
            view.backgroundColor=[UIColor whiteColor];
            [cell.contentView addSubview:view];
            
             UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToQuanFinal:)];
            view.content_img.userInteractionEnabled = YES;
            [view.content_img addGestureRecognizer:tap];
        }
    }
        CouponListCellView * view1 = (CouponListCellView *)[cell.contentView viewWithTag:100];
        CouponListCellView * view2 = (CouponListCellView *)[cell.contentView viewWithTag:101];
        CouponListCellView * view3 = (CouponListCellView *)[cell.contentView viewWithTag:102];

        view1.content_img.tag = indexPath.row*100+0;
        view2.content_img.tag = indexPath.row*100+1;
        view3.content_img.tag = indexPath.row*100+2;
    
        if ([dataarray count]%3==1&&indexPath.row == [dataarray count]/3) {
            view1.hidden = NO;
            view2.hidden = YES;
            view3.hidden = YES;
            CouponListItem * item1 = [dataarray objectAtIndex:indexPath.row*3];
            [self setCouponListCellView:view1 WithItem:item1 indexpath:indexPath index:3];
        }
        else if ([dataarray count]%3==2&&indexPath.row == [dataarray count]/3)
        {
            view1.hidden = NO;
            view2.hidden = NO;
            view3.hidden = YES;
            CouponListItem * item1 = [dataarray objectAtIndex:indexPath.row*3];
            CouponListItem * item2 = [dataarray objectAtIndex:indexPath.row*3+1];
            [self setCouponListCellView:view1 WithItem:item1 indexpath:indexPath index:3];
            [self setCouponListCellView:view2 WithItem:item2 indexpath:indexPath index:4];
        }
        else
        {
            view1.hidden = NO;
            view2.hidden = NO;
            view3.hidden = NO;
            
            CouponListItem * item1 = [dataarray objectAtIndex:indexPath.row*3];
            CouponListItem * item2 = [dataarray objectAtIndex:indexPath.row*3+1];
            CouponListItem * item3 = [dataarray objectAtIndex:indexPath.row*3+2];
            
            [self setCouponListCellView:view1 WithItem:item1 indexpath:indexPath index:3];
            [self setCouponListCellView:view2 WithItem:item2 indexpath:indexPath index:4];
            [self setCouponListCellView:view3 WithItem:item3 indexpath:indexPath index:5];
        }
    
    return cell;
}

- (void)setCouponListCellView:(CouponListCellView *)listcellview WithItem:(CouponListItem *)item indexpath:(NSIndexPath *)indexPath index:(int)index
{
    
    
    if(![item.is_use boolValue])//还没有使用
    {
        if(![item.is_return boolValue])//还未退
        {
            [listcellview.operation_btn setTitle:@"退货" forState:UIControlStateNormal];
            [listcellview.operation_btn setBackgroundImage:[UIImage imageNamed:@"orange_btn_bg"] forState:UIControlStateNormal];
            listcellview.operation_btn.tag = 10000*indexPath.row+index;
            [listcellview.operation_btn addTarget:self action:@selector(refund:) forControlEvents:UIControlEventTouchDown];
            listcellview.operation_btn.enabled = YES;
        }
        else//已经退了
        {
            [listcellview.operation_btn setTitle:@"已退货" forState:UIControlStateNormal];
            [listcellview.operation_btn setBackgroundImage:nil forState:UIControlStateNormal];
            listcellview.operation_btn.enabled = NO;
        }
//        listcellview.layer.borderColor = UIColorFromRGB(0xc9c9c9).CGColor;
        [listcellview.operation_btn setTitleColor:UIColorFromRGB(0xc9c9c9) forState:UIControlStateNormal];
        listcellview.evaluate_state.hidden = YES;
    }
    else//已经使用
    {
        if([item.is_comment boolValue])//已经评论
        {
            listcellview.evaluate_state.userInteractionEnabled = NO;
            listcellview.evaluate_state.text = @"已评论";
        }
        else//未评论
        {
            listcellview.evaluate_state.userInteractionEnabled = YES;
            listcellview.evaluate_state.text = @"去评论";
            listcellview.evaluate_state.tag = 1000*indexPath.row+index+3;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goEvaluate:)];
            [listcellview.evaluate_state addGestureRecognizer:tap];
        }
//        listcellview.layer.borderColor = UIColorFromRGB(0xbbdabf).CGColor;
        [listcellview.operation_btn setTitleColor:UIColorFromRGB(0x31ad51) forState:UIControlStateNormal];
        [listcellview.operation_btn setTitle:@"已使用" forState:UIControlStateNormal];
        listcellview.evaluate_state.hidden = NO;
    }
    [listcellview.content_img setImageWithURL:[NSURL URLWithString:item.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
    listcellview.desc.text = item.content_name;
    listcellview.pass_key.text = item.s_code;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180+(SCREENWIDTH-3*100)/4.0;
}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//}

- (void)tapToQuanFinal:(UITapGestureRecognizer *)tap
{
    
    int n = tap.view.tag/100;
    int m = tap.view.tag%100;
    NSLog(@"图片：%d",n*3+m);
    CouponDetailViewController * detail = [[CouponDetailViewController alloc]initWithNibName:@"CouponDetailViewController" bundle:nil];
    CouponListItem * item = [dataarray objectAtIndex:n*3+m];
    detail.mitem = [[CouponListItem alloc]init];
    detail.mitem = item;
    [[(MyCouponViewController *)self.delegate navigationController] pushViewController:detail animated:YES];

}
- (void)goEvaluate:(UITapGestureRecognizer *)tap
{
    //去评论
    CouponListItem * item = [dataarray objectAtIndex:tap.view.tag/1000*3+tap.view.tag%1000-6];
    NSLog(@"评论：%d",tap.view.tag/1000*3+tap.view.tag%1000-6);
    EvaluateViewController * evaluate = [[EvaluateViewController alloc]initWithNibName:@"EvaluateViewController" bundle:nil];
    evaluate.auto_id = item.auto_id;
    evaluate.review_id = item.product_id;
    evaluate.content_type = @"com_shopBulk";
    [[(MyCouponViewController *)self.delegate navigationController] pushViewController:evaluate animated:YES];
}

#pragma mark - 下拉刷新／上拉加载更多
- (void)pullTableViewDidTriggerLoadMore:(CollectionView *)pullTableView
{
    [self performSelector:@selector(loadmore) withObject:nil afterDelay:0.5];
}
- (void)loadmore
{
    more++;
    [self download];
    [_mtableview setPullTableIsLoadingMore:NO];
}
- (void)pullTableViewDidTriggerRefresh:(CollectionView *)pullTableView
{
    [self performSelector:@selector(update) withObject:nil afterDelay:0.5];
}
- (void)update
{
    more = 1;
    [self download];
}

- (void)refund:(UIButton *)sender//退款
{
    CouponListItem * item = [dataarray objectAtIndex:sender.tag/10000*3+sender.tag%10000-3];
    
    
    NSLog(@"退款：%d",sender.tag/10000*3+sender.tag%10000-3);
    
    CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"您是否确定退款?" leftButtonTitle:@"取消" leftActionBlock:^(CLBCustomAlertView *view) {
        [view dismiss];
    } rightButtonTitle:@"确定" rightActionBlock:^(CLBCustomAlertView *view) {
        NSString * url = [NSString stringWithFormat:@"%@%@&autoid=%@&ID=%@&PWD=%@",HTTP,CouponRefundUrl,item.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
        [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            if([[dic objectForKey:@"status"] integerValue] == 1)
            {
                item.is_return = @"1";
                [_mtableview reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefundQuanNotification" object:nil];
            }
            [self.view makeToast:[dic objectForKey:@"msg"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [view dismiss];
    }];
    [alertView show];

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
