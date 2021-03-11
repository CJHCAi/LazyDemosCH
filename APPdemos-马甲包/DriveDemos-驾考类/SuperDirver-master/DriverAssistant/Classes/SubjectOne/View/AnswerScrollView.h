//
//  AnswerScrollView.h
//  DriverAssistant
//
//  Created by C on 16/3/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol scrollDelegate
- (void)scrollViewDidEndDecelerating:(int)index;
- (void)answerQuestion:(NSArray *)questionArr;

@end

@interface AnswerScrollView : UIView
@property (nonatomic, weak) id<scrollDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array;
-(void)reloadData;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign, readonly) int currentPage;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *hadAnswerArray;
/**
 答题模式和背题模式切换临时数组,答题模式存储0，背题模式存储1
 */
@property (nonatomic, strong) NSMutableArray *tempAnswerArray;


@end
