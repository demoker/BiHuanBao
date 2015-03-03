//
//  BiAiTuanRootController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BiAiTuanRootController.h"
#import "BiAiTuanRootViewCell.h"
#import "BiAiTuanFinalViewController.h"
#import "KxMenu.h"
@interface BiAiTuanRootController ()

@end

@implementation BiAiTuanRootController

@synthesize navBar;
@synthesize images_ad;
@synthesize productArray;
@synthesize classes;
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
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_Topic pauseTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    self.pics =[[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"币爱团";
    [navBar.homebtn setImage:[UIImage imageNamed:@"fenlei_btn"] forState:UIControlStateNormal];
    [navBar.homebtn setTitle:@"分类" forState:UIControlStateNormal];
    navBar.homebtn.frame = CGRectMake(navBar.frame.size.width-100, navBar.homebtn.frame.origin.y, 100, 44);
    [navBar.homebtn layoutIfNeeded];
    navBar.hidden = YES;
    
    productArray = [[NSMutableArray alloc]init];
    
    classes = [[NSMutableArray alloc]init];
    
    more = 1;
    
    [self.view addSubview:navBar];
    
    
    _mtableview.pullDelegate = self;
    
    
    NSLog(@"===rootHeadView.defaultImg.frame.size.height====%f",rootHeadView.defaultImg.frame.size.height);
    
    rootHeadView = [[B2CRootHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*565.0/1080.0)];

    
    _mtableview.tableHeaderView = rootHeadView;
    
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];
    
    [self ad_request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(download_productTypeList) name:@"TransAddressDidSelect" object:nil];
    
    [self.view bringSubviewToFront:self.indicator];
    
    [self download_productTypeList];
    
    [self downloadClass];
}

- (void)downloadClass
{
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,ClassesUrl];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arr = (NSArray *)responseObject;
        for(NSDictionary * d in arr)
        {
            [classes addObject:d];
        }
        navBar.hidden = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)download_productTypeList
{
    NSString * url = nil;
    if(self.default_code_id!= nil)
    {
        url = [NSString stringWithFormat:@"%@%@&row=10&page=%d&auto_code=%@",HTTP,BiAiTuanListUrl,more,self.default_code_id];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@&row=10&page=%d",HTTP,BiAiTuanListUrl,more];
    }
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

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return rootHeadView.defaultImg.frame.size.height;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return rootHeadView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BiAiTuanRootViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BiAiTuanRootViewCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BiAiTuanRootViewCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
   if([productArray count]!=0)
   {
       ProductListItem * item = [productArray objectAtIndex:indexPath.row];
       [cell.content_img setImageWithURL:[NSURL URLWithString:item.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
       cell.content_name.text = item.sub_title;
       cell.content_price.text = item.content_preprice;
       cell.img_tag.hidden = NO;
       cell.content_desc.text = item.content_name;
       cell.star.rating = [item.content_score integerValue];
       cell.star.isFraction = NO;
       cell.star.userInteractionEnabled = NO;
       [cell.content_name sizeToFit];
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
    ProductListItem * item = [productArray objectAtIndex:indexPath.row];
    BiAiTuanFinalViewController * final = [[BiAiTuanFinalViewController alloc]initWithNibName:@"BiAiTuanFinalViewController" bundle:nil];
    final.auto_id = item.auto_id;
    final.titleName = item.sub_title;
    [self.navigationController pushViewController:final animated:YES];
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

- (void)ad_request
{
    NSString * url = [NSString stringWithFormat:@"%@%@&optionid=%@",HTTP,AdvantageShowUrl,@"998"];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arr = (NSArray *)responseObject;
        if(arr == nil)
        {
            return ;
        }
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

- (void)animatetochannel:(UIButton *)sender
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
        [tempArray addObject:[NSDictionary dictionaryWithObjects:@[OBJC([dic objectForKey:@"content_img"]) ,NSStringFromJson([dic objectForKey:@"content_value"]),@NO] forKeys:@[@"pic",@"title",@"isLoc"]]];
        
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)home:(id)sender
{
    //分类
    int i = 0;
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for(NSDictionary * d in classes)
    {
        [arr addObject:[KxMenuItem menuItem:[d objectForKey:@"modules_name"] image:nil target:self action:@selector(selectCitys:) index:i]];
        i++;
    }
    [KxMenu showMenuInView:self.view fromRect:navBar.homebtn.frame menuItems:arr];
    
}
- (void)selectCitys:(id)sender
{
    KxMenuItem * item = (KxMenuItem *)sender;
    
    self.default_code = [[classes objectAtIndex:item.tag] objectForKey:@"modules_name"];
    self.default_code_id = [[classes objectAtIndex:item.tag] objectForKey:@"auto_code"];
    navBar.homebtn.titleLabel.text = self.default_code;
    more = 1;
    [self updateData];
}

- (void)titleTap:(id)sender
{

}

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