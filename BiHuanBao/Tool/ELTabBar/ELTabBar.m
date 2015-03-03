//
//  ELTabBar.m
//  HJMDrawer
//
//  Created by elongtian on 14-3-13.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "ELTabBar.h"
#import "ELButton.h"
@interface ELTabBar ()

@end

@implementation ELTabBar{
    NSInteger count;
    NSMutableArray * btnArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBar:) name:@"hideTabbar" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appearTabBar:) name:@"appearTabbar" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mTabSelectIndex:) name:@"mTabSelectIndex" object:nil];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self hideOriginalTab];
    
    self.tabBarView = [[UIView alloc]init];
    self.tabBarView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, SCREENWIDTH, 49);
//    self.tabBarView.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    UIImageView * lineV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    [lineV setImage:[UIImage imageNamed:@"level_line"]];
    [self.tabBarView addSubview:lineV];
    self.tabBarView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tabBarView];
    
//    UIImageView * imgbg = [[UIImageView alloc]initWithFrame:self.tabBarView.bounds];
//    [imgbg setImage:[UIImage imageNamed:@"tabar_bg"]];
//    [self.tabBarView addSubview:imgbg];
}

- (void)backBtnClick:(NSNotification *)notif {
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏tabbar
- (void)hideTabBar:(NSNotification *)notif {
    [UIView animateWithDuration:0.2
                          delay:0.00
                        options:UIViewAnimationOptionTransitionCurlUp animations:^(void){
                            self.tabBarView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREENWIDTH, 49);
                        }completion:nil];
    
}

//显示tabbar
- (void)appearTabBar:(NSNotification *)notif {
    [UIView animateWithDuration:0.2
                          delay:0.00
                        options:UIViewAnimationOptionTransitionCurlUp animations:^(void){
                            self.tabBarView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, SCREENWIDTH, 49);
                        }completion:nil];
    
}

//给tabbar自定义按钮或其他控件
- (void)setTabWithArray:(NSArray *)tabArray NormalImageArray:(NSArray *)normalArray SelectedImageArray:(NSArray *)selectedArray titles:(NSArray *)titles{
    
    self.viewControllers = tabArray;
    count = [tabArray count];
    if (tabArray.count > 0) {
        
        for (int i = 0; i < [tabArray count]; i ++) {
            ELButton *btn = [ELButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:[selectedArray objectAtIndex:i]] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:[normalArray objectAtIndex:i]] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = i ;
            if (btn.tag == 0)
                btn.selected = YES;
            else
                btn.selected = NO;
            btn.frame = CGRectMake(SCREENWIDTH/[tabArray count]*i, 0, SCREENWIDTH/[tabArray count], 49);
            
            [btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBarView addSubview:btn];
            [btnArray addObject:btn];
        }
    }
}

- (void)setTabWithArray:(NSArray *)tabArray NormalImageArray:(NSArray *)normalArray SelectedImageArray:(NSArray *)selectedArray NomalTitles:(NSArray *)nomalTitles SelectedTitles:(NSArray *)selectedTitles nomalTitleColor:(UIColor *)nomalColor selectedTitleColor:(UIColor *)selectedTitleColor nomalBackimage:(UIImage *)nomalBackimage selectedBackimage:(UIImage *)selectedBackimage
{
    self.viewControllers = tabArray;
    count = [tabArray count];
    if (tabArray.count > 0) {
        
        for (int i = 0; i < [tabArray count]; i ++) {
            ELButton *btn = [ELButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:[selectedArray objectAtIndex:i]] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:[normalArray objectAtIndex:i]] forState:UIControlStateNormal];
            
            [btn setTitle:[nomalTitles objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitle:[selectedTitles objectAtIndex:i] forState:UIControlStateSelected];
            [btn setTitleColor:nomalColor forState:UIControlStateNormal];
            [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
            [btn setBackgroundImage:nomalBackimage forState:UIControlStateNormal];
            [btn setBackgroundImage:selectedBackimage forState:UIControlStateSelected];
            btn.frame = CGRectMake(SCREENWIDTH/[tabArray count]*i, 0, SCREENWIDTH/[tabArray count], 49);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setBackgroundColor:[UIColor clearColor]];
            CGSize size = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font];
//            btn.titleLabel.backgroundColor = [UIColor redColor];
            btn.titleLabel.textAlignment = UITextAlignmentCenter;
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 18 , 0)];
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, -30 , 0)];
            btn.tag = i;
            if (btn.tag == 0)
                btn.selected = YES;
            
            else
                btn.selected = NO;
            
            
            [btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBarView addSubview:btn];
            [btnArray addObject:btn];
            
        }
    }

}

- (void)selectTab:(UIButton *)selectBtn{
    if(selectBtn.selected == NO)
    {
        
//        if(selectBtn.tag == 2)
//        {
//            if([[UserLoginInfoManager loginmanager] state])
//            {
//                
//            }
//            else
//            {
//                AppDelegate * dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [dele goLoginUser];
//                return;
//            }
//            
//        }
        
        NSInteger selectTag = selectBtn.tag;
        selectBtn.selected = YES;
        UIViewController *selectVC = [self.viewControllers objectAtIndex:selectTag];
        self.selectedViewController = selectVC;
        for(int i = 0; i < count; i++)
        {
            UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
            if (btn.tag != selectTag)
                btn.selected = NO;
            else
                btn.selected = YES;
        }
    }
    UINavigationController * nav = (UINavigationController *)self.selectedViewController;
    if([nav.viewControllers count]!=1)
    {
        [self hideTabBar:nil];
    }
    else
    {
        [self appearTabBar:nil];
    }
}

- (void)hideOriginalTab {
    NSArray *array = [self.view subviews];
    UIView *originalTabView = [array objectAtIndex:1];
    originalTabView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height, SCREENWIDTH, 49);
    originalTabView.backgroundColor = [UIColor clearColor];
    UIView *newTabView = [array objectAtIndex:0];
    newTabView.frame = CGRectMake(0, 0, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height);
    newTabView.backgroundColor = [UIColor redColor];
}




- (void)mTabSelectIndex:(NSNotification *)notify{
    NSInteger value = [[notify.userInfo objectForKey:@"TabSelectIndex"] integerValue];
    UIViewController *selectVC = [self.viewControllers objectAtIndex:value];
    self.selectedViewController = selectVC;
    for(int i = 0; i < count; i++) {
        UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
        if (btn.tag != value)
            btn.selected = NO;
        else
            btn.selected = YES;
    }
}

//madongkai自己写的
- (void)selectIndex:(int)index
{
    UIViewController *selectVC = [self.viewControllers objectAtIndex:index];
    self.selectedViewController = selectVC;
    for(int i = 0; i < count; i++) {
        UIButton *btn = (UIButton *)[btnArray objectAtIndex:i];
        if (btn.tag != index)
            btn.selected = NO;
        else
            btn.selected = YES;
    }
    
    UINavigationController * nav = (UINavigationController *)self.selectedViewController;
    if([nav.viewControllers count]!=1)
    {
        [self hideTabBar:nil];
    }
    else
    {
        [self appearTabBar:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
