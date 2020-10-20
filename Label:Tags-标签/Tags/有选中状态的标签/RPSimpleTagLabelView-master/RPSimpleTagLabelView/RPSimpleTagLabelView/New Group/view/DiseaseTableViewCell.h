//
//  DiseaseTableViewCell.h
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DeleteDrugsDelegate <NSObject>
@optional
- (void)deleteDrugsWithLabel:(UILabel *)label;

@end
@interface DiseaseTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIView *line;
@property (nonatomic ,strong) UILabel *label;
@property (nonatomic , strong) NSMutableArray *drugsArray;
@property (nonatomic , assign) CGFloat buttonHeight;
@property (weak,nonatomic) id <DeleteDrugsDelegate> delegate;
- (CGFloat)CellHeight;

+ (instancetype)instanceWithDiseaseCellIdentifier;

@end

NS_ASSUME_NONNULL_END
