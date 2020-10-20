//
//  FamilyTreeView.m
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import "FamilyTreeView.h"

@implementation FamilyTreeView

static const CGFloat kCellWidth = 60.0;
static const CGFloat kCellHeight = 85.0;
static const CGFloat kHorizontalMargin = 60.0;
static const CGFloat kVerticalMargin = 60.0;

static const CGFloat kHalfCellWidth = kCellWidth / 2.0;
static const CGFloat kHalfCellHeight = kCellHeight / 2.0;
static const CGFloat kHalfHorizontalMargin = kHorizontalMargin / 2.0;
static const CGFloat kHalfVerticalMargin = kVerticalMargin / 2.0;

static const CGFloat kCornerRadius = 10.0;
static const CGFloat kCornerDiameter = kCornerRadius * 2.0;
static const CGFloat kQuarterAngle = M_PI * 3.0 / 2.0;

static NSString *const kLineLayerName = @"treeLineLayerName";

#pragma mark - Init
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(mainScrollView.frame, self.bounds)) {
        mainScrollView.frame = self.bounds;
        [self adjustScrollViewContentSize];
    }
}


- (void)setup {
    mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.alwaysBounceHorizontal = YES;
    mainScrollView.maximumZoomScale = 5.0;
    mainScrollView.minimumZoomScale = 0.2;
    mainScrollView.delegate = self;
    [self addSubview:mainScrollView];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)adjustScrollViewContentSize {
    mainScrollView.contentSize = containerView.frame.size;
    if (containerView.frame.size.width < self.frame.size.width) {
        CGFloat insetHorizontal = (self.frame.size.width - containerView.frame.size.width) / 2.0;
        mainScrollView.contentInset = UIEdgeInsetsMake(mainScrollView.contentInset.top, insetHorizontal, mainScrollView.contentInset.bottom, insetHorizontal);
    }else{
        mainScrollView.contentOffset = CGPointMake((containerView.frame.size.width - self.frame.size.width) / 2.0, 0);
    }
    
    if (containerView.frame.size.height < self.frame.size.height) {
        CGFloat insetVertical = (self.frame.size.height - containerView.frame.size.height) / 2.0;
        mainScrollView.contentInset = UIEdgeInsetsMake(insetVertical - kVerticalMargin / 2.0, mainScrollView.contentInset.left, insetVertical + kVerticalMargin / 2.0, mainScrollView.contentInset.right);
    }
}

#pragma mark - Properties
- (void)setModel:(FamilyModel *)model {
    _model = model;
    
    if (lastColumnsInRow == nil) {
        lastColumnsInRow = [NSMutableDictionary dictionary];
    }
    else{
        [lastColumnsInRow removeAllObjects];
    }
    
    if (rowContainerViews == nil) {
        rowContainerViews = [NSMutableArray array];
    }
    else{
        [rowContainerViews removeAllObjects];
    }
    
    if (containerView == nil) {
        containerView = [[UIView alloc] init];
        containerView.autoresizesSubviews = NO;
        [mainScrollView addSubview:containerView];
    }
    else{
        for (UIView *view in containerView.subviews) {
            [view removeFromSuperview];
        }
        
        for (CALayer *layer in containerView.layer.sublayers) {
            if ([layer.name isEqualToString:kLineLayerName]) {
                [layer removeFromSuperlayer];
            }
        }
        
        containerView.frame = CGRectZero;
    }
    
    [self createSelfViewWithModel:model row:0];
    [self layoutPersonViews];
    [self drawLinesBetweenPartners];
    [self drawLinesToChildren];
    [self adjustScrollViewContentSize];
}

- (void)setPersonViewBackgroundColor:(UIColor *)color {
    _personViewBackgroundColor = color;
    for (UIView *rowContainerView in rowContainerViews) {
        for (FamilyButton *personView in rowContainerView.subviews) {
            personView.backgroundColor = color;
        }
    }
}

- (void)setMaleBorderColor:(UIColor *)color {
    _maleBorderColor = color;
    for (UIView *rowContainerView in rowContainerViews) {
        for (FamilyButton *personView in rowContainerView.subviews) {
            personView.maleBorderColor = _maleBorderColor;
        }
    }
}

- (void)setFemaleBorderColor:(UIColor *)color {
    _femaleBorderColor = color;
    for (UIView *rowContainerView in rowContainerViews) {
        for (FamilyButton *personView in rowContainerView.subviews) {
            personView.femaleBorderColor = _femaleBorderColor;
        }
    }
}


#pragma mark - Create Person Views
- (NSInteger)getAndIncreaseLastColumnWithRow:(NSInteger)row {
    NSString *key = [NSString stringWithFormat:@"%ld",(long)row];
    
    if ([lastColumnsInRow.allKeys containsObject:key]) {
        NSInteger column = [lastColumnsInRow[key] integerValue] + 1;
        [lastColumnsInRow setValue:@(column) forKey:key];
        return column;
    }
    else{
        [lastColumnsInRow setValue:@(0) forKey:key];
        return 0;
    }
}

- (FamilyButton *)createSelfViewWithModel:(FamilyModel *)model row:(NSInteger)row {
    NSInteger column = [self getAndIncreaseLastColumnWithRow:row];
    FamilyButton *personView = [self createPersonViewWithModel:model row:row column:column];
    personView.mateLinkId = model.personId;
    personView.isMate = NO;
    for (int i=0; i<model.mates.count; i++) {
        FamilyModel *partnerModel = model.mates[i];
        FamilyButton *partnerPersonView = [self createPartnersViewWithModel:partnerModel row:row];
        partnerPersonView.mateLinkId = model.personId;
        partnerPersonView.isMate = YES;
        if (i==0) {
            partnerPersonView.isOriginalMate = YES;
        }
    }
    
    return personView;
}

- (FamilyButton *)createPartnersViewWithModel:(FamilyModel *)model row:(NSInteger)row {
    NSInteger column = [self getAndIncreaseLastColumnWithRow:row];
    FamilyButton *personView = [self createPersonViewWithModel:model row:row column:column];
    personView.childLinkId = model.personId;
    
    for (int i=0; i<model.children.count; i++) {
        FamilyModel *childModel = model.children[i];
        FamilyButton *childPersonView = [self createSelfViewWithModel:childModel row:row + 1];
        childPersonView.childLinkId = model.personId;
        childPersonView.isFirstChild = (i == 0 ? YES : NO);
        childPersonView.isLastChild = (i == model.children.count - 1 ? YES : NO);
    }
    
    return personView;
}

- (FamilyButton *)createPersonViewWithModel:(FamilyModel *)model row:(NSInteger)row column:(NSInteger)column {
    if (!model.personId) {
        return nil;
    }
    FamilyButton *personView = [[FamilyButton alloc] init];
    personView.frame = CGRectMake(column * (kCellWidth + kHorizontalMargin), kVerticalMargin, kCellWidth, kCellHeight);
    personView.model = model;
    personView.tag = row;
    personView.delegate = self;
    personView.maleBorderColor = self.maleBorderColor;
    personView.femaleBorderColor = self.femaleBorderColor;
    if (self.personViewBackgroundColor != nil) {
        personView.backgroundColor = self.personViewBackgroundColor;
    }
    
    CGFloat latestWidth = personView.frame.origin.x + personView.frame.size.width+kHorizontalMargin*4;
    
    UIView *rowContainerView = [self getContainerViewWithRow:row];
    [rowContainerView addSubview:personView];
    rowContainerView.frame = CGRectMake(kHorizontalMargin, rowContainerView.frame.origin.y, latestWidth, rowContainerView.frame.size.height);
    
    CGFloat latestHeight = rowContainerView.frame.origin.y + rowContainerView.frame.size.height+kVerticalMargin;
    latestWidth = fmax(latestWidth, containerView.frame.size.width);
    
    latestHeight = fmax(latestHeight, containerView.frame.size.height);
    containerView.frame = CGRectMake(0, 0, latestWidth, latestHeight);
    
    return personView;
}

- (UIView *)getContainerViewWithRow:(NSInteger)row {
    if (row>=rowContainerViews.count) {
        UIView *rowContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, row * (kCellHeight + kVerticalMargin), 0, kCellHeight + kVerticalMargin)];
        rowContainerView.autoresizesSubviews = NO;
        [containerView addSubview:rowContainerView];
        [rowContainerViews addObject:rowContainerView];
        return rowContainerView;
    }else{
        return rowContainerViews[row];
    }
}


#pragma mark - Layout Person Views
- (void)layoutPersonViews {
    for (NSInteger i = rowContainerViews.count-1; i>0; i--) {
        
        UIView *rowContainerView = rowContainerViews[i];
        rowContainerView.tag = i;
        UIView *parentRowContainerView = rowContainerViews[i-1];
        parentRowContainerView.tag = i-1;
        
        FamilyButton *currentView = rowContainerView.subviews[0];
        FamilyButton *previousView;
        CGRect groupedPersonsFrame = currentView.frame;
        
        if (rowContainerView.subviews.count == 1) {
            [self layoutPersonViewsWithCurrentView:currentView index:1 rowContainerView:rowContainerView parentRowContainerView:parentRowContainerView groupedPersonsFrame:groupedPersonsFrame];
        }else{
            for (int j = 1;j < rowContainerView.subviews.count;j++) {
                FamilyButton *nextView = rowContainerView.subviews[j];
                if ([nextView.mateLinkId isEqualToString:currentView.mateLinkId]
                    || [nextView.childLinkId isEqualToString:currentView.childLinkId]
                    || [nextView.mateLinkId isEqualToString:previousView.mateLinkId]){
                    if (![nextView.mateLinkId isEqualToString:previousView.mateLinkId]) {
                        groupedPersonsFrame.size.width = nextView.frame.origin.x + nextView.frame.size.width - groupedPersonsFrame.origin.x;
                    }
                    previousView = nextView;
                    if (j == rowContainerView.subviews.count - 1) {
                        [self layoutPersonViewsWithCurrentView:currentView index:j rowContainerView:rowContainerView parentRowContainerView:parentRowContainerView groupedPersonsFrame:groupedPersonsFrame];
                    }
                    
                }else{
                    
                    [self layoutPersonViewsWithCurrentView:currentView index:j rowContainerView:rowContainerView parentRowContainerView:parentRowContainerView groupedPersonsFrame:groupedPersonsFrame];
                    
                    currentView = nextView;
                    previousView = nil;
                    groupedPersonsFrame = currentView.frame;
                    if (j == rowContainerView.subviews.count - 1) {
                        [self layoutPersonViewsWithCurrentView:currentView index:j+1 rowContainerView:rowContainerView parentRowContainerView:parentRowContainerView groupedPersonsFrame:groupedPersonsFrame];
                    }
                }
            }
        }
    }
}

- (void)layoutPersonViewsWithCurrentView:(FamilyButton *)currentView index:(NSInteger)index rowContainerView:(UIView *)rowContainerView parentRowContainerView:(UIView *)parentRowContainerView groupedPersonsFrame:(CGRect)groupedPersonsFrame {
    if (groupedPersonsFrame.size.width <= kCellWidth) {
        FamilyButton *parentView = [self getParentViewWithChildLinkId:currentView.childLinkId parentRowContainerView:parentRowContainerView];
        CGRect parentFrame = parentView.frame;
        if (parentView.isOriginalMate) {
            currentView.frame = CGRectMake(parentFrame.origin.x - kHalfHorizontalMargin - kHalfCellWidth, currentView.frame.origin.y, kCellWidth, kCellHeight);
        }else{
            currentView.frame = CGRectMake(parentFrame.origin.x, currentView.frame.origin.y, kCellWidth, kCellHeight);
        }
        
        CGFloat startX = parentFrame.origin.x + parentFrame.size.width + kHorizontalMargin;
        
        [self moveRestsPersonViewWithRowContainerView:rowContainerView fromIndex:index startX:startX];
        
    }else if (groupedPersonsFrame.size.width > kCellWidth * 2.0 + kHorizontalMargin) {
        
        [self setParentFrameWithChildLinkId:currentView.childLinkId parentRowContainerView:parentRowContainerView childrenFrame:groupedPersonsFrame];
    }
    
}

- (FamilyButton *)getParentViewWithChildLinkId:(NSString *)childLinkId parentRowContainerView:(UIView *)parentRowContainerView {
    for (FamilyButton *personView in parentRowContainerView.subviews) {
        if ([personView.childLinkId isEqualToString:childLinkId]) {
            return personView;
        }
    }
    return nil;
}

- (void)setParentFrameWithChildLinkId:(NSString *)childLinkId parentRowContainerView:(UIView *)parentRowContainerView childrenFrame:(CGRect)childrenFrame{
    for (int i=0; i<parentRowContainerView.subviews.count; i++) {
        FamilyButton *personView = parentRowContainerView.subviews[i];
        if ([personView.childLinkId isEqualToString:childLinkId]) {
            CGFloat center = childrenFrame.size.width / 2.0 + childrenFrame.origin.x;
            personView.frame = CGRectMake(center + kHalfHorizontalMargin, personView.frame.origin.y, kCellWidth, kCellHeight);
            if (i > 0) {
                FamilyButton *prePersonView = parentRowContainerView.subviews[i - 1];
                if (!prePersonView.isMate && [prePersonView.mateLinkId isEqualToString:personView.mateLinkId]) {
                    prePersonView.frame = CGRectMake(center - kHalfHorizontalMargin - kCellWidth, prePersonView.frame.origin.y, kCellWidth, kCellHeight);
                    
                    //各项依次居中对齐
                    if (i+1 < parentRowContainerView.subviews.count) {
                        CGFloat space = childrenFrame.size.width/2.0 - kHalfHorizontalMargin;
                        FamilyButton *nextView = parentRowContainerView.subviews[i + 1];
                        nextView.frame = CGRectMake(personView.frame.origin.x + space + kHorizontalMargin, nextView.frame.origin.y, kCellWidth, kCellHeight);
                        CGFloat previousX = nextView.frame.origin.x;
                        for (NSInteger j = i + 2 ; j< parentRowContainerView.subviews.count; j++) {
                            FamilyButton *view = parentRowContainerView.subviews[j];
                            CGRect frame = view.frame;
                            frame.origin.x = previousX + kCellWidth + kHorizontalMargin;
                            view.frame = frame;
                            previousX = frame.origin.x;
                        }
                    }
                }
            }
        }
    }
    
    //重新获取containerView最大宽度
    FamilyButton *lastView = parentRowContainerView.subviews.lastObject;
    CGFloat latestWidth = lastView.frame.origin.x + lastView.frame.size.width + kHorizontalMargin*2;
    latestWidth = fmax(latestWidth, containerView.frame.size.width);
    containerView.frame = CGRectMake(0, 0, latestWidth, containerView.frame.size.height);
    
    [self adjustFrameWithRowContainerView:parentRowContainerView];
}

- (void)moveRestsPersonViewWithRowContainerView:(UIView *)rowContainerView fromIndex:(NSInteger)index startX:(CGFloat)startX{
    CGFloat offset = -1;
    if (index < rowContainerView.subviews.count) {
        FamilyButton *personView = rowContainerView.subviews[index];
        CGRect frame = personView.frame;
        offset = startX - frame.origin.x;
    }
    
    for (NSInteger i = index; i< rowContainerView.subviews.count; i++) {
        FamilyButton *personView = rowContainerView.subviews[i];
        CGRect frame = personView.frame;
        frame.origin.x += offset;
        personView.frame = frame;
    }
    
    [self adjustFrameWithRowContainerView:rowContainerView];
}

- (void)adjustFrameWithRowContainerView:(UIView *)rowContainerView{
    CGRect frame = rowContainerView.frame;
    frame.size.width = containerView.frame.size.width - frame.origin.x;
    rowContainerView.frame = frame;
}


#pragma mark - Lines Drawing
- (void)drawLinesBetweenPartners {
    for (UIView *rowContainerView in rowContainerViews) {
        CAShapeLayer *partnerLinesLayer = [CAShapeLayer layer];
        UIBezierPath *path = [[UIBezierPath alloc] init];
        
        FamilyButton *prePersonView = nil;
        for (FamilyButton *personView in rowContainerView.subviews) {
            if (prePersonView == nil) {
                prePersonView = personView;
                continue;
            }
            
            if ([prePersonView.mateLinkId isEqualToString:personView.mateLinkId]) {
                [path moveToPoint:CGPointMake(prePersonView.frame.origin.x + prePersonView.frame.size.width, prePersonView.frame.origin.y + kHalfCellHeight)];
                [path addLineToPoint:CGPointMake(personView.frame.origin.x, personView.frame.origin.y + kHalfCellHeight)];
            }
            
            prePersonView = personView;
        }
        
        partnerLinesLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        partnerLinesLayer.lineWidth = 1;
        partnerLinesLayer.path = path.CGPath;
        
        [rowContainerView.layer addSublayer:partnerLinesLayer];
    }
}

- (void)drawLinesToChildren {
    CAShapeLayer *partnerLinesLayer = [CAShapeLayer layer];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (int i=0;i<rowContainerViews.count - 1;i++) {
        UIView *rowContainerView = rowContainerViews[i];
        UIView *nextRowContainerView = rowContainerViews[i+1];
        
        for (FamilyButton *personView in rowContainerView.subviews) {
            for (FamilyButton *childPersonView in nextRowContainerView.subviews) {
                if ([personView.childLinkId isEqualToString:childPersonView.childLinkId]) {
                    CGPoint personViewOrigin = [rowContainerView convertPoint:personView.frame.origin toView:containerView];
                    CGPoint childPersonViewOrigin = [nextRowContainerView convertPoint:childPersonView.frame.origin toView:containerView];
                    [path moveToPoint:CGPointMake(personViewOrigin.x - kHalfHorizontalMargin, personViewOrigin.y + kHalfCellHeight)];
                    CGPoint nextPoint = CGPointMake(personViewOrigin.x - kHalfHorizontalMargin, kHalfVerticalMargin + personViewOrigin.y + personView.frame.size.height);
                    [path addLineToPoint:CGPointMake(nextPoint.x, nextPoint.y + 0.5)];
                    [path moveToPoint:nextPoint];
                    
                    CGFloat childCenterX = childPersonViewOrigin.x + kHalfCellWidth;
                    if (childCenterX < nextPoint.x && childPersonView.isFirstChild) {
                        nextPoint = CGPointMake(childCenterX + kCornerDiameter, nextPoint.y);
                        [self drawLineAndMoveTo:nextPoint path:path];
                        
                        [path addArcWithCenter:CGPointMake(childCenterX + kCornerRadius, nextPoint.y + kCornerRadius) radius:kCornerRadius startAngle:kQuarterAngle endAngle:M_PI clockwise:NO];
                    }
                    else if (childCenterX > nextPoint.x && childPersonView.isLastChild) {
                        nextPoint = CGPointMake(childCenterX - kCornerDiameter, nextPoint.y);
                        [self drawLineAndMoveTo:nextPoint path:path];
                        
                        [path addArcWithCenter:CGPointMake(childCenterX - kCornerRadius, nextPoint.y + kCornerRadius) radius:kCornerRadius startAngle:kQuarterAngle endAngle:0 clockwise:YES];
                    }
                    else{
                        nextPoint = CGPointMake(childCenterX, nextPoint.y);
                        [self drawLineAndMoveTo:nextPoint path:path];
                    }
                    
                    nextPoint = CGPointMake(childCenterX,childPersonViewOrigin.y);
                    [self drawLineAndMoveTo:nextPoint path:path];
                }
            }
        }
    }
    
    partnerLinesLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    partnerLinesLayer.fillColor = [UIColor clearColor].CGColor;
    partnerLinesLayer.lineWidth = 1;
    partnerLinesLayer.path = path.CGPath;
    partnerLinesLayer.name = kLineLayerName;
    
    [containerView.layer addSublayer:partnerLinesLayer];
}

- (void)drawLineAndMoveTo:(CGPoint)point path:(UIBezierPath *)path {
    [path addLineToPoint:point];
    [path moveToPoint:point];
}

#pragma mark - UIScrollView Delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return containerView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    
    if (containerView.frame.size.width < self.frame.size.width) {
        CGFloat insetHorizontal = (self.frame.size.width - containerView.frame.size.width) / 2.0;
        mainScrollView.contentInset = UIEdgeInsetsMake(mainScrollView.contentInset.top, insetHorizontal, mainScrollView.contentInset.bottom, insetHorizontal);
    }else{
        mainScrollView.contentInset = UIEdgeInsetsMake(mainScrollView.contentInset.top, 0, mainScrollView.contentInset.bottom, 0);
    }
    
    if (containerView.frame.size.height < self.frame.size.height) {
        CGFloat insetVertical = (self.frame.size.height - containerView.frame.size.height) / 2.0;
        mainScrollView.contentInset = UIEdgeInsetsMake(insetVertical - kVerticalMargin / 2.0, mainScrollView.contentInset.left, insetVertical + kVerticalMargin / 2.0, mainScrollView.contentInset.right);
    }
    else{
        mainScrollView.contentInset = UIEdgeInsetsMake(-kVerticalMargin * scale, mainScrollView.contentInset.left, 0, mainScrollView.contentInset.right);
    }
}

#pragma mark - FamilyButton Delegate
-(void)buttonDidClickItemAtFamilyModel:(FamilyModel *)model{
    if(self.delegate && [self.delegate respondsToSelector:@selector(familyTreeButtonDidClickedItemAtIndex:)]){
        [self.delegate familyTreeButtonDidClickedItemAtIndex:model];
    }
}

@end
