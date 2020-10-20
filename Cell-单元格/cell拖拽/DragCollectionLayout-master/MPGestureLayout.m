//
//  MPGestureLayout.m
//  collectionPanViewTest
//
//  Created by ytz on 2018/1/24.
//  Copyright © 2018年 ytz. All rights reserved.
//

#import "MPGestureLayout.h"

typedef NS_ENUM(NSInteger,GestureOperation) {
    OperationNone = 0,
    OperationChange,
    OperationDelete,
};


@interface MPGestureLayout ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILongPressGestureRecognizer * longPress;
@property (nonatomic, strong) NSIndexPath * currentIndexPath;
@property (nonatomic, strong) UIView * snapImageView;
@property (nonatomic, assign) GestureOperation operation;

@end

@implementation MPGestureLayout

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"collectionView"];
}

#pragma mark - setup

- (void)configureObserver{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setUpGestureRecognizers{
    if (self.collectionView == nil) {
        return;
    }
    _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    _longPress.minimumPressDuration = 0.2f;
    _longPress.delegate = self;
    [self.collectionView addGestureRecognizer:_longPress];
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self setUpGestureRecognizers];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPress
{
    UIView *touchView = [self getMoveMainView];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
           
            CGPoint location = [longPress locationInView:self.collectionView];
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:location];
            
            if (!indexPath) return;
            NSArray *disableArray =[self getDisableMoveArray];  //不可操作
            if([disableArray containsObject:indexPath]) return ;
            if(_operation!=OperationNone) return;
            
            

            self.currentIndexPath = indexPath;
            UICollectionViewCell* targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
        
            UIView* cellView = [targetCell snapshotViewAfterScreenUpdates:YES];
            self.snapImageView = cellView;
            self.snapImageView.frame = cellView.frame;
            targetCell.hidden = YES;
            
            [touchView addSubview:self.snapImageView];
            //转为窗体坐标
            CGPoint center = [self.collectionView convertPoint:targetCell.center toView:touchView];
            cellView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            cellView.center = center;
            [self beginGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if(!self.snapImageView) return;
            CGPoint point = [longPress locationInView:self.collectionView];
            //更新cell的位置
            CGPoint center = [longPress locationInView:touchView];
            
            self.snapImageView.center = center;
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
            
            if (!indexPath) {   //没滑到其他cell上
                 CGRect deleteRect = [self getDeleteArea];
                if ( CGRectIntersectsRect(deleteRect, self.snapImageView.frame)) { //滑到删除区域
                    _operation = OperationDelete;
                    [self moveInDeleteArea];
                }
                else {
                    _operation = OperationNone;
                    [self leaveDeleteArea];
                }
                return;
            }
            
            NSArray *disableArray =[self getDisableMoveArray];
            if([disableArray containsObject:indexPath])return ;
            
            if (![indexPath isEqual:self.currentIndexPath]&&indexPath)//滑到其他cell上
            {
                _operation = OperationChange;
                if ([self.delegate respondsToSelector:@selector(mp_moveDataItem:toIndexPath:)]) {
                    [self.delegate mp_moveDataItem:self.currentIndexPath toIndexPath:indexPath];
                }
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
   
             if(_operation== OperationDelete) { //删除操作
                if ([self.delegate respondsToSelector:@selector(mp_removeDataObjectAtIndex:)]) {
                    [self.collectionView performBatchUpdates:^{
                        [self.delegate mp_removeDataObjectAtIndex:_currentIndexPath];
                            [self.collectionView deleteItemsAtIndexPaths:@[_currentIndexPath]];
                        [self.snapImageView removeFromSuperview];
                      
                        
                    } completion:^(BOOL finished) {
                        [self resetData];
                    }];
           
                }
             } else  {   //移动操作
                 UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
                 CGPoint center = [self.collectionView convertPoint:cell.center toView:touchView];
                 [UIView animateWithDuration:0.25 animations:^{
                     self.snapImageView.center = center;
                 } completion:^(BOOL finished) {
                     
                     [self.snapImageView removeFromSuperview];
                     cell.hidden           = NO;
                     [self resetData];
                 }];
            
             }
       
        }
            break;
        default:
        break;
    }
}

- (void)resetData {
    self.snapImageView = nil;
    self.currentIndexPath = nil;
    _operation= OperationNone;
    [self leaveDeleteArea];
    [self endGesture];
}

- (CGRect )getDeleteArea {
    if([self.delegate respondsToSelector:@selector(mp_RectForDelete)]) {
        return [self.delegate mp_RectForDelete];
    }
    
    return CGRectZero;
}

- (NSArray<NSIndexPath *> *)getDisableMoveArray {
    if([self.delegate respondsToSelector:@selector(mp_disableMoveItemArray)]) {
        return [self.delegate mp_disableMoveItemArray];
    }
    return nil;
}

- (void)leaveDeleteArea {
    if([self.delegate respondsToSelector:@selector(mp_didLeaveToDeleteArea)]) {
        return [self.delegate mp_didLeaveToDeleteArea];
    }
}

- (void)moveInDeleteArea {
    if([self.delegate respondsToSelector:@selector(mp_didMoveToDeleteArea)]) {
        return [self.delegate mp_didMoveToDeleteArea];
    }
}

- (void)beginGesture {
    if([self.delegate respondsToSelector:@selector(mp_willBeginGesture)]) {
        return [self.delegate mp_willBeginGesture];
    }
}

- (void)endGesture {
    if([self.delegate respondsToSelector:@selector(mp_didEndGesture)]) {
        return [self.delegate mp_didEndGesture];
    }
}

- (UIView *)getMoveMainView {
    if([self.delegate respondsToSelector:@selector(mp_moveMainView)]) {
        return [self.delegate mp_moveMainView];
    }
    return [UIApplication sharedApplication].keyWindow;
    
    
}




@end


