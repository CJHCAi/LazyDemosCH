//
//  PortraiView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortraiView : UIView
/**成员id*/
@property (nonatomic,copy) NSString *mygemId;


- (instancetype)initWithFrame:(CGRect)frame portaitImageUrl:(NSString *)pImageUrl porName:(NSString *)name infoArr:(NSArray *)infoArr;
@end
