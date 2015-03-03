//
//  JCTopic.m
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import "JCTopic.h"
#import "NSString+Addtion.h"
@implementation JCTopic
@synthesize JCdelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.cellClass = @"UIImageView";
        self.topicType = JCTopicTransverse;
        [self setSelf];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withJCTopicType:(JCTopicType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.cellClass = @"UIImageView";
        self.topicType = type;
        [self setSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withJCTopicType:(JCTopicType)type Class:(NSString *)cla
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellClass = cla;
        self.frame = frame;
        self.topicType = type;
        [self setSelf];
    }
    return self;
}

-(void)setSelf{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setSelf];
    
    // Drawing code
}
-(void)upDate{
    NSMutableArray * tempImageArray = [[NSMutableArray alloc]init];
    
    [tempImageArray addObject:[self.pics lastObject]];
    for (id obj in self.pics) {
        [tempImageArray addObject:obj];
    }
    [tempImageArray addObject:[self.pics objectAtIndex:0]];
    self.pics = Nil;
    self.pics = tempImageArray;
    
    int i = 0;
    for (id obj in self.pics) {
        pic= Nil;
        pic = [UIButton buttonWithType:UIButtonTypeCustom];
        pic.imageView.contentMode = UIViewContentModeTop;
        if(self.topicType == JCTopicTransverse)
        {
        [pic setFrame:CGRectMake(i*self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
        }
        else
        {
        [pic setFrame:CGRectMake(0,self.frame.size.height*i, self.frame.size.width, self.frame.size.height)];
        }
        
        if([self.cellClass isEqualToString:@"UIImageView"])
        {
            UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pic.frame.size.width, pic.frame.size.height)];
            // tempImage.contentMode = UIViewContentModeScaleAspectFill;
            [tempImage setClipsToBounds:YES];
            if ([[obj objectForKey:@"isLoc"]boolValue]) {
                [tempImage setImage:[obj objectForKey:@"pic"]];
            }else{
                if ([obj objectForKey:@"placeholderImage"]) {
                    [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
                }
                [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[obj objectForKey:@"pic"]]]
                                                   queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                                       if (!error && responseCode == 200) {
                                                           tempImage.image = Nil;
                                                           UIImage *_img = [[UIImage alloc] initWithData:data];
                                                           [tempImage setImage:_img];
                                                       }else{
                                                           if ([obj objectForKey:@"placeholderImage"]) {
                                                               [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
                                                           }
                                                       }
                                                   }];
            }
            [pic addSubview:tempImage];
           
        }
        else
        {
            pic.titleLabel.numberOfLines = 1;
            pic.titleLabel.font = [UIFont systemFontOfSize:12];
            pic.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [pic setTitle:[NSString stringWithFormat:@" %@",[obj objectForKey:@"title"]] forState:UIControlStateNormal];
        }
        [pic setBackgroundColor:[UIColor clearColor]];
        
        pic.tag = i;
        [pic addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pic];
        
        if([self.adjust isEqualToString:@"adjust"])
        {
            UIView * bg_view = [[UIView alloc]initWithFrame:CGRectMake(10+i*self.frame.size.width, self.frame.size.height-100, 150, 80)];
            UILabel * content_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 0, 0)];
            [content_name setBackgroundColor:[UIColor clearColor]];
            [content_name setAlpha:.7f];
             [content_name setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [content_name setText:[NSString stringWithFormat:@" %@",[obj objectForKey:@"content_name"]]];
            content_name.numberOfLines = 0;
            [content_name setTextColor:[UIColor whiteColor]];
            CGSize _size = [content_name.text getcontentsizeWithfont:content_name.font constrainedtosize:CGSizeMake(130, 30) linemode:NSLineBreakByCharWrapping];
            content_name.frame = CGRectMake(content_name.frame.origin.x, content_name.frame.origin.y, _size.width, _size.height);
            [bg_view addSubview:content_name];
            
            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(10,content_name.frame.size.height+10, 130,80)];
            [title setBackgroundColor:[UIColor clearColor]];
            [title setAlpha:.7f];
            [title setText:[NSString stringWithFormat:@" %@",[obj objectForKey:@"title"]]];
            title.numberOfLines = 0;
            [title setTextColor:[UIColor whiteColor]];
            [title setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            CGSize size = [title.text getcontentsizeWithfont:title.font constrainedtosize:CGSizeMake(130, 70) linemode:NSLineBreakByCharWrapping];
            title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, size.width, size.height);
            [bg_view addSubview:title];
            
            bg_view.frame = CGRectMake(bg_view.frame.origin.x, bg_view.frame.origin.y, bg_view.frame.size.width, content_name.frame.size.height+title.frame.size.height+20);
            bg_view.backgroundColor = [UIColor blackColor];
            bg_view.backgroundColor = [bg_view.backgroundColor colorWithAlphaComponent:0.7];
            
            //[self addSubview:bg_view];
        }
        else
        {
            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(i*self.frame.size.width, self.frame.size.height-30, self.frame.size.width,30)];
            [title setBackgroundColor:[UIColor blackColor]];
            //        [title sette
            [title setAlpha:.7f];
            [title setText:[NSString stringWithFormat:@" %@",[obj objectForKey:@"title"]]];
            [title setTextColor:[UIColor whiteColor]];
            [title setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [self addSubview:title];
        }
        i ++;
    }
    if(self.topicType == JCTopicTransverse)
    {
        [self setContentSize:CGSizeMake(self.frame.size.width*[self.pics count], self.frame.size.height)];
        [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }
    else
    {
        [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height*[self.pics count])];
        [self setContentOffset:CGPointMake(0, self.frame.size.height) animated:NO];
    }
    
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
    if ([self.pics count]>3) {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
}
-(void)click:(id)sender{
    [JCdelegate didClick:sender withscrollview:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.topicType == JCTopicTransverse)
    {
        CGFloat Width=self.frame.size.width;
        if (scrollView.contentOffset.x == self.frame.size.width) {
            flag = YES;
        }
        if (flag) {
            if (scrollView.contentOffset.x <= 0) {
                [self setContentOffset:CGPointMake(Width*([self.pics count]-2), 0) animated:NO];
            }else if (scrollView.contentOffset.x >= Width*([self.pics count]-1)) {
                [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            }
        }
        currentPage = scrollView.contentOffset.x/self.frame.size.width-1;
    }
    else
    {
        CGFloat Height=self.frame.size.height;
        if (scrollView.contentOffset.y == self.frame.size.height) {
            flag = YES;
        }
        if (flag) {
            if (scrollView.contentOffset.y <= 0) {
                [self setContentOffset:CGPointMake(0, Height*([self.pics count]-2)) animated:NO];
            }else if (scrollView.contentOffset.y >= Height*([self.pics count]-1)) {
                [self setContentOffset:CGPointMake(0, self.frame.size.height) animated:NO];
            }
        }
        currentPage = scrollView.contentOffset.y/self.frame.size.height-1;
    }
    [JCdelegate currentPage:currentPage total:[self.pics count]-2 withscrollview:self];
    scrollTopicFlag = currentPage+2==2?2:currentPage+2;
}
-(void)scrollTopic{
    if(self.topicType == JCTopicTransverse)
    {
        [self setContentOffset:CGPointMake(self.frame.size.width*scrollTopicFlag, 0) animated:YES];
    }
    else
    {
        [self setContentOffset:CGPointMake(0, self.frame.size.height*scrollTopicFlag) animated:YES];
    }
    
    
    if (scrollTopicFlag > [self.pics count]) {
        scrollTopicFlag = 1;
    }else {
        scrollTopicFlag++;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.pics count]>3) {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   
    [self pauseTimer];
}
- (void)pauseTimer
{
    if (scrollTimer) {
        [scrollTimer pauseTimer];
    }
}
-(void)releaseTimer{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
}
-(void)continueTimer{
    if (scrollTimer) {
        [scrollTimer resumeTimerAfterTimeInterval:0.0];
    }
}

@end
