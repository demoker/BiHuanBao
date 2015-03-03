//
//  CorpCouponListController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "CorpCouponListController.h"

@interface CorpCouponListController ()

@end

@implementation CorpCouponListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"我的券";
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = BackGround_Color;
    
    _no_list = [[CorpCouponList alloc]initWithNibName:@"CorpCouponList" bundle:nil];
    _no_list.task = @"appunprolist";
    _no_list.delegate = self;
    _no_list.view.frame = CGRectMake(10, _backView.frame.size.height+_backView.frame.origin.y, SCREENWIDTH-20, SCREENHEIGHT-(_backView.frame.size.height+_backView.frame.origin.y));
    _no_list.mtableview.frame = CGRectMake(0, 0, SCREENWIDTH-20, SCREENHEIGHT-(_backView.frame.size.height+_backView.frame.origin.y));
    
    [self.view addSubview:_no_list.view];
    
    _did_list = [[CorpCouponList alloc]initWithNibName:@"CorpCouponList" bundle:nil];
    _did_list.delegate = self;
    _did_list.task = @"okprolist";
    _did_list.view.frame = CGRectMake(10, _backView.frame.size.height+_backView.frame.origin.y, SCREENWIDTH-20, SCREENHEIGHT-(_backView.frame.size.height+_backView.frame.origin.y));
    _did_list.mtableview.frame = CGRectMake(0, 0, SCREENWIDTH-20, SCREENHEIGHT-(_backView.frame.size.height+_backView.frame.origin.y));
    _did_list.view.hidden = YES;
    [self.view addSubview:_did_list.view];
    
    [_no_useBtn addTarget:self action:@selector(no_Action:) forControlEvents:UIControlEventTouchDown];
    [_did_useBtn addTarget:self action:@selector(did_Action:) forControlEvents:UIControlEventTouchDown];
}

- (void)no_Action:(UIButton *)sender
{
    [_no_useBtn setBackgroundImage:[UIImage imageNamed:@"yuyue_btn.png"] forState:UIControlStateNormal];
    [_did_useBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn_bg.png"] forState:UIControlStateNormal];
    _no_list.view.hidden = NO;
    _did_list.view.hidden = YES;
}
- (void)did_Action:(UIButton *)sender
{
    [_no_useBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn_bg.png"] forState:UIControlStateNormal];
    [_did_useBtn setBackgroundImage:[UIImage imageNamed:@"yuyue_btn.png"] forState:UIControlStateNormal];
    _no_list.view.hidden = YES;
    _did_list.view.hidden = NO;
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
