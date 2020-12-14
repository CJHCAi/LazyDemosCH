//
//  YTBookCollectionViewCell.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/11.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTBookCollectionViewCell.h"

@implementation YTBookCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {

        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.frame.size.width - 20, 0, 20, 20);
        [_deleteBtn setImage:[UIImage imageNamed:@"bookSelectedIcon_nl"] forState:UIControlStateNormal];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        //长按手势
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
        [self addGestureRecognizer:lpgr];
        [_deleteBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//长按手势
- (void)longClick:(UILongPressGestureRecognizer *)lpgr
{
    //    _btn.hidden=NO;
    [self.delegate showAllDeleteBtn];
    
}

-(void)btnClick
{
    
    [self.delegate deleteCellAtIndexpath:_indexPath];
}



@end
