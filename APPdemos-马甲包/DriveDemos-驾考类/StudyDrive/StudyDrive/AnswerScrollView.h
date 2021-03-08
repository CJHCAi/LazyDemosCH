//
//  AnswerScrollView.h
//  StudyDrive
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerScrollView : UIView
{
    @public
    UIScrollView * _scrollView;
}
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array;
-(void)reloadData;
@property(nonatomic,assign,readonly)int currentPage;
@property(nonatomic,strong)NSMutableArray *hadAnswerArray;
@property(nonatomic,strong)NSArray *dataArray;
@end
