//
//  FTQuestionOptionCell.h
//  FaceTraningForManager
//  带点击的选项Cell
//  Created by caixiang on 2017/6/29.
//  Copyright © 2017年 aopeng. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FTQuestionOptionCell : UITableViewCell
@property (strong ,nonatomic) NSIndexPath *indexPath;

/**拖拽cell*/
- (void)drawdragCell;
/**重置拖拽cell*/
- (void)resetDrawdragCell;
/**填充cell数据*/
- (void)fillCellWithObject:(id)objct;


@end
