//
//  SFGridView.m
//  SportForum
//
//  Created by zhengying on 6/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "SFGridView.h"
#import "SFGridViewCell.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
        _Pragma("clang diagnostic pop") \
} while (0)


@interface SFGridView () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation SFGridView {
    SFGridViewCell* _cacheGridCell;
    BOOL _bUpHandleLoading;
    id headerRefrshActionTarget;
    SEL didTriggerHeaderRefreshAction;

    id footerRefrshActionTarget;
    SEL didTriggerFooterRefreshAction;
    BOOL _blDownHandleLoading;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    
    int _nCurrentDirectionStatus;   //1 is Horizontal, 0 is Vertical
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.delegate = self;
        self.dataSource = self;
        self.colCount = 2;
        self.cellGapSpace = 0;
        self.leftSpace = 0;
        self.rightSpace = 0;
        _nCurrentDirectionStatus = 0;
        [self reComputerCellSize];
    }
    return self;
}


-(void)reComputerCellSize {
    self.cellWidth = (self.frame.size.width - self.leftSpace - self.rightSpace - self.cellGapSpace * (self.colCount - 1))/ self.colCount;
    self.cellHeight = self.cellWidth;
}

-(void)setColumnCount:(int)nCount
{
    if(nCount > 0)
    {
        self.colCount = nCount;
        [self reComputerCellSize];
    }
}

-(void)setDirection:(int)nDirection
{
    if(_nCurrentDirectionStatus != nDirection)
    {
        _nCurrentDirectionStatus = nDirection;
        [self.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
        if(_nCurrentDirectionStatus)
        {
            self.transform = CGAffineTransformMakeRotation(M_PI/-2);
            self.refreshHeaderView.transform = CGAffineTransformMakeRotation(M_PI/-2);
        }
        else
        {
            self.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.refreshHeaderView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }
    }
}

- (SFGridViewCell *) dequeueReusableCell
{
	SFGridViewCell* reuseCell = _cacheGridCell;
	_cacheGridCell = nil;
	return reuseCell;
}

#pragma mark - table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = ([_gridViewDelegate numberOfCells:self]+(self.colCount-1)) / self.colCount;
    NSLog(@"%ld", count);
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SFGridView";
	
    SFGridMainViewCell *row = (SFGridMainViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (row == nil) {
        row = [[SFGridMainViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        row.selectionStyle = UITableViewCellSelectionStyleNone;
		row.userInteractionEnabled = YES;
        row.strDirection = @"Vertical";
    }
    
    //[self reComputerCellSize];

    CGFloat x = _leftSpace;
    CGFloat gap = _cellGapSpace;
    
    NSInteger cellCount = [_gridViewDelegate numberOfCells:self];
    
    BOOL bNeedTransform = NO;
    if(_nCurrentDirectionStatus && [row.strDirection isEqualToString:@"Vertical"])
    {
        row.strDirection = @"Horizontal";
        bNeedTransform = YES;
        row.contentView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    }
    else if(!_nCurrentDirectionStatus && [row.strDirection isEqualToString:@"Horizontal"])
    {
        row.strDirection = @"Vertical";
        bNeedTransform = YES;
        row.contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    
    for (int i = 0; i<_colCount; i++) {
        
        if ((i + indexPath.row * _colCount) >= cellCount) {
            if ([row.contentView.subviews count] > i) {
                ((SFGridViewCell *)[row.contentView.subviews objectAtIndex:i]).hidden = YES;
            }
            
            continue;
        }
        
        if ([row.contentView.subviews count] > i) {
			_cacheGridCell = [row.contentView.subviews objectAtIndex:i];
		} else {
			_cacheGridCell = nil;
		}
        
        SFGridViewCell* gridcell = [_gridViewDelegate gridView:self Row:indexPath.row Column:i];
        
		if (gridcell.superview != row.contentView) {
            
			[gridcell removeFromSuperview];
			[row.contentView addSubview:gridcell];
			
			[gridcell addTarget:self action:@selector(gridCellClicked:) forControlEvents:UIControlEventTouchUpInside];
		}
        
        gridcell.hidden = NO;
		gridcell.rowIndex = indexPath.row;
		gridcell.colIndex = i;
		
        gridcell.frame = CGRectMake(x, 0, _cellWidth, _cellHeight);
        if(bNeedTransform)
        {
            if(_nCurrentDirectionStatus)
            {
                gridcell.transform = CGAffineTransformMakeRotation(M_PI);
            }
            else
            {
                gridcell.transform = CGAffineTransformMakeRotation(-M_PI);
            }
        }
		x += _cellWidth+gap;
        
    }
    
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(_gridViewDelegate != nil)
    {
        if ([_gridViewDelegate respondsToSelector:@selector(gridHeaderViewHeight:heightForHeaderInSection:)] == YES) {
            return [_gridViewDelegate gridHeaderViewHeight:self heightForHeaderInSection:section];
        }
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_gridViewDelegate != nil) {
        if ([_gridViewDelegate respondsToSelector:@selector(gridHeaderView:viewForHeaderInSection:)] == YES) {
            return [_gridViewDelegate gridHeaderView:self viewForHeaderInSection:section];
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

-(void)gridCellClicked:(id)sender {
    SFGridViewCell *cell = (SFGridViewCell *) sender;
    [_gridViewDelegate gridView:self didSelectRow:cell.rowIndex Column:cell.colIndex];
}

@end
