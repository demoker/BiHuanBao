//
//  MyCouponViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/9.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "MyCouponViewController.h"

@interface MyCouponViewController ()

@end

@implementation MyCouponViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:EvaluateQuanNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:RefundQuanNotification object:nil];
    
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"我的券";
    [self.view addSubview:navBar];

    
    no_list = [[CouponListViewController alloc]initWithNibName:@"CouponListViewController" bundle:nil];
    no_list.task = @"unprolist";
    no_list.delegate = self;
    no_list.view.frame = CGRectMake(0, _operationView.frame.size.height+_operationView.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-(_operationView.frame.size.height+_operationView.frame.origin.y)-20);
    
    no_list.mtableview.frame = CGRectMake(5, 0, SCREENWIDTH-10, SCREENHEIGHT-(_operationView.frame.size.height+_operationView.frame.origin.y));
    
    [self.view addSubview:no_list.view];
    
    did_list = [[CouponListViewController alloc]initWithNibName:@"CouponListViewController" bundle:nil];
    did_list.task = @"okprolist";
    did_list.delegate = self;
    did_list.view.frame = CGRectMake(0, _operationView.frame.size.height+_operationView.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-(_operationView.frame.size.height+_operationView.frame.origin.y)-20);
    
    did_list.mtableview.frame = CGRectMake(5, 0, SCREENWIDTH-10, SCREENHEIGHT-(_operationView.frame.size.height+_operationView.frame.origin.y));
    [self.view addSubview:did_list.view];
    
    did_list.view.hidden = YES;
    
    [_no_use_btn addTarget:self action:@selector(transAction:) forControlEvents:UIControlEventTouchDown];
    [_did_use_btn addTarget:self action:@selector(transAction:) forControlEvents:UIControlEventTouchDown];
}
- (void)receiverNotification:(NSNotification *)noti
{
    if([noti.name isEqual:EvaluateQuanNotification])
    {
        [did_list update];
        [no_list update];
    }
}

- (void)transAction:(UIButton *)sender
{
    if(sender == _no_use_btn)
    {
        [_no_use_btn setBackgroundImage:[UIImage imageNamed:@"l"] forState:UIControlStateNormal];
        [_did_use_btn setBackgroundImage:[UIImage imageNamed:@"rr"] forState:UIControlStateNormal];
        no_list.view.hidden = NO;
        did_list.view.hidden = YES;
    }
    else
    {
        [_no_use_btn setBackgroundImage:[UIImage imageNamed:@"ll"] forState:UIControlStateNormal];
        [_did_use_btn setBackgroundImage:[UIImage imageNamed:@"r"] forState:UIControlStateNormal];
        no_list.view.hidden = YES;
        did_list.view.hidden = NO;
    }
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
