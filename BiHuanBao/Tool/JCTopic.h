//
//  JCTopic.h
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import <UIKit/UIKit.h>
#import "NSTimer+Addition.h"

typedef enum {
    
    JCTopicTransverse,//横向
    
    JCTopicLongitudinal//纵向
    
}JCTopicType;

@class JCTopic;
@protocol JCTopicDelegate<NSObject>
-(void)didClick:(id)data withscrollview:(JCTopic *)jc;
-(void)currentPage:(int)page total:(NSUInteger)total withscrollview:(JCTopic *)jc;
@end
@interface JCTopic : UIScrollView<UIScrollViewDelegate>{
    UIButton * pic;
    bool flag;
    int scrollTopicFlag;
    NSTimer * scrollTimer;
    int currentPage;
    CGSize imageSize;
    UIImage *image;
}
@property(nonatomic,strong)NSArray * pics;
@property(nonatomic,retain)id<JCTopicDelegate> JCdelegate;
@property(nonatomic,assign) JCTopicType topicType;
@property(nonatomic,retain) NSString * cellClass;
@property(nonatomic,retain) NSString * adjust;
- (id)initWithFrame:(CGRect)frame withJCTopicType:(JCTopicType)type;
- (id)initWithFrame:(CGRect)frame withJCTopicType:(JCTopicType)type Class:(NSString *)cla;

-(void)releaseTimer;
-(void)upDate;
- (void)pauseTimer;
-(void)continueTimer;
@end
