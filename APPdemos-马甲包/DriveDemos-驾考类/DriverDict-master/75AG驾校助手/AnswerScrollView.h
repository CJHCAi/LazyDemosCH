//
//  AnswerScrollView.h
//  75AG驾校助手
//
//  Created by again on 16/3/31.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerScrollView : UIView{
    @public
    
    UIScrollView *_scrollView;
}
//@property (strong,nonatomic) UIScrollView *scrollView;

- (void)reloadData;
- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray*)array;
@property (readonly,nonatomic) int currentPage;
@property (strong,nonatomic) NSMutableArray *hadAnswerArray;
@property (strong,nonatomic) NSArray *dataArray;
@end
