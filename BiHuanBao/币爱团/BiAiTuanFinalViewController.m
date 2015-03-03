//
//  BiAiTuanFinalViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BiAiTuanFinalViewController.h"
#import "BiAiTuanFianlViewCell.h"
#import "ProductFinalDetailCell.h"
#import "ProductFinalEvaluateCell.h"

#import "IWantTuanViewController.h"
#import "ProductEvaluateItem.h"
#import "NSString+Addtion.h"
#import "CLBCustomAlertView.h"
@interface BiAiTuanFinalViewController ()

@end

@implementation BiAiTuanFinalViewController
@synthesize navBar;
@synthesize evaluates;
@synthesize headView;
@synthesize mtableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = self.titleName;
    
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.indicator startAnimatingActivit];
    //[self.view addSubview:self.indicator];

    
    [self.view addSubview:navBar];
    
    evaluates = [[NSMutableArray alloc] init];

    headView =[[ProductFinalHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*565.0/1080.0)];
    mtableview.tableHeaderView = headView;
    
    mtableview.opaque = NO;
    mtableview.backgroundColor = [UIColor clearColor];
    mtableview.pullDelegate = self;
    mtableview.pullBackgroundColor = [UIColor clearColor];
    
    [_yuyueBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchDown];
    
    sectionCell = [[[NSBundle mainBundle] loadNibNamed:@"ProductEvaluateSectionCell" owner:self options:nil] lastObject];
    UIImageView * v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 10)];
    UIImage * image = [UIImage imageNamed:@"yinying"];
    v.image = image;
    [sectionCell.contentView addSubview:v];
    
    [self download];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];
}

- (void)download
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@",HTTP,BiAiTuanDetailUrl,self.auto_id];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSDictionary * dict = [dic objectForKey:@"data"];
        self.content_name = OBJC([[dict objectForKey:@"corp"] objectForKey:@"content_name"]);
        self.sub_title = OBJC([dict objectForKey:@"content_name"]);
        self.content_preprice = OBJC([dict objectForKey:@"content_preprice"]);
        self.content_score = OBJC([dict objectForKey:@"content_score"]);
        self.content_Enumbers = OBJC([dict objectForKey:@"comment_num"]);
        self.address = OBJC([[dict objectForKey:@"corp"] objectForKey:@"content_address"]);
        self.tel = OBJC([[dict objectForKey:@"corp"] objectForKey:@"content_mobile"]);
        self.site = OBJC([[dict objectForKey:@"corp"] objectForKey:@"content_wz"]);
        self.content_desc = OBJC([dict objectForKey:@"content_desc"]);
        self.content_body = OBJC([dict objectForKey:@"content_body"]);
        self.total_num = OBJC([dict objectForKey:@"total_num"]);
        
        self.corp_id = OBJC([dict objectForKey:@"corp_id"]);
        
        [headView.defaultImg setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"no_phote_4x3"]];
        
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
            }
            
            item.content_score = [d objectForKey:@"content_score"];
            item.content_body = [d objectForKey:@"content_body"];
            item.create_time = [d objectForKey:@"create_time"];
            
            [evaluates addObject:item];
        }
        
        sectionCell.star.rating = [self.content_score integerValue];
        sectionCell.star.userInteractionEnabled = NO;
        sectionCell.star.isFraction = NO;
        sectionCell.content_number.text = [NSString stringWithFormat:@"%@人评价",[dict objectForKey:@"comment_num"]];
        
        [mtableview reloadData];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
        [self.view makeToast:NO_NET];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(section ==  0)
   {
       return 2;
   }
    else
    {
        return [evaluates count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            BiAiTuanFianlViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BiAiTuanFianlViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BiAiTuanFianlViewCell" owner:self options:nil] lastObject];
            }
            [cell.iwantTuan addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchDown];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callAction:)];
            cell.callBtn.userInteractionEnabled = YES;
            [cell.callBtn addGestureRecognizer:tap];
            
            cell.corp_name.text = self.content_name;[cell.corp_name sizeToFit];
            cell.content_desc.text = self.sub_title;
            cell.content_price.text = self.content_preprice;
            cell.numbers.text = [NSString stringWithFormat:@"已售%@",self.total_num];
            cell.star.rating = [self.content_score intValue];
            cell.star.userInteractionEnabled = NO;
            cell.evaulates.text = [NSString stringWithFormat:@"%@人评价",self.content_Enumbers];
            cell.address.text = self.address;
            cell.tel.text = self.tel;
            cell.site.text = self.site;
            return cell;
        }
        else
        {
            ProductFinalDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProductFinalDetailCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductFinalDetailCell" owner:self options:nil] lastObject];
            }
            cell.detailTextLabel.text = OBJC(self.content_desc);
            return cell;
        }
    }
    else
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
        cell.content_body.backgroundColor = [UIColor redColor];
        [cell.content_body sizeToFit];
        
            return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return sectionCell;
    }
    else
    {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 54.f;
    }
    else
    {
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            return 193.f;
        }
        else
        {
            return 84.f;
        }
    }
    else
    {
            ProductEvaluateItem * item = [evaluates objectAtIndex:indexPath.row];
            CGSize size = [item.content_body getcontentsizeWithfont:[UIFont systemFontOfSize:10] constrainedtosize:CGSizeMake(SCREENWIDTH-120, 200) linemode:NSLineBreakByWordWrapping];
            return size.height+30+10+16>85?size.height+30+10+16:85;
    }
}

#pragma mark - 加载更多
#pragma mark - 刷新
- (void)pullTableViewDidTriggerRefresh:(TableView *)pullTableView
{
    [self performSelector:@selector(update) withObject:nil afterDelay:0.5];
}
- (void)update
{
    [self download];
    [mtableview setPullTableIsRefreshing:NO];
}
- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{
    [self performSelector:@selector(loadmore) withObject:nil afterDelay:1.0];
}
- (void)loadmore
{
    [mtableview setPullTableIsLoadingMore:NO];
    more++;
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&page=%d&row=10",HTTP,BiAiTuanMoreCommentsUrl,self.auto_id,more];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        for(NSDictionary * d in [dic objectForKey:@"datalist"] )
        {
            ProductEvaluateItem * item = [[ProductEvaluateItem alloc]init];
            if(![[d objectForKey:@"member"] isKindOfClass:[NSDictionary class]])
            {
                item.content_user = @"匿名";
                item.content_face = nil;
            }
            else
            {
                item.content_user = [[d objectForKey:@"member"] objectForKey:@"content_user"];
                item.content_face = [[d objectForKey:@"member"] objectForKey:@"content_face"];
            }
            
            item.content_score = [d objectForKey:@"content_score"];
            item.content_body = [d objectForKey:@"content_body"];
            item.create_time = [d objectForKey:@"create_time"];
            
            [evaluates addObject:item];
            if([evaluates count]!=0)
            {
                [mtableview reloadData];
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

#pragma mark - 拨打电话
- (void)callAction:(UITapGestureRecognizer *)tap
{
    BiAiTuanFianlViewCell * cell = (BiAiTuanFianlViewCell *)[mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",cell.tel.text];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];
}

#pragma mark - 预约
- (void)yuyueAction:(id)sender
{
    
    if([[[UserLoginInfoManager loginmanager] isCorper] integerValue] == 2)
    {
        CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"商家会员不能参与！" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
            [view dismiss];
        } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
            
        }];
        [alertView show];
        return;
    }
    
    if([[UserLoginInfoManager loginmanager] state])
    {
        IWantTuanViewController * want = [[IWantTuanViewController alloc]initWithNibName:@"IWantTuanViewController" bundle:nil];
        want.auto_id = self.auto_id;
        want.corp_id = self.corp_id;
        [self.navigationController pushViewController:want animated:YES];
    }
    else
    {
        [self login:YES];
    }
    
}

- (void)login:(BOOL)sender
{
    LoginController * login = [[LoginController alloc]init];
    login.islogin = YES;
    login.from_pay = YES;
    login.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)loginfinished
{
    IWantTuanViewController * want = [[IWantTuanViewController alloc]initWithNibName:@"IWantTuanViewController" bundle:nil];
    want.auto_id = self.auto_id;
    want.corp_id = self.corp_id;
    [self.navigationController pushViewController:want animated:YES];
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
