//
//  InputView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputView;

@protocol InputViewDelegate <NSObject>
@optional
/** 下拉选择结束过后 */
-(void)InputView:(InputView *)inputView didFinishSelectLabel:(UILabel *)inputLabel;
/** 开始选择 */
-(void)InputViewDidStartSelectLabel:(InputView *)inputView;
@end

@interface InputView : UIView
@property (nonatomic,strong) UILabel *inputLabel;; /*选择输入的文字*/
@property (nonatomic,assign) NSInteger length; /*长度*/
@property (nonatomic,copy) NSArray *dataArr; /*点出来的数据*/

@property (nonatomic,weak) id<InputViewDelegate> delegate; /*代理人*/

- (instancetype)initWithFrame:(CGRect)frame Length:(NSInteger)length withData:(NSArray *)dataArr;
- (void)reloadInputViewData;
@end
