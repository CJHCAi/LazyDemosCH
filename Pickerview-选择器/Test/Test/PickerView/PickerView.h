//
//  PickerView.h
//  Test
//
//  Created by K.O on 2018/7/20.
//  Copyright © 2018年 rela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "PickerModel.h"
typedef NS_ENUM(NSInteger, PickerViewType) {
PickerViewTypeSex,//性别
PickerViewTypeHeigh,//身高
PickerViewTypeWeight,//体重
PickerViewTypeBirthday,//出生年月
PickerViewTypeTime,//时分秒
PickerViewTypeRange,//区间范围比如筛选
PickerViewTypeCity,//城市
};


@protocol PickerViewResultDelegate <NSObject>
@optional
- (void)pickerView:(UIView *)pickerView result:(NSString *)string;
@end



@interface PickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView *picker;
@property (nonatomic,strong)UIDatePicker *datePicke;
@property(nonatomic,assign)PickerViewType type;
@property(nonatomic,strong)NSMutableArray *array;

//默认选中第一列
@property (nonatomic,assign)NSInteger selectComponent;


@property(nonatomic,weak)id<PickerViewResultDelegate>delegate;
@end
