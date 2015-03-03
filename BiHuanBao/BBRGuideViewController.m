//
//  BBRGuideViewController.m
//  BuyBuyring
//
//  Created by 颜沛贤 on 14-2-15.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "BBRGuideViewController.h"
#import "AppDelegate.h"

#define PAGENUMBER 2 //引导页页面的数量

@interface BBRGuideViewController ()

@end

@implementation BBRGuideViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //将第一次启动的表示设置为no
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];

    
    self.wantsFullScreenLayout = YES;
    
    
    if(IOS7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
   
    
    
    //scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT)];

    self.scrollView.frame = self.view.frame;
    [self.scrollView setContentSize:CGSizeMake(SCREENWIDTH*PAGENUMBER, 0)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
//    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    //设置scrollview的图片
    for (int i=1; i<PAGENUMBER+1; i++) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*SCREENWIDTH, 0, SCREENWIDTH, self.scrollView.frame.size.height)];
        //此处是图片的名字，规则名字从1开始
//        if(iPhone5)
//        {
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-568h",i]]];
//        }
//        else if(SCREENHEIGHT == 480)
//        {
//            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d",i]]];
//        }
//        else
//        {
//            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
//        }
        
        [self.scrollView addSubview:imageView];
    }
    
    //立即体验的按钮，UI出来之后请按照UI设计
    beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[beginButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [beginButton setTintColor:[UIColor clearColor]];
    [beginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [beginButton setFrame:CGRectMake((PAGENUMBER-1)*SCREENWIDTH+160-65, self.scrollView.frame.size.height - (iPhone5?130:100), 130,40)];
    [beginButton setImage:[UIImage imageNamed:@"expre_btn"] forState:UIControlStateNormal];
   // beginButton.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:beginButton];
    [beginButton addTarget:self action:@selector(beginMain) forControlEvents:UIControlEventTouchDown];
    
    //pageControl--需要用的话就可以用
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(141, SCREENHEIGHT-60, 38, 36)];
    self.pageControl.numberOfPages = PAGENUMBER;
    self.pageControl.currentPage = 0;
    
    [self.view addSubview:self.pageControl];
    [self.view bringSubviewToFront:self.pageControl];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)scrollView.contentOffset.x/SCREENWIDTH;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x>SCREENWIDTH*(PAGENUMBER-1)+30)
    {
        [self beginMain];
    }
    DLog(@"%f",scrollView.contentOffset.x);
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)beginMain
{
    NSLog(@"进入主页");
    AppDelegate * dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [dele setTabBarViewController:0];
}
- (RootViewController *)demoController
{
    RootViewController * root =[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    return root;
}

- (UINavigationController *)navigationController {
    UINavigationController * nav = [[UINavigationController alloc]
                                    initWithRootViewController:[self demoController]];
    nav.navigationBar.hidden = YES;
    return nav;
}

- (void)viewDidUnload
{
    self.scrollView = nil;
}


//如果想滑动到最后一张图片滑动进入应用请打开改方法即可
/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint point = self.scrollView.contentOffset;
    if ((int)(point.x) > 980) {
        [self beginMain];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
