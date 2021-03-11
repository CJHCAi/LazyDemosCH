//
//  AnswerScrollView.h
//  StudyDrive
//
//  Created by zgl on 16/1/7.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerScrollView : UIView
{
    @public
    UIScrollView * _scrollView;
}

@property(nonatomic,assign,readonly)int currentPage;
@property(nonatomic,strong)NSMutableArray *hadAnswerArray;
@property(nonatomic,strong)NSArray *dataArray;

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array;

@end
