//
//  BHBSearchViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/12.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BHBSearchViewController.h"
#import "BiHuanBaoRootViewCell.h"
#import "BiHuanBaoFinalViewController.h"
@interface BHBSearchViewController ()

@end

@implementation BHBSearchViewController
@synthesize productArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"搜索";
    [self.view addSubview:navBar];
    
    _searchtableView.refreshView.hidden = YES;
    _searchtableView.refreshView.delegate = nil;
    _searchtableView.pullDelegate = self;
    
    productArray = [[NSMutableArray alloc]init];
    
    more = 1;
    
    [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchDown];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT+44, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    
    [self.view addSubview:self.indicator];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BiHuanBaoRootViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BiHuanBaoRootViewCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BiHuanBaoRootViewCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    if([productArray count]!=0)
    {
        ProductListItem * item = [productArray objectAtIndex:indexPath.row];
        [cell.content_img setImageWithURL:[NSURL URLWithString:item.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
        cell.content_name.text = item.content_name;
        cell.content_price.text = item.content_preprice;
        cell.renzheng.hidden = NO;
        cell.content_desc.text = item.sub_title;
        cell.star.rating = [item.content_score integerValue];
        cell.star.isFraction = NO;
        cell.star.userInteractionEnabled = NO;
        cell.numbers.text = [NSString stringWithFormat:@"总成交:%@件",item.content_sale];
        
        if([item.content_isnew isEqualToString:@"1"])
        {
            //new_tag
            cell.img_tag.hidden = NO;
            [cell.img_tag setImage:[UIImage imageNamed:@"new_tag"]];
        }
        else if([item.content_isnew isEqualToString:@"2"])
        {
            cell.img_tag.hidden = NO;
            [cell.img_tag setImage:[UIImage imageNamed:@"hot_icon"]];
        }
        else
        {
            cell.img_tag.hidden = YES;
        }

    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BiHuanBaoFinalViewController * final = [[BiHuanBaoFinalViewController alloc]initWithNibName:@"BiHuanBaoFinalViewController" bundle:nil];
    ProductListItem * item = [productArray objectAtIndex:indexPath.row];
    final.auto_id = item.auto_id;
    [self.navigationController pushViewController:final animated:YES];
}
#pragma mark - 搜索事件
- (void)searchAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&row=10&page=%d&key=%@&area=%@",HTTP,BiHuanBaoListUrl,more,[_searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[UserLoginInfoManager loginmanager] currentCity] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(more == 1)
        {
            [productArray removeAllObjects];
        }
        NSArray * arr = (NSArray *)responseObject;
        for(NSDictionary * dic in arr)
        {
            ProductListItem * item = [[ProductListItem alloc]init];
            item.content_img = [dic objectForKey:@"content_img"];
            item.auto_id = [dic objectForKey:@"auto_id"];
            item.sub_title = [dic objectForKey:@"sub_title"];
            item.content_name = [dic objectForKey:@"content_name"];
            item.content_preprice = [dic objectForKey:@"content_preprice"];
            item.content_sale = [dic objectForKey:@"content_sale"];
            item.content_score = [dic objectForKey:@"content_score"];
            item.content_isnew = [dic objectForKey:@"is_checkmem"];
            [productArray addObject:item];
        }
        
        if([arr count]==0&&more>1)
        {
            more --;
            [self.view makeToast:NO_MORE_DATA];
        }
        
        if([productArray count]!=0)
        {
            [_searchtableView reloadData];
            [self.indicator LoadSuccess];
        }
        else
        {
            [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:NO_DATA_DESC];
        }
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
#pragma mark - 刷新代理方法
//- (void)pullTableViewDidTriggerRefresh:(TableView*)pullTableView
//{
//    [self performSelector:@selector(updateData) withObject:nil afterDelay:2.0];
//}
//
//- (void)updateData
//{
//    [self.indicator startAnimatingActivit];
//    [productArray removeAllObjects];
//    more = 1;
//    [self searchAction:nil];
//    [_searchtableView setPullTableIsRefreshing:NO];
//    
//}
- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{
    [self performSelector:@selector(loadmore) withObject:nil afterDelay:2.0];
}
- (void)loadmore
{
    more ++;
    [self searchAction:nil];
    [_searchtableView setPullTableIsLoadingMore:NO];
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
