//
//  WAllGenView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAllGenView : UIView
/**sex*/
@property (nonatomic,assign) BOOL sex;
/**model*/
- (instancetype)initWithFrame:(CGRect)frame model:(WpersonInfoModel *)infoModel;

@end
