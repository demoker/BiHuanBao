//
//  BiAiTuanFinalViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BixvSongFinalViewController.h"
#import "BixvSongFinalViewCell.h"
#import "ProductFinalDetailCell.h"
#import "ProductFinalEvaluateCell.h"
#import "IWantSongViewController.h"
#import "ProductEvaluateItem.h"
#import "CLBCustomAlertView.h"
@interface BixvSongFinalViewController ()

@end

@implementation BixvSongFinalViewController
@synthesize navBar;
@synthesize evaluates;
@synthesize headView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BackGround_Color;
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = self.titleName;
    
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];

    
    [self.view addSubview:navBar];
    
    evaluates = [[NSMutableArray alloc] init];

    headView =[[ProductFinalHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*565.0/1080.0)];
    _mtableview.tableHeaderView = headView;
    
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    _mtableview.pullDelegate = self;
    _mtableview.pullBackgroundColor = [UIColor clearColor];
    _mtableview.loadMoreView.hidden = YES;
    _mtableview.loadMoreView.delegate = nil;
    
    [_yuyueBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchDown];

    sectionCell = [[[NSBundle mainBundle] loadNibNamed:@"ProductEvaluateSectionCell" owner:self options:nil] lastObject];
    UIImageView * v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 10)];
    UIImage * image = [UIImage imageNamed:@"yinying"];
    v.image = image;
    [sectionCell.contentView addSubview:v];
    [self download];
}
- (void)download
{
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@",HTTP,BiXvSongDetailUrl,self.auto_id];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        self.content_name = OBJC([[dic objectForKey:@"corp"] objectForKey:@"content_name"]);
        self.sub_title = OBJC([dic objectForKey:@"content_name"]);
        self.content_preprice = OBJC([dic objectForKey:@"content_sprice"]);
        self.address = OBJC([[dic objectForKey:@"corp"] objectForKey:@"content_address"]);
        self.tel = OBJC([[dic objectForKey:@"corp"] objectForKey:@"content_mobile"]);
        self.site = OBJC([[dic objectForKey:@"corp"] objectForKey:@"content_wz"]);
        self.content_desc = OBJC([dic objectForKey:@"content_desc"]);
        self.content_body = OBJC([dic objectForKey:@"content_body"]);
        self.total = OBJC([dic objectForKey:@"content_stotal"]);
        
        self.remain = [NSString stringWithFormat:@"%@",OBJC([dic objectForKey:@"ye_price"])];
        self.book_price = [dic objectForKey:@"book_price"];
        
        [headView.defaultImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"no_phote_4x3"]];
        
        [_mtableview reloadData];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
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
   if(section ==  0)
   {
       return 2;
   }
    else
    {
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            BixvSongFinalViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BixvSongFinalViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BixvSongFinalViewCell" owner:self options:nil] lastObject];
                [cell.yuyueBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchDown];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callAction:)];
                [cell.callBtn addGestureRecognizer:tap];
            }
            cell.content_name.text = self.content_name;
            cell.content_desc.text = self.sub_title;
            cell.giving.text = self.content_preprice;
            cell.yu_e.text = self.remain;
            cell.totalLabel.text = self.total;
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
            cell.content_desc.text = self.content_desc;
            
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
            return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        ProductEvaluateSectionCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductEvaluateSectionCell" owner:self options:nil] lastObject];
        UIImageView * v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 10)];
        UIImage * image = [UIImage imageNamed:@"yinying"];
        v.image = image;
        [cell.contentView addSubview:v];
        return cell;
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
        return 85.f;
    }
}

#pragma mark - 刷新
- (void)pullTableViewDidTriggerRefresh:(TableView *)pullTableView
{
    [self performSelector:@selector(update) withObject:nil afterDelay:0.5];
}
- (void)update
{
    [self download];
    [_mtableview setPullTableIsRefreshing:NO];
}

#pragma mark - 预约
- (void)yuyueAction:(UIButton *)sender
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
        IWantSongViewController * want = [[IWantSongViewController alloc]initWithNibName:@"IWantSongViewController" bundle:nil];
        want.auto_id = self.auto_id;
        want.corp_name = self.content_name;
        want.sub_title = self.sub_title;
        want.giving = self.content_preprice;
        want.total = self.total;
        want.current = self.book_price;
        want.all_yuyue = self.remain;
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
    IWantSongViewController * want = [[IWantSongViewController alloc]initWithNibName:@"IWantSongViewController" bundle:nil];
    want.auto_id = self.auto_id;
    want.corp_name = self.content_name;
    want.sub_title = self.sub_title;
    want.giving = self.content_preprice;
    want.total = self.total;
    want.current = self.book_price;
    want.all_yuyue = self.remain;
    [self.navigationController pushViewController:want animated:YES];
}

- (void)callAction:(UITapGestureRecognizer *)tap
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",self.tel];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];
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
