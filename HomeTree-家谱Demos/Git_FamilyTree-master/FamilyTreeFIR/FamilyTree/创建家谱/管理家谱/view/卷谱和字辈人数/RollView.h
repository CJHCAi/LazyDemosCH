//
//  RollView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
//十位以上的数字和个位数字竖着显示
typedef enum : NSUInteger {
    RollViewTypeDecade,//十位
    RollViewTypeUnitsDigit,//个位
} RollViewType;

@interface RollView : UIView
/**卷谱id*/
@property (nonatomic,copy) NSString *rollJPId;
/**卷谱名字*/
@property (nonatomic,copy) NSString *rollJPName;




- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title rollType:(RollViewType)rollType;

@end
