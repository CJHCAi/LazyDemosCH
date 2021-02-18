//
//  DataSelectPickView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/16.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataSelectPickView : UIView
@property (nonatomic,copy) NSArray *dataSource; /*数据*/
@property (nonatomic,strong) UIPickerView *pickerView; 


@end
