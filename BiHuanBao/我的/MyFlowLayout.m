//
//  MyFlowLayout.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/3.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "MyFlowLayout.h"

@interface MyFlowLayout()
{
    //item的宽度是
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}
@end


@implementation MyFlowLayout
/**
 *  布局之前的准备
 *
 */
-(void)prepareLayout{
    
    [super prepareLayout];
    
    //    _itemWidth = 100;
    //    _itemHeight = 180;
    //我这里是 宽度是不定 变化的  你就按照我的算法 颠倒着算下就好了。
    
    //(SCREENWIDTH-100*3)/8
    
    self.lineSpace =20;
    self.columnsSpace = 20;
    self.numberOfColumns = 3;
    //四周的边距 上，左，下，右
//    self.sectionInsert = UIEdgeInsetsMake((SCREENWIDTH-100*3)/8, (SCREENWIDTH-100*3)/8, (SCREENWIDTH-100*3)/8, (SCREENWIDTH-100*3)/8);
     self.sectionInsert = UIEdgeInsetsMake(20, 40, 20, 40);
    
    //布局的可用宽度
    CGFloat fullWidth = self.collectionView.frame.size.width-(self.sectionInsert.left+self.sectionInsert.right);
    
    //获取可用的布局空间的宽度 item可用的区域
    CGFloat avaliableSpaceExcludingPadding = fullWidth - (self.columnsSpace*(self.numberOfColumns-1));
    //item的宽度是
    _itemWidth = (avaliableSpaceExcludingPadding/self.numberOfColumns);
    _itemHeight = _itemWidth;
    
    //item 之间的 行、列间距
    self.minimumInteritemSpacing = 20;
    self.minimumLineSpacing = self.lineSpace;
    
    //初始化 宽高
    self.itemSize = CGSizeMake(100, 180);
    self.sectionInset = self.sectionInsert;
    
}
@end
