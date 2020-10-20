//
//  ListFrameModel.h
//  ExpandFrameModel
//
//  Created by 栗子 on 2017/12/6.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ListModel.h"


@interface ListFrameModel : NSObject

@property(nonatomic,assign)CGRect questionFrame;
@property(nonatomic,assign)CGRect arrowFrame;
@property(nonatomic,assign)CGRect firstLineFrame;
@property(nonatomic,assign)CGRect answerFrame;
@property(nonatomic,assign)CGRect secondLineFrame;

//cell的高度
//未展开的高度
@property(nonatomic,assign)CGFloat unExpandCellHeight;
//展开的高度
@property(nonatomic,assign)CGFloat expandCellHeight;

@property(nonatomic,strong)ListModel *listModel;

@end
