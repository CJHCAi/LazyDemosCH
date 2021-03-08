//
//  AnswerScrollView.h
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/11.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerScrollView : UIView

-(instancetype) initWithFrame:(CGRect)frame withDataArray:(NSArray *)array;

//当前选择题只有一个时候，需要判断
@property(nonatomic,assign,readonly) int currentPage;
@end
