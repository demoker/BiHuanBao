//
//  MyModifyViewController.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-20.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "BaseViewController.h"
@protocol MyModifyDelegate<NSObject>
- (void)modifyFinished:(NSString *)str index:(NSInteger)index;//退出
@end
@interface MyModifyViewController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (retain, nonatomic) IBOutlet ELTextField *TextFieldOne;
@property (retain, nonatomic) IBOutlet ELTextField *TextFieldTwo;
@property (retain, nonatomic) IBOutlet ELTextField *TextFieldThree;
@property (assign, nonatomic) NSInteger type;


@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * email;
@property (retain, nonatomic) NSString * sex;
@property (retain, nonatomic) NSString * birthday;
@property (retain, nonatomic) NSString * mobile;
@property (assign, nonatomic) id <MyModifyDelegate> delegate;
@end
