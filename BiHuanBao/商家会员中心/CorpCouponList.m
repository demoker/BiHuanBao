//
//  CorpCouponList.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "CorpCouponList.h"
#import "CorpCouponTableCell.h"
#import "CorpCouponItem.h"
#import "CorpCommentsController.h"
#import "CorpCouponListController.h"
@interface CorpCouponList ()

@end

@implementation CorpCouponList
@synthesize dataarray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataarray = [[NSMutableArray alloc]init];
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:_mtableview.frame LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];
    
    self.view.backgroundColor = [UIColor clearColor];
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    [self download];
}
- (void)download
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&task=%@&ID=%@&PWD=%@",HTTP,CorpCouponListUrl,self.task,[[UserLoginInfoManager loginmanager] user], [[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        for(NSDictionary * dict in [dic objectForKey:@"datalist"])
        {
            CorpCouponItem * item = [[CorpCouponItem alloc]init];
            item.auto_id = [dict objectForKey:@"auto_id"];
            item.content_name = [dict objectForKey:@"content_name"];
            item.sub_title = [dict objectForKey:@"sub_title"];
            item.shop_type = [dict objectForKey:@"shop_type"];
            item.lj_num = [dict objectForKey:@"lj_num"];
            item.product_num = [dict objectForKey:@"product_num"];
            item.comment_num = [dict objectForKey:@"comment_num"];
            item.content_score = [dict objectForKey:@"content_score"];
            item.content_img = [dict objectForKey:@"content_img"];
            [dataarray addObject:item];
        }
        [_mtableview reloadData];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
        [self.view makeToast:NO_NET];
    }];
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataarray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.row%2 == 0)
   {
       CorpCouponTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CorpCouponTableCell"];
       if(cell == nil)
       {
           cell = [[[NSBundle mainBundle] loadNibNamed:@"CorpCouponTableCell" owner:self options:nil] lastObject];
       }
//       @property (weak, nonatomic) IBOutlet UIImageView *content_img;
//       @property (weak, nonatomic) IBOutlet UIImageView *shop_type_img;
//       @property (weak, nonatomic) IBOutlet UILabel *content_name;
//       @property (weak, nonatomic) IBOutlet UILabel *sub_title;
//       @property (weak, nonatomic) IBOutlet UILabel *lj_num;
//       @property (weak, nonatomic) IBOutlet ELStarRatingView *star
       CorpCouponItem * item = [dataarray objectAtIndex:indexPath.row/2];
       cell.content_name.text = item.sub_title;
       [cell.content_img setImageWithURL:[NSURL URLWithString:item.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
       cell.sub_title.text = item.content_name;
       cell.lj_num.text = item.lj_num;
       cell.star.rating = [item.content_score floatValue];
       cell.star.userInteractionEnabled = NO;
       cell.star.isFraction = NO;
       cell.comment_num.text = [NSString stringWithFormat:@"%@条",item.comment_num];
       if([item.shop_type integerValue]==1)
       {
           cell.shop_type_img.hidden = NO;
       }
       else
       {
           cell.shop_type_img.hidden = YES;
       }
       
       return cell;
   }
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        return 90;
    }
    else
    {
        return 10;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CorpCommentsController * comments = [[CorpCommentsController alloc] initWithNibName:@"CorpCommentsController" bundle:nil];
    comments.mitem = [[CorpCouponItem  alloc]init];
    comments.mitem = [dataarray objectAtIndex:indexPath.row/2];
    [[(CorpCouponListController *)self.delegate navigationController] pushViewController:comments animated:YES];
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
