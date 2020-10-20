//
//  ListFrameModel.m
//  ExpandFrameModel
//
//  Created by 栗子 on 2017/12/6.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "ListFrameModel.h"

@implementation ListFrameModel

-(void)setListModel:(ListModel *)listModel{
    _listModel = listModel;
    
    self.questionFrame  = CGRectMake(10, 18, LZScreenW-60, 15);
    self.arrowFrame     = CGRectMake(LZScreenW-30, 18, 15, 15);
    self.firstLineFrame = CGRectMake(0, 43, LZScreenW, 1);
    self.unExpandCellHeight = CGRectGetMaxY(self.firstLineFrame)+5;
    
    CGFloat answerH     = [Healp getStringHeight:listModel.answer andFont:15 andWidth:LZScreenW-20];
    self.answerFrame    = CGRectMake(10, 50, LZScreenW-20, answerH);
    self.secondLineFrame    = CGRectMake(0, CGRectGetMaxY(self.answerFrame)+5, LZScreenW, 1);
    
    self.expandCellHeight = CGRectGetMaxY(self.secondLineFrame);
    
}

@end
