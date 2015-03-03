//
//  TNTableView.h
//  TNMode
//
//  Created by elongtian on 13-9-14.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInterceptor.h"
#import "LoadMoreTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
@class TableView;

@protocol TableViewDelegate <NSObject>

- (void)pullTableViewDidTriggerLoadMore:(TableView*)pullTableView;
@optional
- (void)pullTableViewDidTriggerRefresh:(TableView*)pullTableView;
@end


@protocol TouchTableViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;



- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;


@end

@interface TableView : UITableView <LoadMoreTableFooterDelegate,UIGestureRecognizerDelegate,EGORefreshTableHeaderDelegate>{
    
    
    
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
    id<TableViewDelegate> pullDelegate;
    
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
@property (nonatomic, assign) id<TableViewDelegate> pullDelegate;
@property (nonatomic, assign) NSInteger index;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (void)loaddataToheadview:(NSMutableArray *)dataarray;

- (void)CreateHeadview:(NSArray *)types andindex:(int)indx;
@end

