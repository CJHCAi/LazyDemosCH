//
//  DiagnosisTableViewCell.h
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabLabelView.h"
@class DiseaseTableViewCell;
@protocol DiagnosisDelegate <NSObject>

- (void) showArray:(UIButton *_Nonnull)button;

@end
NS_ASSUME_NONNULL_BEGIN

@interface DiagnosisTableViewCell : UITableViewCell <TabLabelViewDelegate>
@property (strong , nonatomic) UILabel *subTitleLabel;
@property (strong , nonatomic) TabLabelView *labelView;
@property (weak , nonatomic) id<DiagnosisDelegate>delegate;
@property (nonatomic , strong) NSArray *dataArray;
- (CGFloat)CellHeight;
+ (instancetype)instanceWithDiagnosisTableViewCellIdentifier ;

@end

NS_ASSUME_NONNULL_END
