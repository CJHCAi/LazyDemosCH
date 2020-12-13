//
//  YIMEditerInputAccessoryView.m
//  yimediter
//
//  Created by ybz on 2017/11/17.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerInputAccessoryView.h"

/**
 Item View菜单的单个View
 */
@interface YIMEditerInputAccessoryItemView : UIView{
    UIImageView *_imageView;
}
@property(nonatomic,copy)void(^click)(YIMEditerInputAccessoryItemView*sender);
@property(nonatomic,strong)YIMEditerAccessoryMenuItem *item;
-(instancetype)initWithMenuItem:(YIMEditerAccessoryMenuItem*)item;
@end
@implementation YIMEditerInputAccessoryItemView
-(instancetype)initWithMenuItem:(YIMEditerAccessoryMenuItem *)item{
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:item.image];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        _imageView = imageView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContent:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width/[UIScreen mainScreen].scale, _imageView.image.size.height/[UIScreen mainScreen].scale);
    _imageView.center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
}
-(void)setItem:(YIMEditerAccessoryMenuItem *)item{
    _item = item;
    _imageView.image = item.image;
}
-(void)tapContent:(id)sender{
    if(self.click){
        self.click(self);
    }
}
@end




@interface YIMEditerInputAccessoryView()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *btmBarView;
@property(nonatomic,strong)NSMutableArray<YIMEditerInputAccessoryItemView*>* itemViews;
@property(nonatomic,assign)NSInteger currentIndex;
@end

@implementation YIMEditerInputAccessoryView

#pragma -mark override super
-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //更新itemViews的坐标
    [self updateItemsFrame];
    //更新scrollView的contentSize
    [self updateScrollViewContentSize];
    //更新底部横线的坐标
    self.btmBarView.frame = [self bottomLineViewFrameAtIndex:self.currentIndex];
}

#pragma -mark public methods
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.itemViews = [NSMutableArray array];
        UIScrollView *contentScrollView  = [[UIScrollView alloc]init];
        [self addSubview:contentScrollView];
        contentScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //横线高度
        CGFloat lineHeight = 1/MAX(1,[UIScreen mainScreen].scale);
        //横线颜色
        UIColor *lineColor = [UIColor colorWithRed:0xde/255.0 green:0xde/255.0 blue:0xde/255.0 alpha:1];
        //上面横线
        UIView *topLineView = [[UIView alloc]init];
        topLineView.backgroundColor = lineColor;
        topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), lineHeight);
        topLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:topLineView];
        
        //底部横线
        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = lineColor;
        bottomLineView.frame = CGRectMake(0, CGRectGetHeight(frame) - lineHeight, CGRectGetWidth(frame), lineHeight);
        bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomLineView];
        
        //跟随当前选择项目的底部小横线
        UIView *btmBarView = [[UIView alloc]init];
        btmBarView.backgroundColor = [UIColor grayColor];
        btmBarView.frame = CGRectMake(0, 0, 0, 2);
        [self addSubview:btmBarView];
        
        self.scrollView = contentScrollView;
        self.btmBarView = btmBarView;
    }
    return self;
}
-(void)setItems:(NSArray<YIMEditerAccessoryMenuItem *> *)items{
    _items = items;
    //更新items前，把之前的itemView移除
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemViews removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    for (YIMEditerAccessoryMenuItem *item in items) {
        //初始化itemView
        YIMEditerInputAccessoryItemView *itemView = [[YIMEditerInputAccessoryItemView alloc]initWithMenuItem:item];
        //设置点击事件
        [itemView setClick:^(YIMEditerInputAccessoryItemView *sender) {
            [weakSelf clickItemView:sender];
        }];
        [self.scrollView addSubview:itemView];
        //把所有的itemView添加至数组
        [self.itemViews addObject:itemView];
    }
    //更新scrollView的ContentSize
    [self updateScrollViewContentSize];
    //更新所有ItemView的frame
    [self updateItemsFrame];
}

#pragma -mark private methods
/**更新ScrollView的contentSize*/
-(void)updateScrollViewContentSize{
    self.scrollView.contentSize = CGSizeMake(self.items.count * [self itemWH], CGRectGetHeight(self.frame));
}
/**更新itemViews的frame*/
-(void)updateItemsFrame{
    CGFloat wh = [self itemWH];
    for (NSInteger i = 0; i < self.itemViews.count; i++) {
        YIMEditerInputAccessoryItemView *view = self.itemViews[i];
        view.frame = CGRectMake(i * wh, 0, wh, wh);
    }
}
/**菜单项目的高度宽度*/
-(CGFloat)itemWH{
    return CGRectGetHeight(self.frame);
}
/**根据index获取底部横线view的frame*/
-(CGRect)bottomLineViewFrameAtIndex:(NSInteger)index{
    CGFloat wh = [self itemWH];
    return CGRectMake(index * wh, CGRectGetHeight(self.frame) - CGRectGetHeight(self.btmBarView.frame), wh, CGRectGetHeight(self.btmBarView.frame));
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    CGRect frame = [self bottomLineViewFrameAtIndex:currentIndex];
    [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.btmBarView.frame = frame;
    } completion:nil];
}


#pragma -mark events
-(void)clickItemView:(YIMEditerInputAccessoryItemView*)itemView{
    NSInteger index = [self.itemViews indexOfObject:itemView];
    if([self.delegate respondsToSelector:@selector(YIMEditerInputAccessoryView:clickItemAtIndex:)]){
        if([self.delegate YIMEditerInputAccessoryView:self clickItemAtIndex:index]){
            self.currentIndex = index;
        }
    }else{
        self.currentIndex = index;
    }
}



@end
