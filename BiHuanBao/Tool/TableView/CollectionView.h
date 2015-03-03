//
//  CollectionView.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/23.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInterceptor.h"
#import "LoadMoreTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
@class CollectionView;

@protocol CollectionViewDelegate <NSObject>

- (void)pullTableViewDidTriggerLoadMore:(CollectionView*)pullTableView;
@optional
- (void)pullTableViewDidTriggerRefresh:(CollectionView*)pullTableView;
@end


@protocol TouchCollectionViewDelegate <NSObject>

@optional

- (void)collectionView:(UICollectionView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;
- (void)collectionView:(UICollectionView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;



- (void)collectionView:(UICollectionView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)collectionView:(UICollectionView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;


@end@interface CollectionView : UICollectionView<LoadMoreTableFooterDelegate,UIGestureRecognizerDelegate,EGORefreshTableHeaderDelegate>{
    
    
    
    // Since we use the contentInsets to manipulate the view we need to store the the content insets originally specified.
    UIEdgeInsets realContentInsets;
    
    // For intercepting the scrollView delegate messages.
    MessageInterceptor * delegateInterceptor;
    
    // Config
    UIImage *pullArrowImage;
    UIColor *pullBackgroundColor;
    UIColor *pullTextColor;
    NSDate *pullLastRefreshDate;
    
    // Status
    BOOL pullTableIsRefreshing;
    BOOL pullTableIsLoadingMore;
    
    // Delegate
    
}




@property (retain, nonatomic) EGORefreshTableHeaderView *refreshView;

@property (retain, nonatomic) LoadMoreTableFooterView *loadMoreView;


/* The configurable display properties of PullTableView. Set to nil for default values */
@property (nonatomic, retain) UIImage *pullArrowImage;
@property (nonatomic, retain) UIColor *pullBackgroundColor;
@property (nonatomic, retain) UIColor *pullTextColor;

/* Set to nil to hide last modified text */
@property (nonatomic, retain) NSDate *pullLastRefreshDate;

/* Properties to set the status of the refresh/loadMore operations. */
/* After the delegate methods are triggered the respective properties are automatically set to YES. After a refresh/reload is done it is necessary to set the respective property to NO, otherwise the animation won't disappear. You can also set the properties manually to YES to show the animations. */
@property (nonatomic, assign) BOOL pullTableIsRefreshing;
@property (nonatomic, assign) BOOL pullTableIsLoadingMore;

/* Delegate */
@property (nonatomic, assign) id<CollectionViewDelegate> pullDelegate;
@property (nonatomic, assign) NSInteger index;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end
