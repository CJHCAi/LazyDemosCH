//
//  ARBookCollectionViewCell.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/27.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARBookCollectionViewCell.h"

@implementation ARBookCollectionViewCell

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
