//
//  EvaluateViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/14.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "ELTextView.h"
#import "EvaluateViewCell.h"
#import "OrderProItem.h"
@interface EvaluateViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    JRNavgationBar * navBar;
    float keyboardheight;
    EvaluateViewCell * currentCell;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) ELTextView * currenttextView;
@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * content_type;
@property (retain, nonatomic) NSString * review_id;
@property (retain, nonatomic) OrderProItem * mitem;
@property (assign, nonatomic) BOOL is_order;//订单产品评价
@end
