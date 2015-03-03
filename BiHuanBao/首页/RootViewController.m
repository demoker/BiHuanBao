

//
//  RootViewController.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-6.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "RootViewController.h"

#import "NSTimer+Addition.h"

#import "RootTableViewCell.h"
#import "BiAiTuanRootController.h"
#import "BiHuanBaoRootController.h"
#import "BiXvSongRootController.h"


#import "BiAiTuanFinalViewController.h"
#import "KxMenu.h"
#import "BHBSearchViewController.h"
#import "CLBCustomAlertView.h"

@interface RootViewController ()
@end

@implementation RootViewController
@synthesize navBar;
@synthesize images_ad;
@synthesize productArray;
@synthesize citys;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ad_already_create = NO;
        noti_already_create = NO;
        ishas = NO;
    }
    return self;
}


- (void)downloadBTCInfo
{
    UILabel * btc = (UILabel *)[navBar viewWithTag:101311];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,GetBTCInfoUrl];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        btc.text = [[dic objectForKey:@"ticker"] objectForKey:@"last"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(ishas)
    {
        if(!ad_already_create)
        {
            [self ad_request];
        }
    }
    
    ishas = YES;

    [_Topic continueTimer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appearTabbar" object:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_Topic pauseTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self downloadBTCInfo];
}

- (void)downloadCity
{
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,CitysUrl];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        for(NSDictionary * d in [dic objectForKey:@"data"])
        {
            [citys addObject:d];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
 
    self.pics =[[NSMutableArray alloc]init];
   
    // Do any additional setup after loading the view from its nib.

    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONSETTINGBAR];
    navBar.setbtn.hidden = YES;
    navBar.delegate = self;
    navBar.titleLabel.frame =CGRectMake(10, navBar.titleLabel.frame.origin.y, 100, navBar.titleLabel.frame.size.height);
    navBar.titleLabel.textAlignment = NSTextAlignmentLeft;
    navBar.titleLabel.text = @"北京";
    [[UserLoginInfoManager loginmanager] setCurrentCity:@"北京"];
    
    productArray = [[NSMutableArray alloc]init];
    citys = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = BackGround_Color;
    
   
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
   
    [navBar.backbtn setImage:nil forState:UIControlStateNormal];
    [navBar.backbtn setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    navBar.backbtn.frame = CGRectMake(0, 0, 120, 25);
    navBar.backbtn.center = CGPointMake(navBar.frame.size.width/2, IOS7?(navBar.frame.size.height-20)/2+20:navBar.frame.size.height/2);
    navBar.backbtn.hidden = YES;
    
    [self.view addSubview:navBar];
    
    
    UIView * search_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2.5, NAVHEIGHT)];
    search_bg.center = CGPointMake(SCREENWIDTH/2.0, search_bg.center.y);
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, search_bg.frame.size.height-15, search_bg.frame.size.width, 6)];
    [image setImage:[UIImage imageNamed:@"search_bg"]];
    [search_bg addSubview:image];
    
    UIImageView * search_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 15, 15)];
    [search_icon setImage:[UIImage imageNamed:@"fangdajing"]];
    [search_bg addSubview:search_icon];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(search_icon.frame.origin.x+search_icon.frame.size.width+5, search_icon.frame.origin.y-2, 120, 20)];
    label.backgroundColor = [UIColor greenColor];
    label.center = CGPointMake(search_bg.frame.size.width/2+25, label.center.y);
    search_icon.frame = CGRectMake(label.frame.origin.x-20, search_icon.frame.origin.y, 15, 15);
    label.font = [UIFont systemFontOfSize:12];
    
    label.text = @"搜索宝贝、商家";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [search_bg addSubview:label];
    
    [navBar addSubview:search_bg];
    search_bg.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seachAction:)];
    [search_bg addGestureRecognizer:tap];
    
    
    UIView * BTCView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, 20, 70, 40)];
    BTCView.backgroundColor = [UIColor clearColor];
    UILabel * btc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    btc.tag = 101311;
    btc.text = @"获取中...";
    btc.textAlignment = NSTextAlignmentCenter;
    btc.backgroundColor = [UIColor clearColor];
    btc.font = [UIFont boldSystemFontOfSize:15];
    btc.textColor = [UIColor whiteColor];
    btc.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * btcinfotap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadBTCInfo)];
    [btc addGestureRecognizer:btcinfotap];
    
    [BTCView addSubview:btc];
    
    UILabel * cny = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 70, 20)];
    cny.textColor = [UIColor whiteColor];
    cny.font = [UIFont systemFontOfSize:12];
    cny.text = @"CNY~1BTC";
    cny.backgroundColor = [UIColor clearColor];
    cny.textAlignment = NSTextAlignmentCenter;
    [BTCView addSubview:cny];
    
    [navBar addSubview:BTCView];
    
    self.default_city = @"北京";
    self.default_city_id = @"1";
    navBar.titleLabel.text = self.default_city;
    
    _mtableview.pullDelegate = self;
    
    rootHeadView = [[B2CRootHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*565.0/1080.0)];

    
    icons = [[NSArray alloc]initWithObjects:@"bhb",@"bat",@"bht",@"bxs", nil];
    NSArray * titles = [NSArray arrayWithObjects:@"币换宝",@"币爱团",@"币海淘",@"币须送", nil];
    
    int width = (SCREENWIDTH-15*2-20*3)/4.0;
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, rootHeadView.frame.size.height+width+20+20)];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:rootHeadView];
    
    _mtableview.tableHeaderView = headView;
    
    for(int i = 0;i<4;i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+(20+width)*(i%4), rootHeadView.frame.size.height+10, width, width);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(channelAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:[icons objectAtIndex:i]] forState:UIControlStateNormal];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.size.height+btn.frame.origin.y, btn.frame.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [titles objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x535353);
        [headView addSubview:label];
        [headView addSubview:btn];
    }

    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];
    
    [self ad_request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(download_productTypeList) name:@"TransAddressDidSelect" object:nil];
    
    [self.view bringSubviewToFront:self.indicator];
    
    more = 1;
    
    [self download_productTypeList];
    
//    [self location];
    
    [self downloadCity];
    

}
#pragma mark - 搜索事件
- (void)seachAction:(UITapGestureRecognizer *)tap
{
    BHBSearchViewController * search = [[BHBSearchViewController alloc]initWithNibName:@"BHBSearchViewController" bundle:nil];
    [self.navigationController pushViewController:search animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];

}

- (void)location
{
    locationmanager = [[LocationManager alloc]init];
    locationmanager.delegate = self;
    [locationmanager startUpdates];
}

#pragma mark - 跳转到某频道
- (void)channelAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
    switch (sender.tag-100) {
        case 0:
        {
            BiHuanBaoRootController * bihuanbao = [[BiHuanBaoRootController alloc]initWithNibName:@"BiHuanBaoRootController" bundle:nil];
            [self.navigationController pushViewController:bihuanbao animated:YES];
        }
            break;
        case 1:
        {
            BiAiTuanRootController * biaituan = [[BiAiTuanRootController alloc]initWithNibName:@"BiAiTuanRootController" bundle:nil];
            [self.navigationController pushViewController:biaituan animated:YES];
        }
            break;
        case 2:
        {
//            BiHuanBaoRootController * bihuanbao = [[BiHuanBaoRootController alloc]initWithNibName:@"BiHuanBaoRootController" bundle:nil];
//            [self.navigationController pushViewController:bihuanbao animated:YES];
            CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"暂未开通，敬请期待！" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            [alertView show];
        }
            break;
        case 3:
        {
            BiXvSongRootController * bixvsong = [[BiXvSongRootController alloc]initWithNibName:@"BiXvSongRootController" bundle:nil];
            [self.navigationController pushViewController:bixvsong animated:YES];
        }
            break;
        default:
            break;
    }
}



- (void)download_productTypeList
{
    NSString * url = [NSString stringWithFormat:@"%@%@&row=10&page=%d",HTTP,BiAiTuanListUrl,more];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            item.content_isnew = [dic objectForKey:@"shop_type"];
            [productArray addObject:item];
        }
        
        if([arr count]==0&&more>1)
        {
            more --;
            [self.view makeToast:NO_MORE_DATA];
        }
        
        
        if([productArray count]!=0)
        {
            [_mtableview reloadData];
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

#pragma mark - UIableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RootTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RootTableViewCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RootTableViewCell" owner:self options:nil] lastObject];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    ProductListItem * item = [productArray objectAtIndex:indexPath.row];
    cell.content_name.text = item.sub_title;[cell.content_name sizeToFit];
    [cell.content_img setImageWithURL:[NSURL URLWithString:item.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
    cell.content_preprice.text = item.content_preprice;
    cell.content_sale.text = [NSString stringWithFormat:@"已出售%@件",item.content_sale];
    cell.content_isnew.hidden = NO;
    cell.sub_title.text = item.content_name;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CorpOrderDetailViewController * prepare = [[CorpOrderDetailViewController alloc]initWithNibName:@"CorpOrderDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:prepare animated:YES];
    ProductListItem * item = [productArray objectAtIndex:indexPath.row];
    BiAiTuanFinalViewController * final = [[BiAiTuanFinalViewController alloc]initWithNibName:@"BiAiTuanFinalViewController" bundle:nil];
    final.auto_id = item.auto_id;
    final.titleName = item.sub_title;
    [self.navigationController pushViewController:final animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
}
#pragma mark - 刷新代理方法
- (void)pullTableViewDidTriggerRefresh:(TableView*)pullTableView
{
    [self performSelector:@selector(updateData) withObject:nil afterDelay:2.0];
}

- (void)updateData
{
    [self.indicator startAnimatingActivit];
    [productArray removeAllObjects];
    more = 1;
    [self download_productTypeList];
    [_mtableview setPullTableIsRefreshing:NO];
    
}
- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{
    [self performSelector:@selector(loadmore) withObject:nil afterDelay:2.0];
}
- (void)loadmore
{
    more ++;
    [self download_productTypeList];
    [_mtableview setPullTableIsLoadingMore:NO];
}

- (void)sendTransAddressDidSelectNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TransAddressDidSelect" object:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"TransAddressDidSelect"])
    {
        
    }
}

- (void)ad_request
{
    NSString * url = [NSString stringWithFormat:@"%@%@&optionid=%@",HTTP,AdvantageShowUrl,@"997"];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * arr = (NSArray *)responseObject;
            self.pics = [NSMutableArray arrayWithArray:arr];
            [self createImgs:self.pics];
            ad_already_create = YES;
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
    }];
}

- (void)pageControlChanged:(UIPageControl *)pageCtrl
{
    [mtimer pauseTimer];
    int page = (int)_mpagecontrol.currentPage; // 获取当前的page
     [_Topic setContentOffset:CGPointMake(SCREENWIDTH*(page+1), 0) animated:YES];
    [mtimer resumeTimerAfterTimeInterval:3.0];
    
    
}


- (void)createChnnel
{

    
}

- (void)animatetochannel:(UIButton *)tap
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];

}


- (void)createImgs:(NSArray *)arr
{
    _Topic = [[JCTopic alloc]initWithFrame:rootHeadView.defaultImg.frame];
    //代理
    _Topic.JCdelegate = self;
    //创建数据
    NSMutableArray * tempArray = [[NSMutableArray alloc]init];
    for(NSDictionary * dic in arr)
    {
        [tempArray addObject:[NSDictionary dictionaryWithObjects:@[OBJC([dic objectForKey:@"content_value"]) ,NSStringFromJson([dic objectForKey:@"content_name"]),@NO] forKeys:@[@"pic",@"title",@"isLoc"]]];

//        [tempArray addObject:[NSDictionary dictionaryWithObjects:@[OBJC([dic objectForKey:@"content_value"]) ,OBJC([dic objectForKey:@"content_name"]),@NO,[UIImage imageNamed:@"no_phote"]] forKeys:@[@"pic",@"title",@"isLoc",@"placeholderImage"]]];
    }
    
   
    _Topic.pics = tempArray;
    [_Topic upDate];
    _Topic.userInteractionEnabled = YES;
    [rootHeadView addSubview:_Topic];
    
    _mpagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _mpagecontrol.center = CGPointMake(SCREENWIDTH/2, _Topic.frame.size.height-15);
    _mpagecontrol.numberOfPages = [_Topic.pics count]-2;
    _mpagecontrol.currentPage = 0;
    [rootHeadView addSubview:_mpagecontrol];
}


#pragma mark - JCTopDelegate
- (void)didClick:(id)data withscrollview:(UIScrollView *)jc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
    if(jc == _Topic)
    {
        UIButton * btn = (UIButton *)data;DLog(@"+++%ld",(long)btn.tag);
        NSDictionary * dic = [self.pics objectAtIndex:btn.tag-1];
        switch ([[dic objectForKey:@"content_txt"]integerValue]) {
            case 1:
            {
               
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
            
            }
                break;
            case 4:
            {
                
            }
                break;
                
            default:
                break;
        }

    }
    else
    {
        
    }
        
}
-(void)currentPage:(int)page total:(NSUInteger)total withscrollview:(JCTopic *)jc
{
    if(jc == _Topic)
    {
       _mpagecontrol.currentPage = page;
    }
}

- (void)download
{
    [self.view bringSubviewToFront:self.indicator];
    //下载品牌信息
    NSString * url = nil;
    
  }

#pragma mark - UIScrollViewDelegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == _Topic)
    {
        [mtimer pauseTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == _Topic)
    {
        [mtimer resumeTimer];
    }
    
}


#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


#pragma mark - 返回
- (void)back:(id)sender
{
   
}
- (void)titleTap:(id)sender
{
    int i = 0;
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for(NSDictionary * d in citys)
    {
        [arr addObject:[KxMenuItem menuItem:[d objectForKey:@"label"] image:nil target:self action:@selector(selectCitys:) index:i]];
        i++;
    }
    [KxMenu showMenuInView:self.view fromRect:navBar.titleLabel.frame menuItems:arr];
  
}
- (void)selectCitys:(id)sender
{
    KxMenuItem * item = (KxMenuItem *)sender;
    
    self.default_city = [[citys objectAtIndex:item.tag] objectForKey:@"label"];
    self.default_city_id = [[citys objectAtIndex:item.tag] objectForKey:@"area"];
    navBar.titleLabel.text = self.default_city;
    
    [[UserLoginInfoManager loginmanager] setCurrentCity:self.default_city];
}

#pragma mark - 登录完成
- (void)loginfinished
{
 
}

#pragma mark - 定位回调方法


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.navBar = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
