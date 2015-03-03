//
//  BiAiTuanFinalViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BiHuanBaoFinalViewController.h"
#import "BiHuanBaoFinalViewCell.h"
#import "ProductFinalDetailCell.h"
#import "ProductFinalEvaluateCell.h"
#import "ProductEvaluateItem.h"
#import "NSString+Addtion.h"
#import "CLBCustomAlertView.h"
@interface BiHuanBaoFinalViewController ()

@end

@implementation BiHuanBaoFinalViewController
@synthesize navBar;
@synthesize evaluates;
@synthesize headView;

- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    float keyboardheight = keyboardRect.size.height;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //    _mtableview.frame = CGRectMake(10.0f, _mtableview.frame.origin.y, _mtableview.frame.size.width, SCREENHEIGHT-NAVHEIGHT-10-keyboardheight);
    
    for (NSLayoutConstraint *constraint in self.mtableview.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = keyboardheight;
        }
    }
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //    _mtableview.frame = CGRectMake(10, _mtableview.frame.origin.y, _mtableview.frame.size.width, SCREENHEIGHT-NAVHEIGHT-10);
    for (NSLayoutConstraint *constraint in self.mtableview.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = 44;
        }
    }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BackGround_Color;
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = self.titleName;
    
    self.number = @"1";
    
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];

    more = 1;
    [self.view addSubview:navBar];
    
    evaluates = [[NSMutableArray alloc] init];

    headView =[[ProductFinalHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*565.0/1080.0)];
    _mtableview.tableHeaderView = headView;
    
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    _mtableview.pullDelegate = self;
    _mtableview.pullBackgroundColor = [UIColor clearColor];
    
    [_yuyueBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchDown];
    
    sectionCell = [[[NSBundle mainBundle] loadNibNamed:@"ProductEvaluateSectionCell" owner:self options:nil] lastObject];
    UIImageView * v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 10)];
    UIImage * image = [UIImage imageNamed:@"yinying"];
    v.image = image;
    [sectionCell.contentView addSubview:v];
    
    [self download];
}

- (void)download
{
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@",HTTP,BiHuanBaoDetailUrl,self.auto_id];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = [(NSDictionary *)responseObject objectForKey:@"data"];
        
        self.corp_name = [[dic objectForKey:@"corp"] objectForKey:@"content_name"];
        self.rmb = [dic objectForKey:@"content_name"];
        self.content_price = [dic objectForKey:@"content_preprice"];
        self.region = OBJC_REPLACE([dic objectForKey:@"user_area"],@"无");
        self.xiaoliang = [dic objectForKey:@"day_num"];
        self.total_xiaoliang = [dic objectForKey:@"total_num"];
        self.kucun = [dic objectForKey:@"content_num"];
        self.star = [dic objectForKey:@"content_score"];
        self.type_str = [dic objectForKey:@"new_type"];
        self.corp_id = [[dic objectForKey:@"corp"] objectForKey:@"auto_id"];
        self.content_img = [dic objectForKey:@"content_img"];
        self.content_name = [dic objectForKey:@"sub_title"];
        
        [headView.defaultImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"content_img"]] placeholderImage:[UIImage imageNamed:@"no_phote_4x3"]];
        for(NSDictionary * d in [[(NSDictionary *)responseObject objectForKey:@"comment"] objectForKey:@"datalist"])
        {
            ProductEvaluateItem * item = [[ProductEvaluateItem alloc]init];
            if(![[d objectForKey:@"member"] isKindOfClass:[NSDictionary class]])
            {
                item.content_user = nil;
                item.content_face = nil;
            }
            else
            {
                item.content_user = [[d objectForKey:@"member"] objectForKey:@"content_user"];
                item.content_face = [[d objectForKey:@"member"] objectForKey:@"content_face"];
            }
            item.content_score = [d objectForKey:@"content_score"];
            item.content_body = OBJC([d objectForKey:@"content_body"]);
            item.create_time = [d objectForKey:@"create_time"];
            
            [evaluates addObject:item];
        }
        sectionCell.star.rating = [self.star integerValue];
        sectionCell.star.userInteractionEnabled = NO;
        sectionCell.star.isFraction = NO;
        sectionCell.content_number.text = [NSString stringWithFormat:@"%@人评价",[dic objectForKey:@"comment_num"]];
        [_mtableview reloadData];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadFailed];
        [self.view makeToast:NO_NET];
    }];
}

- (void)yuyueAction:(id)sender
{
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    if([[[UserLoginInfoManager loginmanager] isCorper] integerValue] == 2)
    {
        CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"商家会员不能进行此操作！" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
            [view dismiss];
        } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
            
        }];
        [alertView show];
        return;
    }
    
    //加入购物车
    [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&num=%@&auto_id=%@",HTTP,AddShopCarUrl,self.number,self.auto_id];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            Product * product = [[Product alloc]init];
            product.content_num = self.number;
            product.auto_id = self.auto_id;
            product.member_id = self.corp_id;
            product.content_img = self.content_img;
            product.content_price = self.content_price;
            product.content_name= self.content_name;
        
            
            Shop * shop = [[Shop alloc] init];
            shop.member_id = self.corp_id;
            shop.shop_name = self.corp_name;
            
            if([Shop existDbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",shop.member_id]])
            {
                [shop updatetoDb];
            }
            else
            {
                [shop insertToDb];
            }
            
            if([Product existDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id]])
            {
                Product * product2 = [[Product dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id] orderby:nil] lastObject];
                product2.content_num = [NSString stringWithFormat:@"%d",[product2.content_num integerValue]+[product.content_num integerValue]];
                [product2 updatetoDb];
            }
            else
            {
                [product insertToDb];
            }
        }
        CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:[dic objectForKey:@"msg"] leftButtonTitle:@"继续购物" leftActionBlock:^(CLBCustomAlertView *view) {
            [view dismiss];
        } rightButtonTitle:@"去结算" rightActionBlock:^(CLBCustomAlertView *view) {
            AppDelegate * dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [dele.tab selectIndex:1];
            [view dismiss];
        }];
        [alertView show];
         [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
    }];
    
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(section ==  0)
   {
       return 2;
   }
    else
    {
        return [evaluates count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            BiHuanBaoFinalViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BiHuanBaoFinalViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BiHuanBaoFinalViewCell" owner:self options:nil] lastObject];
            }
            cell.numTextField.text = self.number;
            cell.numTextField.delegate = self;
            [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchDown];
            [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchDown];
            [cell.addShopCar addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchDown];
            cell.content_name.text = self.corp_name;
            cell.content_price.text = self.content_price;
            cell.desc.text = self.rmb;
            cell.typeLabel.text = self.type_str;
            cell.region.text = self.region;
            if(self.xiaoliang != nil)
            {
                NSRange range = [[NSString stringWithFormat:@"七天销量%@件",self.xiaoliang] rangeOfString:self.xiaoliang];
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"七天销量%@件",self.xiaoliang]];
                //把this的字体颜色变为红色
                [attriString addAttribute:NSForegroundColorAttributeName
                                    value:UIColorFromRGB(0xff602a)
                                    range:NSMakeRange(range.location, range.length)];
                cell.xiaoliang.attributedText = attriString;
                
                
                cell.total_xiaoliang.text = [NSString stringWithFormat:@"总销量%@件",self.total_xiaoliang];
            }
            
            
            if(self.total_xiaoliang != nil)
            {
                NSRange range1 = [[NSString stringWithFormat:@"总销量%@件",self.total_xiaoliang] rangeOfString:self.total_xiaoliang];
                NSMutableAttributedString *attriString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总销量%@件",self.total_xiaoliang]];
                //把this的字体颜色变为红色
                [attriString1 addAttribute:NSForegroundColorAttributeName
                                     value:UIColorFromRGB(0xff602a)
                                     range:NSMakeRange(range1.location, range1.length)];
                cell.total_xiaoliang.attributedText = attriString1;
            }
            
            if(self.kucun != nil)
            {
                NSRange range2 = [[NSString stringWithFormat:@"%@件",self.kucun] rangeOfString:self.kucun];
                NSMutableAttributedString *attriString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@件",self.kucun]];
                //把this的字体颜色变为红色
                [attriString2 addAttribute:NSForegroundColorAttributeName
                                     value:UIColorFromRGB(0xff602a)
                                     range:NSMakeRange(range2.location, range2.length)];
                cell.kucun.attributedText = attriString2;
            }
            
            
            cell.star.rating = [self.star integerValue];
            cell.star.isFraction = NO;
            cell.star.userInteractionEnabled = NO;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.numTextField];
            
            return cell;
        }
        else
        {
            ProductFinalDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProductFinalDetailCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductFinalDetailCell" owner:self options:nil] lastObject];
            }
            cell.detailTextLabel.text = self.content_desc;
            return cell;
        }
    }
    else
    {
        ProductFinalEvaluateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProductFinalEvaluateCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductFinalEvaluateCell" owner:self options:nil] lastObject];
        }
        ProductEvaluateItem * item = [evaluates objectAtIndex:indexPath.row];

            cell.content_body.text = OBJC(item.content_body);
        cell.content_time.text = item.create_time;
        [cell.content_titleImg setImageWithURL:[NSURL URLWithString:item.content_face] placeholderImage:[UIImage imageNamed:@"no_phote"]];
        cell.content_user.text = item.content_user;
        cell.star.rating = [item.content_score integerValue];
        cell.userInteractionEnabled = NO;
        
        //        CGSize size = [item.content_body getcontentsizeWithfont:[UIFont systemFontOfSize:11] constrainedtosize:CGSizeMake(SCREENWIDTH-80, 200) linemode:NSLineBreakByWordWrapping];
        //
        //        cell.content_body.frame = CGRectMake(cell.content_body.frame.origin.x, cell.content_body.frame.origin.y, SCREENWIDTH-80, size.height+1);
        //        NSLog(@"%f",SCREENWIDTH-80);
        //        cell.back_img.frame = CGRectMake(cell.back_img.frame.origin.x, cell.back_img.frame.origin.y, cell.back_img.frame.size.width, (size.height+1+30>85)?(size.height+1+30+10):85);
        
        [cell.content_body sizeToFit];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return sectionCell;
    }
    else
    {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 54.f;
    }
    else
    {
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            return 220.f;
        }
        else
        {
            return 84.f;
        }
    }
    else
    {
        
            ProductEvaluateItem * item = [evaluates objectAtIndex:indexPath.row];
            CGSize size = [OBJC(item.content_body) getcontentsizeWithfont:[UIFont systemFontOfSize:10] constrainedtosize:CGSizeMake(SCREENWIDTH-120, 200) linemode:NSLineBreakByWordWrapping];
            return size.height+35+20>85?size.height+35+20:85;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if(indexPath.row == 4)
    {
        [_mtableview setPullTableIsLoadingMore:YES];
    }
}

#pragma mark - 加载更多
#pragma mark - 刷新
- (void)pullTableViewDidTriggerRefresh:(TableView *)pullTableView
{
    [self performSelector:@selector(update) withObject:nil afterDelay:0.5];
}
- (void)update
{
    [self.indicator setIndicatorType:ActivityIndicatorDefault];
    [self download];
    [_mtableview setPullTableIsRefreshing:NO];
}

- (void)pullTableViewDidTriggerLoadMore:(TableView *)pullTableView
{
    [self performSelector:@selector(loadmore) withObject:nil afterDelay:1.0];
}
- (void)loadmore
{
    [_mtableview setPullTableIsLoadingMore:NO];
    more++;
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&page=%d&row=10",HTTP,BiAiTuanMoreCommentsUrl,self.auto_id,more];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        for(NSDictionary * d in [dic objectForKey:@"datalist"] )
        {
            ProductEvaluateItem * item = [[ProductEvaluateItem alloc]init];
            item.content_user = [[d objectForKey:@"member"] objectForKey:@"content_user"];
            item.content_face = [[d objectForKey:@"member"] objectForKey:@"content_face"];
            item.content_score = [d objectForKey:@"content_score"];
            item.content_body = [d objectForKey:@"content_body"];
            item.create_time = [d objectForKey:@"create_time"];
            
            [evaluates addObject:item];
            if([evaluates count]!=0)
            {
                [_mtableview reloadData];
                [self.indicator LoadSuccess];
            }
            else
            {
                [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:NO_DATA_DESC];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(more == 1)
        {
            
        }
        else
        {
            more --;
            [self.view makeToast:NO_NET];
        }
    }];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.number = [NSString stringWithFormat:@"%d",[[textField text] integerValue]];
    [_mtableview reloadData];
}

#pragma mark - 加减
- (BiHuanBaoFinalViewCell *)getTextFieldCell
{
    BiHuanBaoFinalViewCell * cell = (BiHuanBaoFinalViewCell *)[_mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell;
}
- (void)validationAction:(NSIndexPath *)indexpath andN:(int)num
{
    BiHuanBaoFinalViewCell * cell = [self getTextFieldCell];
    
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&num=%d",HTTP,ShopCarEditUrl,self.auto_id,num];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            
            cell.numTextField.text = [NSString stringWithFormat:@"%d",num];
            
        }
        else
        {
            [self.view makeToast:[dic objectForKey:@"msg"]];
            cell.numTextField.text = self.defaultNumber;
            
        }
        self.number = cell.numTextField.text;
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
        [self.view makeToast:NO_NET];
    }];
}

- (void)subAction:(id)sender
{
    BiHuanBaoFinalViewCell * cell = [self getTextFieldCell];

    int n = [cell.numTextField.text integerValue];
    self.defaultNumber = cell.numTextField.text ;
    if(n == 1)
    {
        
    }
    else
    {
        [self validationAction:nil andN:--n];
    }
}
- (void)addAction:(id)sender
{
    BiHuanBaoFinalViewCell * cell = [self getTextFieldCell];
    int n = [cell.numTextField.text integerValue];
    self.defaultNumber = cell.numTextField.text ;
    [self validationAction:nil andN:++n];
}

#pragma mark - 输入框文字检测

- (void)textFieldChanged:(NSNotification *)noti {
    
    UITextField * textfield = noti.object;
    if(textfield.text.length == 0)
    {
        
    }
    else
    {
        [self validationAction:nil andN:[[textfield text] integerValue]];
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
