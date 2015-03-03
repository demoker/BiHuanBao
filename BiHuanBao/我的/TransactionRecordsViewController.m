//
//  TransactionRecordsViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "TransactionRecordsViewController.h"
#import "TransRecordsItem.h"
@interface TransactionRecordsViewController ()

@end

@implementation TransactionRecordsViewController
@synthesize widths;
@synthesize orgions;
@synthesize tags;
@synthesize dataarray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.text = @"交易记录";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];
    
    _mtableview.pullDelegate = self;
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    float width = (SCREENWIDTH-5)/14.0+5;
    
    more = 1;
    orgions = @[[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:2*width+1],[NSNumber numberWithFloat:4*width+2],[NSNumber numberWithFloat:6*width+3],[NSNumber numberWithFloat:7*width+4],[NSNumber numberWithFloat:9*width+5]];
    widths = @[[NSNumber numberWithFloat:2*width],[NSNumber numberWithFloat:2*width],[NSNumber numberWithFloat:2*width],[NSNumber numberWithFloat:width],[NSNumber numberWithFloat:2*width],[NSNumber numberWithFloat:SCREENWIDTH-(9*width+5)]];
    
    dataarray = [[NSMutableArray alloc]init];
    
    tags = [NSArray arrayWithObjects:@"编号",@"具体内容",@"金额(BTC)",@"收支",@"时间",@"订单号", nil];
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];

    
    [self download];
}

- (void)download
{
    if(more == 1)
    {
        [self.indicator startAnimatingActivit];
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@&app_com=%@&ID=%@&PWD=%@&page=%d&per=1&row=10",HTTP,JiaoYiJiLuUrl,self.app_com,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd],more];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(more == 1)
        {
            [dataarray removeAllObjects];
        }
        NSDictionary * dict = (NSDictionary *)responseObject;
        for(NSDictionary * dic in [dict objectForKey:@"datalist"])
        {
            TransRecordsItem * item = [[TransRecordsItem alloc]init];
            item.auto_id = [dic objectForKey:@"auto_id"];
            item.content_item = [dic objectForKey:@"content_item"];
            item.content_sn = [dic objectForKey:@"content_sn"];
            item.content_status = [dic objectForKey:@"content_status"];
            item.content_value = [dic objectForKey:@"content_value"];
            item.create_time = [dic objectForKey:@"create_time"];
            item.content_type = [dic objectForKey:@"content_type"];
            [dataarray addObject:item];
        }
        
        _sum.text = [dict objectForKey:@"cost"];
        _yu_e.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sum"]];
        
        if([[dict objectForKey:@"datalist"] count]==0&&more>1)
        {
            more --;
            [self.view makeToast:NO_MORE_DATA];
        }
        
        if([dataarray count]!=0)
        {
            [_mtableview reloadData];
            [self.indicator LoadSuccess];
        }
        else
        {
            [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:NO_DATA_DESC];
        }

        
        [_mtableview reloadData];
        [self.indicator LoadSuccess];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataarray count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView * line_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        line_img.tag = 99;
        [line_img setImage:[UIImage imageNamed:@"level_line"]];
        [cell.contentView addSubview:line_img];
        
        for(int i = 0;i<6;i++)
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake([[orgions objectAtIndex:i] floatValue], 0, [[widths objectAtIndex:i] floatValue], 30)];
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 100+i;
            label.numberOfLines = 0;
            [cell.contentView addSubview:label];
            if(i!=5)
            {
                UIImageView * line_img = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 0, 1, label.frame.size.height)];
                [line_img setImage:[UIImage imageNamed:@"suxian"]];
                [cell.contentView addSubview:line_img];
            }
            else
            {
                
            }
            UIImageView * bottom_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 1)];
            [bottom_line setImage:[UIImage imageNamed:@"level_line"]];
            [cell.contentView addSubview:bottom_line];
            
        }
        
        
        
        
    }
    
    
    UILabel * label1 = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel * label2 = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel * label3 = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel * label4 = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel * label5 = (UILabel *)[cell.contentView viewWithTag:104];
    UILabel * label6 = (UILabel *)[cell.contentView viewWithTag:105];
    
    UIImageView * top_line = (UIImageView *)[cell.contentView viewWithTag:99];
    
    if(indexPath.row == 0)
    {
        top_line.hidden = NO;
        label1.text = [tags objectAtIndex:0];
        label2.text = [tags objectAtIndex:1];
        label3.text = [tags objectAtIndex:2];
        label4.text = [tags objectAtIndex:3];
        label5.text = [tags objectAtIndex:4];
        label6.text = [tags objectAtIndex:5];
        
        label1.textColor = UIColorFromRGB(0xff602a);
        label2.textColor = UIColorFromRGB(0xff602a);
        label3.textColor = UIColorFromRGB(0xff602a);
        label4.textColor = UIColorFromRGB(0xff602a);
        label5.textColor = UIColorFromRGB(0xff602a);
        label6.textColor = UIColorFromRGB(0xff602a);
    }
    else
    {
        top_line.hidden = YES;
        TransRecordsItem * item = [dataarray objectAtIndex:indexPath.row-1];
        label1.text = [NSString stringWithFormat:@"%d",indexPath.row];
        label2.text = item.content_item;
        label3.text = item.content_value;
        label4.text = item.content_status;
        label5.text = item.create_time;
        label6.text = item.content_sn;
        
        label1.textColor = UIColorFromRGB(0x555555);
        label2.textColor = UIColorFromRGB(0x555555);
        label3.textColor = UIColorFromRGB(0x555555);
        label4.textColor = UIColorFromRGB(0x555555);
        label5.textColor = UIColorFromRGB(0x555555);
        label6.textColor = UIColorFromRGB(0x555555);
    }

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.f;
}
#pragma mark - 加载更多
- (void)pullTableViewDidTriggerRefresh:(TableView *)pullTableView
{
    [self performSelector:@selector(update) withObject:nil afterDelay:0.3];
}
- (void)update
{
    [_mtableview setPullTableIsRefreshing:NO];
    more = 1;
    [self download];
}

- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{
    [self performSelector:@selector(loadmore) withObject:nil afterDelay:0.3];
}
- (void)loadmore
{
    more++;
    [self download];
    [_mtableview setPullTableIsLoadingMore:NO];
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
