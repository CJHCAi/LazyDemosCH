//
//  headerScaleView.m
//  TableHeaderScaleDemo
//
//  Created by nieyongsheng on 2018/12/3.
//  Copyright © 2018年 nieyongsheng. All rights reserved.
//

#import "headerScaleView.h"

@interface headerScaleView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, assign) CGPoint prePoint;

@end

@implementation headerScaleView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = [UIColor blueColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, frame.size.width - 40,42)];
        _titleLabel.layer.anchorPoint = CGPointMake(0, 0);
        _titleLabel.frame = CGRectMake(20, 40, frame.size.width - 40,42);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:30];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        

        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_titleLabel.frame) + 4, frame.size.width - 40, 21)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont systemFontOfSize:15];
        _subTitleLabel.text = subTitle;
        _subTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_subTitleLabel];
        
    }
    
    return self;
}


- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];
    self.scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0 ,0 , 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    CGPoint newOffset = [change[@"new"] CGPointValue];
    [self updateSubViewsWithScrollOffset:newOffset];
    
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset
{
    
    CGFloat destinaOffset = -67;
    CGFloat startChangeOffset = -self.scrollView.contentInset.top;
    newOffset = CGPointMake(newOffset.x, newOffset.y<startChangeOffset?startChangeOffset:(newOffset.y>destinaOffset?destinaOffset:newOffset.y));
    
    CGFloat subviewOffset = self.frame.size.height-40; // 子视图的偏移量
    CGFloat newY = -newOffset.y-self.scrollView.contentInset.top;
    CGFloat d = destinaOffset-startChangeOffset;
    CGFloat alpha = 1-(newOffset.y-startChangeOffset)/d;
    CGFloat imageReduce = 1-(newOffset.y-startChangeOffset)/((d + 27.5)*2);
    
    
    self.subTitleLabel.alpha = alpha;
    
    self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
    
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(0,(subviewOffset-0.3*self.frame.size.height)*(1-alpha));
    
    
    
    self.titleLabel.transform = CGAffineTransformScale(t,
                                                        imageReduce, imageReduce);

    
    
    self.subTitleLabel.frame = CGRectMake(20, 86+(subviewOffset-0.45*self.frame.size.height)*(1-alpha), self.frame.size.width - 40, 21);
    
    
}


@end
