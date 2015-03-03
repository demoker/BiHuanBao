//
//  CouponDetailViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "QRCodeGenerator.h"
@interface CouponDetailViewController ()

@end

@implementation CouponDetailViewController
@synthesize mitem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    @property (retain, nonatomic) NSString * content_name;
//    @property (retain, nonatomic) NSString * content_img;
//    @property (retain, nonatomic) NSString * s_code;
//    @property (retain, nonatomic) NSString * shop_type;
//    @property (retain, nonatomic) NSString * is_use;
//    @property (retain, nonatomic) NSString * is_comment;
//    @property (retain, nonatomic) NSString * auto_id;
//    @property (retain, nonatomic) NSString * product_id;
//    @property (retain, nonatomic) NSString * is_return;
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"券详情";
    [self.view addSubview:navBar];
    
    if([mitem.shop_type integerValue] == 0)
    {
        _tag_icon.hidden = YES;
    }
    [_content_img setImageWithURL:[NSURL URLWithString:mitem.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
    _desc.text = mitem.content_name;
    _pass_key.text = mitem.s_code;
    
    _top_backView.layer.borderColor = [UIColorFromRGB(0xff602a) CGColor];
    _top_backView.layer.borderWidth = 1;
    
    NSString * code = [NSString stringWithFormat:@"%@",mitem.s_code];
    NSLog(@"%@",code);
    UIImage * image = [QRCodeGenerator qrImageForString:code imageSize:_qrcodeImg.frame.size.width];
    [_qrcodeImg setImage:image];
    
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
