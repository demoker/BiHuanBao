//
//  CorpSongBiOneController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/3.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "CorpSongBiOneController.h"
#import "CorpSongBiTwoController.h"
@interface CorpSongBiOneController ()

@end

@implementation CorpSongBiOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BackGround_Color;
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.text = @"送币营销";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];
    [self download];
    [_song_btn addTarget:self action:@selector(songAction:) forControlEvents:UIControlEventTouchDown];
}
- (void)songAction:(UIButton *)sender
{
    //跳转到送币界面
    CorpSongBiTwoController * corp_song = [[CorpSongBiTwoController alloc]initWithNibName:@"CorpSongBiTwoController" bundle:nil];
    corp_song.auto_id = self.auto_id;
    corp_song.corp_id = self.corp_id;
    corp_song.yu_e = self.ye_price;
    [self.navigationController pushViewController:corp_song animated:YES];
}

- (void)download
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,CorpSongBiUrl,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if(![[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
        {
            _no_kai_view.hidden = NO;
            _had_kai_view.hidden = YES;
        }
        else
        {
            _no_kai_view.hidden = YES;
            _had_kai_view.hidden = NO;
            
            self.content_name = [[dic objectForKey:@"data"] objectForKey:@"content_name"];
            self.content_stotal = [[dic objectForKey:@"data"] objectForKey:@"content_stotal"];
            self.true_price = [[dic objectForKey:@"data"] objectForKey:@"true_price"];
            self.book_price = [[dic objectForKey:@"data"] objectForKey:@"book_price"];
            self.content_status = [[dic objectForKey:@"data"] objectForKey:@"content_status"];
            self.ye_price = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"] objectForKey:@"ye_price"]];
            self.auto_id = [[dic objectForKey:@"data"] objectForKey:@"auto_id"];
            self.corp_id = [[dic objectForKey:@"data"] objectForKey:@"member_id"];
            
//            content_name
//            content_stotal
//            true_price
//            book_price
//            content_status
//            ye_price
//            auto_id
            self.total_label.text = self.content_stotal;
            self.had_label.text = self.true_price;
            self.yu_e_label.text = self.ye_price;
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
