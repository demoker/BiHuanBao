//
//  ELTabBar.h
//  HJMDrawer
//
//  Created by elongtian on 14-3-13.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELTabBar : UITabBarController
@property (strong, nonatomic) UIView * tabBarView;

-(void)setTabWithArray:(NSArray *)tabArray NormalImageArray:(NSArray *)normalArray SelectedImageArray:(NSArray *)selectedArray titles:(NSArray *)titles;
- (void)setTabWithArray:(NSArray *)tabArray NormalImageArray:(NSArray *)normalArray SelectedImageArray:(NSArray *)selectedArray NomalTitles:(NSArray *)nomalTitles SelectedTitles:(NSArray *)selectedTitles nomalTitleColor:(UIColor *)nomalColor selectedTitleColor:(UIColor *)selectedTitleColor nomalBackimage:(UIImage *)nomalBackimage selectedBackimage:(UIImage *)selectedBackimage;

- (void)selectIndex:(int)index;

@end
