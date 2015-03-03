//
//  MyFlowLayout.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/3.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFlowLayout : UICollectionViewFlowLayout
/** 要布局的列数*/
@property(nonatomic,assign)int numberOfColumns;
/** 行间距*/
@property(nonatomic,assign)CGFloat lineSpace;
/** 列间距*/
@property(nonatomic,assign)CGFloat columnsSpace;
/** section 的 上 左 下 右 边 ：top, left, bottom, right */
@property(nonatomic,assign)UIEdgeInsets sectionInsert;

@end
