//
//  XLChannelView.m
//  XLChannelControlDemo
//
//  Created by Apple on 2017/1/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XLChannelView.h"
#import "XLChannelControl.h"
#import "XLChannelTitleView.h"
#import "XLChannelItem.h"

//菜单列数
static NSInteger ColumnNumber = 3;
//横向和纵向的间距
static CGFloat BtnMarginX = 8.0f;
static CGFloat BtnMarginY = 10.0f;

@interface XLChannelView ()
{
    //保存上半部分卡片
    NSMutableArray *_inUseItems;
    //保存下半部分卡片
    NSMutableArray *_unUseItems;
    
    
    //上半部分标题
    XLChannelTitleView *_inUseTitleView;
    //下半部分标题
    XLChannelTitleView *_unUseTitleView;
    
    //滚动view
    UIScrollView *_scrollView;
    
    //被拖动的卡片
    XLChannelItem *_dragingItem;
    //空白卡片
    XLChannelItem *_placeholderItem;
    //目标卡片
    XLChannelItem *_targetItem;
    
    BOOL isChange;
}

@end

@implementation XLChannelView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    isChange = NO;
    [self addSubview:[UIView new]];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    
    //上半部分标题
//    _inUseTitleView = [[XLChannelTitleView alloc] initWithFrame:CGRectMake(BtnMarginX, BtnMarginY, self.bounds.size.width - 2*BtnMarginX, [self titleViewHeight])];
     _inUseTitleView = [[XLChannelTitleView alloc] initWithFrame:CGRectMake(0, BtnMarginY, self.bounds.size.width, 25)];
    _inUseTitleView.title = @"常用频道";
    _inUseTitleView.subTitle = @"点击编辑按钮可调整常用频道";
    _inUseTitleView.backgroundColor = UICOLOR_RGB_Alpha(0xf1f1f1, 1);
    [_scrollView addSubview:_inUseTitleView];
    
    
    _inUseItems = [NSMutableArray new];
    _unUseItems = [NSMutableArray new];
    
    //初始化上部分的菜单按钮
    for (int i = 0; i<[XLChannelControl shareControl].inUseItems.count; i++) {
        XLChannelModel *model = [XLChannelControl shareControl].inUseItems[i];
        XLChannelItem *item = [[XLChannelItem alloc] initWithFrame:[self inUserItemFrameOfIndex:i]];
        item.title = model.title;
        item.image = model.image;
        item.categoryId = model.categoryId;
        [_scrollView addSubview:item];
        [_inUseItems addObject:item];
        if (i != 0 && i!=1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapMethod:)];
            [item addGestureRecognizer:tap];
            [item isOrHiend:YES];
        }
    }
    
    //下半部分标题
//    _unUseTitleView = [[XLChannelTitleView alloc] initWithFrame:CGRectMake(BtnMarginX,[self unUseLabelY], self.bounds.size.width - 2*BtnMarginX, [self titleViewHeight])];
    _unUseTitleView = [[XLChannelTitleView alloc] initWithFrame:CGRectMake(0,[self unUseLabelY], self.bounds.size.width, 25)];
    _unUseTitleView.title = @"其他频道";
    _unUseTitleView.subTitle = @"";
    _unUseTitleView.backgroundColor = UICOLOR_RGB_Alpha(0xf1f1f1, 1);
    [_scrollView insertSubview:_unUseTitleView atIndex:0];
    
    //初始化下部分的菜单按钮
    for (int i = 0; i<[XLChannelControl shareControl].unUseItems.count; i++) {
        XLChannelModel *model = [XLChannelControl shareControl].unUseItems[i];
        XLChannelItem *item = [[XLChannelItem alloc] initWithFrame:[self unUseItemFrameOfIndex:i]];
        item.title = model.title;
        item.image = model.image;
        item.categoryId = model.categoryId;
        [item isOrHiend:NO];
        [_scrollView addSubview:item];
        [_unUseItems addObject:item];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapMethod:)];
        [item addGestureRecognizer:tap];
        
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(item.frame) + BtnMarginY);
    }
    
    //添加占位按钮
    _placeholderItem = [[XLChannelItem alloc] initWithFrame:CGRectZero];
    _placeholderItem.isPlaceholder = true;
    [_placeholderItem isHiend];
    [_scrollView addSubview:_placeholderItem];
    
    //添加长按编辑方法
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.3f;
    [_scrollView addGestureRecognizer:longPress];
}

-(void)isChange:(BOOL)isHiend
{
    if (isHiend) {
        _inUseTitleView.subTitle = @"长按拖动排序";
        _unUseTitleView.subTitle = @"点击添加到常用频道";
        //更新正在使用item的范围
        for (int i = 0 ; i<_inUseItems.count; i++) {
            XLChannelItem *item = _inUseItems[i];
            [item isOrChange:NO];
            item.frame = [self inUserItemFrameOfIndex:i];
        }
        //更新未使用item的范围
        for (int i = 0 ; i<_unUseItems.count; i++) {
            XLChannelItem *item = _unUseItems[i];
            item.frame = [self unUseItemFrameOfIndex:i];
            [item isOrChange:NO];
            _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(item.frame) + BtnMarginY);
        }
        isChange = YES;
    }
    else
    {
        _inUseTitleView.subTitle = @"点击编辑按钮可调整常用频道";
        _unUseTitleView.subTitle = @"";
        //更新正在使用item的范围
        for (int i = 0 ; i<_inUseItems.count; i++) {
            XLChannelItem *item = _inUseItems[i];
            [item isOrChange:YES];
            item.frame = [self inUserItemFrameOfIndex:i];
        }
        
        //更新未使用item的范围
        for (int i = 0 ; i<_unUseItems.count; i++) {
            XLChannelItem *item = _unUseItems[i];
            item.frame = [self unUseItemFrameOfIndex:i];
            [item isOrChange:YES];
            _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(item.frame) + BtnMarginY);
        }
         isChange = NO;
        if (_clickFinshBlock) {
            _clickFinshBlock(_inUseItems);
        }

    }
    
}

#pragma mark -
#pragma mark DraggedMethods

-(void)longPressMethod:(UIGestureRecognizer*)recognizer
{
    if (isChange == NO) {
        return;
    }
    CGPoint point = [recognizer locationInView:_scrollView];
    //获取被拖拽的卡片
    XLChannelItem *item = [self getDragingitemWithPoint:point];
    if ([item.image isEqualToString:@"channel_commend"]||[item.image isEqualToString:@"channel_advert"])
    {
        return;
    }
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self gestureBegan:recognizer];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self gestureChanged:recognizer];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self gestureEnd:recognizer];
        }
            break;
        default:
            break;
    }
}

-(void)gestureBegan:(UIGestureRecognizer*)gesture
{
    //允许ScrollView滚动
    _scrollView.scrollEnabled = false;
    CGPoint point = [gesture locationInView:_scrollView];
    //获取被拖拽的卡片
    _dragingItem = [self getDragingitemWithPoint:point];
    //拖拽是空则不执行下面方法
    if (!_dragingItem) {return;}
    //显示放大
    [self showAnimation:_dragingItem bigger:true];
    //设置占位按钮的标题
    _placeholderItem.title = _dragingItem.title;
    _placeholderItem.image = _dragingItem.image;
    //用空白的方块替代拖拽的方块
    NSInteger index = [_inUseItems indexOfObject:_dragingItem];
    [_inUseItems replaceObjectAtIndex:index withObject:_placeholderItem];
    _placeholderItem.frame = [self inUserItemFrameOfIndex:index];
    //把被拖拽的方块移动到最前面
    [_scrollView bringSubviewToFront:_dragingItem];
    //更新UI
    [self updateUI];
}

-(void)gestureChanged:(UIGestureRecognizer*)gesture
{
    //没有被拖拽的按钮 不执行下面方法
    if (!_dragingItem) {return;}
    //更新被拖拽按钮的frame
    CGPoint point = [gesture locationInView:self];
    _dragingItem.center = point;
    //获取准备要交换位置的菜单按钮
    _targetItem = [self getTargetitemWithPoint:point];
    
    //没找到准备交换的目标卡片则不执行下面方法
    if (!_targetItem) {return;}
    
    //交换空白块和目标块的位置
    [_inUseItems removeObject:_placeholderItem];
    NSInteger index = [_inUseItems indexOfObject:_targetItem];
    if (_placeholderItem.frame.origin.y == _targetItem.frame.origin.y) {
        if (_dragingItem.center.x < _targetItem.center.x) {
            index += 1;
        }
    }else if (_placeholderItem.frame.origin.y < _targetItem.frame.origin.y){
        index += 1;
    }
    [_inUseItems insertObject:_placeholderItem atIndex:index];
    //更新位置
    [self updateUI];
}

-(void)gestureEnd:(UIGestureRecognizer*)gesture
{
    //允许ScrollView滚动
    _scrollView.scrollEnabled = true;
    
    //没有找到合适的拖拽按钮 就不执行下面方法
    if (!_dragingItem) {return;}
    //和占位按钮交换位置
    [_inUseItems replaceObjectAtIndex:[_inUseItems indexOfObject:_placeholderItem] withObject:_dragingItem];
    [self showAnimation:_dragingItem bigger:false];
    //更新UI
    [self updateUI];
    [self saveData];
}


-(void)showAnimation:(XLChannelItem*)item bigger:(BOOL)bigger
{
    CGFloat scale = bigger ? 1.3f : 1.0f;
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform newTransform = CGAffineTransformMakeScale(scale, scale);
        [item setTransform:newTransform];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -
#pragma mark 辅助方法

//获取被拖动方块的方法
-(XLChannelItem*)getDragingitemWithPoint:(CGPoint)point
{
    XLChannelItem* item = nil;
    if (_inUseItems.count == 1) {return item;}
    CGRect checkRect = CGRectMake(point.x, point.y, 1, 1);
    for (XLChannelItem *enumitem in _scrollView.subviews) {
        if (![enumitem isKindOfClass:[XLChannelItem class]]) {continue;}
        if (![_inUseItems containsObject:enumitem]) {continue;}
        if (CGRectIntersectsRect(enumitem.frame, checkRect)) {
            item = enumitem;
            break;
        }
    }
    return item;
}

//获取目标位置方块的方法
-(XLChannelItem*)getTargetitemWithPoint:(CGPoint)point
{
    XLChannelItem *targetitem = nil;
    for (XLChannelItem *enumitem in _scrollView.subviews) {
        if (![enumitem isKindOfClass:[XLChannelItem class]]) {continue;}
        if (enumitem == _dragingItem) {continue;}
        if (enumitem == _placeholderItem) {continue;}
        if (![_inUseItems containsObject:enumitem]) {continue;}
        if (CGRectContainsPoint(enumitem.frame, point)) {
            targetitem = enumitem;
        }
    }
    return targetitem;
}


#pragma mark -
#pragma mark 点击方法

-(void)itemTapMethod:(UIGestureRecognizer*)gesture
{
    if (isChange == NO) {
        return;
    }
    XLChannelItem *item = (XLChannelItem*)gesture.view;
    [_scrollView bringSubviewToFront:item];
    
    //更新数据源的数据
    if ([_inUseItems containsObject:item]) {
        DLog(@"这是上面的");
        //只有一个的时候不能删除
        if (_inUseItems.count == 1) {return;}
        [_inUseItems removeObject:item];
        [_unUseItems insertObject:item atIndex:0];
    }else{
        DLog(@"这是下面的");
        [_unUseItems removeObject:item];
        [_inUseItems addObject:item];
    }
    //更新UI
    [self updateUI];
    [self saveData];
}

#pragma mark -
#pragma mark 定义按钮和其他控件的高度、宽度

-(CGFloat)itemWidth
{
    return (self.bounds.size.width - (ColumnNumber + 1) * BtnMarginX)/ColumnNumber;
}

-(CGFloat)itemHeight
{
    return [self itemWidth]/2.0f;
}


-(CGFloat)titleViewHeight
{
    return 0.09 * self.bounds.size.width;
}


-(CGFloat)unUseLabelY
{
    NSInteger count = _inUseItems.count;
    CGFloat y = [self titleViewHeight];
    if (count > 0) {
        y = CGRectGetMaxY([self inUserItemFrameOfIndex:_inUseItems.count - 1]) + BtnMarginY;
    }
    return y;
}

#pragma mark -
#pragma mark 更新UI方法

-(void)updateUI
{
    [UIView animateWithDuration:0.35 animations:^{
        [self updateUnUseLabelFrame];
        [self updateItemFrame];
    } completion:^(BOOL finished) {
        if (![_inUseItems containsObject:_placeholderItem]) {
            _placeholderItem.frame = CGRectZero;
        }
    }];
}

//更新每个label的范围
-(void)updateItemFrame
{
    //更新正在使用item的范围
    for (int i = 0 ; i<_inUseItems.count; i++) {
        XLChannelItem *item = _inUseItems[i];
        item.frame = [self inUserItemFrameOfIndex:i];
    }
    
    //更新未使用item的范围
    for (int i = 0 ; i<_unUseItems.count; i++) {
        XLChannelItem *item = _unUseItems[i];
        item.frame = [self unUseItemFrameOfIndex:i];
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(item.frame) + BtnMarginY);
    }
}

/**
 使用中的item的frame
 */
-(CGRect)inUserItemFrameOfIndex:(NSInteger)index
{
//    CGFloat itemY = CGRectGetMaxY(_inUseTitleView.frame) + index/ColumnNumber * [self itemHeight] + (index/ColumnNumber + 1)*BtnMarginY;;
//
//    CGFloat itemX = index%ColumnNumber*[self itemWidth] + (index%ColumnNumber + 1)*BtnMarginX;
    
//    return CGRectMake(itemX, itemY, [self itemWidth], [self itemHeight]);
    
    CGFloat itemY = CGRectGetMaxY(_inUseTitleView.frame) + index/ColumnNumber * (kScreenWidth-36)/3 + (index/ColumnNumber + 1)*BtnMarginY;;
    
    CGFloat itemX = index%ColumnNumber*(kScreenWidth-36)/3 + (index%ColumnNumber + 1)*BtnMarginX;
    return CGRectMake(itemX, itemY, (kScreenWidth-36)/3,(kScreenWidth-36)/3);
    
}
/**
 未使用中的item的frame
 */
-(CGRect)unUseItemFrameOfIndex:(NSInteger)index
{
//    CGFloat itemY = [self unUseLabelY] + [self titleViewHeight] + index/ColumnNumber * [self itemHeight] + (index/ColumnNumber + 1)*BtnMarginY;
//    CGFloat itemX = index%ColumnNumber * [self itemWidth] + (index%ColumnNumber + 1)*BtnMarginX;
//    return CGRectMake(itemX, itemY, [self itemWidth], [self itemHeight]);
    
    CGFloat itemY = [self unUseLabelY] + [self titleViewHeight] + index/ColumnNumber * (kScreenWidth-36)/3 + (index/ColumnNumber + 1)*BtnMarginY;
    CGFloat itemX = index%ColumnNumber * (kScreenWidth-36)/3 + (index%ColumnNumber + 1)*BtnMarginX;
    return CGRectMake(itemX, itemY, (kScreenWidth-36)/3,(kScreenWidth-36)/3);
}
/**
 标题栏的frame
 */
-(void)updateUnUseLabelFrame
{
    CGRect frame = _unUseTitleView.frame;
    frame.origin.y = [self unUseLabelY];
    _unUseTitleView.frame = frame;
}

/**
 保存本地数据
 */
-(void)saveData
{
    NSMutableArray *arr1 = [NSMutableArray new];
    NSMutableArray *arr2 = [NSMutableArray new];
    for (int i = 0; i<_inUseItems.count; i++) {
        XLChannelModel *model = [XLChannelModel new];
        XLChannelItem *item = _inUseItems[i];
        model.title = item.title;
        model.image = item.image;
        model.categoryId = item.categoryId;
        [arr1 addObject:model];
    }
    for (int i = 0; i<_unUseItems.count; i++) {
        XLChannelModel *model = [XLChannelModel new];
        XLChannelItem *item = _unUseItems[i];
        model.title = item.title;
        model.image = item.image;
        model.categoryId = item.categoryId;
        [arr2 addObject:model];
    }
    [XLChannelControl shareControl].inUseItems = arr1;
    [XLChannelControl shareControl].unUseItems = arr2;
}

@end
