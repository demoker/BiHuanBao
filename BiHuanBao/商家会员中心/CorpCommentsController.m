//
//  CorpCommentsController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "CorpCommentsController.h"
#import "ProductFinalEvaluateCell.h"
#import "ProductEvaluateItem.h"
#import "NSString+Addtion.h"
@interface CorpCommentsController ()

@end

@implementation CorpCommentsController
@synthesize evaluates;
@synthesize mitem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"券详情";
    [self.view addSubview:navBar];
    
    more = 1;
    
    evaluates = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = BackGround_Color;
    
    _mtableview.pullDelegate = self;
    
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    singlecell = [[[NSBundle mainBundle] loadNibNamed:@"CorpCouponTableCell" owner:self options:nil] lastObject];
    
    
    singlecell.content_name.text = mitem.content_name;
    [singlecell.content_img setImageWithURL:[NSURL URLWithString:mitem.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
    singlecell.sub_title.text = mitem.sub_title;
    singlecell.lj_num.text = mitem.lj_num;
    singlecell.star.rating = [mitem.content_score floatValue];
    singlecell.star.userInteractionEnabled = NO;
    singlecell.star.isFraction = NO;
    singlecell.comment_num.text = [NSString stringWithFormat:@"%@条",mitem.comment_num];
    if([mitem.shop_type integerValue]==1)
    {
        singlecell.shop_type_img.hidden = NO;
    }
    else
    {
        singlecell.shop_type_img.hidden = YES;
    }
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];

    
    [self download];
}


- (void)download
{
    [self.indicator startAnimatingActivit];
    
    NSString * url = [NSString stringWithFormat:@"%@%@&autoid=%@&ID=%@&PWD=%@",HTTP,BiAiTuanDetailUrl,mitem.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        
        [evaluates removeAllObjects];
//        CorpCouponItem * item = [[CorpCouponItem alloc]init];
//        item.auto_id = [dict objectForKey:@"auto_id"];
//        item.content_name = [dict objectForKey:@"content_name"];
//        item.sub_title = [dict objectForKey:@"sub_title"];
//        item.shop_type = [dict objectForKey:@"shop_type"];
//        item.lj_num = [dict objectForKey:@"lj_num"];
//        item.product_num = [dict objectForKey:@"product_num"];
//        item.comment_num = [dict objectForKey:@"comment_num"];
//        item.content_score = [dict objectForKey:@"content_score"];
        
        for(NSDictionary * d in [[dic objectForKey:@"comment"] objectForKey:@"datalist"])
        {
            ProductEvaluateItem * item = [[ProductEvaluateItem alloc]init];
            if(![[d objectForKey:@"member"] isKindOfClass:[NSDictionary class]])
            {
                item.content_user = nil;
                item.content_face = nil;
            }
            else
            {
                item.content_user = [[d objectForKey:@"member"] objectForKey:@"content_user"];
                item.content_face = [[d objectForKey:@"member"] objectForKey:@"content_face"];
            }            item.content_score = [d objectForKey:@"content_score"];
            item.content_body = OBJC([d objectForKey:@"content_body"]);
            item.create_time = [d objectForKey:@"create_time"];
            
            [evaluates addObject:item];
        }
        [_mtableview reloadData];
        [self.indicator LoadSuccess];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadFailed];
        [self.view makeToast:NO_NET];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [evaluates count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductFinalEvaluateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProductFinalEvaluateCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductFinalEvaluateCell" owner:self options:nil] lastObject];
    }
    ProductEvaluateItem * item = [evaluates objectAtIndex:indexPath.row];

    cell.content_body.text = OBJC(item.content_body);
    cell.content_time.text = item.create_time;
    [cell.content_titleImg setImageWithURL:[NSURL URLWithString:item.content_face] placeholderImage:[UIImage imageNamed:@"no_phote"]];
    cell.content_user.text = item.content_user;
    cell.star.rating = [item.content_score integerValue];
    cell.userInteractionEnabled = NO;
    
    [cell.content_body sizeToFit];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
            ProductEvaluateItem * item = [evaluates objectAtIndex:indexPath.row];
        CGSize size = [OBJC(item.content_body) getcontentsizeWithfont:[UIFont systemFontOfSize:10] constrainedtosize:CGSizeMake(SCREENWIDTH-120, 200) linemode:NSLineBreakByWordWrapping];
        return size.height+30+10>85?size.height+30+10:85;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return singlecell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}
#pragma mark - 加载更多\刷新
- (void)pullTableViewDidTriggerRefresh:(TableView *)pullTableView
{
    [self performSelector:@selector(update) withObject:nil afterDelay:0.3];
}
- (void)update
{
    [self download];
    [_mtableview setPullTableIsRefreshing:NO];
}

- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{
    [self performSelector:@selector(loadmore) withObject:nil afterDelay:0.3];
}
- (void)loadmore
{
    [_mtableview setPullTableIsLoadingMore:NO];
    more++;
    NSString * url = [NSString stringWithFormat:@"%@%@&autoid=%@&page=%d&row=10",HTTP,BiAiTuanMoreCommentsUrl,mitem.auto_id,more];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        for(NSDictionary * d in [dic objectForKey:@"datalist"] )
        {
            ProductEvaluateItem * item = [[ProductEvaluateItem alloc]init];
            item.content_user = [[d objectForKey:@"member"] objectForKey:@"content_user"];
            item.content_face = [[d objectForKey:@"member"] objectForKey:@"content_face"];
            item.content_score = [d objectForKey:@"content_score"];
            item.content_body = [d objectForKey:@"content_body"];
            item.create_time = [d objectForKey:@"create_time"];
            
            [evaluates addObject:item];
            if([evaluates count]!=0)
            {
                [_mtableview reloadData];
                [self.indicator LoadSuccess];
            }
            else
            {
                [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:NO_DATA_DESC];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(more == 1)
        {
            
        }
        else
        {
            more --;
            [self.view makeToast:NO_NET];
        }
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
