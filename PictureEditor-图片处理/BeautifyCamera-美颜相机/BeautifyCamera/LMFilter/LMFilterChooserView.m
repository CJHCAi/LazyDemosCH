//
//  LMFilterChooserView.m
//  LMUpLoadPhoto
//
//  Created by xx11dragon on 15/8/31.
//  Copyright (c) 2015年 xx11dragon. All rights reserved.
//

#import "LMFilterChooserView.h"
#import "LMFilterChooserViewCell.h"
#import "GPUImage.h"
#import <Masonry/Masonry.h>

//#include "UIImage+Filter.h"

static float const cell_width = 90.0f;

@interface LMFilterChooserView () {
    LMFilterChooserViewCell *_selectCell;
    NSArray *_filters;
    NSMutableArray *_cells;
    BOOL _start;
    NSInteger _currentSelectIndex;
}

@end

@implementation LMFilterChooserView


- (void)addFilters:(NSArray *)filters{
    _currentSelectIndex = 0;
    _filters = filters;
    _cells = [NSMutableArray arrayWithCapacity:0];
    
    self.showsHorizontalScrollIndicator = NO;
    if (self.subviews.count) [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.contentSize = CGSizeMake(cell_width * _filters.count, self.bounds.size.height);
    self.translatesAutoresizingMaskIntoConstraints = NO;
   
    UIView *horizontalContainerView = [[UIView alloc] init];
    [self addSubview:horizontalContainerView];
    [horizontalContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    
    __block UIView *previousView =nil;
    [_filters enumerateObjectsUsingBlock:^(GPUImageFilterGroup *filters, NSUInteger idx, BOOL *stop) {
//        LMFilterChooserViewCell *cell = [[LMFilterChooserViewCell alloc] initWithFrame:CGRectMake(self.contentSize.width + idx * cell_width, 0.0f, cell_width, self.bounds.size.height)];
        LMFilterChooserViewCell *cell = [[LMFilterChooserViewCell alloc] init];
        
        cell.tag = idx + 1;
        [cell setFilter:(LMFilterGroup *)filters];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
        [cell addGestureRecognizer:tap];
        [horizontalContainerView addSubview:cell];
        [_cells addObject:cell];
        
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(cell_width);
            if (previousView){
                make.left.mas_equalTo(previousView.mas_right);
            }
            else{
                make.left.mas_equalTo(0);
            }
        }];
        
        previousView = cell;
    }];
    
    [horizontalContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(previousView.mas_right);
    }];
    
    LMFilterChooserViewCell *cell = _cells[0];
    [cell setState:UIControlStateSelected];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];

//    if (!_start) [self animationStart];

//}
//
//- (void)animationStart {
//    __weak LMFilterChooserView *weakSelf = self;
//    [_cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [weakSelf performSelector:@selector(go:) withObject:obj afterDelay:idx *0.05f];
//        
//    }];
//
//    _start = YES;
//    
//}
//
//- (void) go:(id)timer {
//    
//    LMFilterChooserViewCell *cell = (LMFilterChooserViewCell *)timer;

//    [UIView animateWithDuration:0.5f animations:^{
//        
//        cell.frame = CGRectMake((cell.tag - 1) * cell_width - 10, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//        
//    }completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.2f animations:^{
//            cell.frame = CGRectMake((cell.tag - 1) * cell_width , cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//        }];
//        
//    }];
//}

- (void)clicked:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == (_currentSelectIndex +1)) return;
    
    LMFilterChooserViewCell *cell = (LMFilterChooserViewCell *)tap.view;
    
    
    
    [_cells enumerateObjectsUsingBlock:^(LMFilterChooserViewCell *  _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell setState:UIControlStateNormal];
    }];
    [cell setState:UIControlStateSelected];
    
    _currentSelectIndex = tap.view.tag - 1;

    if (_filterChooserBlock) {
        _filterChooserBlock(cell.getFilter ,tap.view.tag - 1);
    }
}

- (void)addSelectedEvent:(LMFilterChooserBlock)filterChooseBlock {
    _filterChooserBlock = [filterChooseBlock copy];
}

- (void)updateSelectFilter: (NSInteger) filterIndex{
    LMFilterChooserViewCell *cell = [_cells objectAtIndex:_currentSelectIndex];
    [cell setState:UIControlStateNormal];
    _currentSelectIndex = filterIndex;
    
    cell = [_cells objectAtIndex:_currentSelectIndex];
    [cell setState:UIControlStateSelected];
    
    CGRect rect= CGRectMake(cell.bounds.size.width * filterIndex, 0, cell.bounds.size.width, cell.bounds.size.height);
    [self scrollRectToVisible:rect animated:YES];
}
@end
