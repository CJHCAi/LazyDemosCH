//
//  CreatFamilyTree.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    CreatefamilyTreeTypeThreeBtn,
    CreatefamilyTreeTypeTwoBtn
    
} CreatefamilyTreeType;


@class CreatFamilyTree;

@protocol CreatFamilyTreeDelegate <NSObject>

-(void)CreateFamilyTree:(CreatFamilyTree *)creatTree didSelectedBtn:(UIButton *)sender;

@end

@interface CreatFamilyTree : UIView

@property (nonatomic,assign) CreatefamilyTreeType type; /*类型*/


@property (nonatomic,weak) id<CreatFamilyTreeDelegate> delegate; /*代理人*/


- (instancetype)initWithFrame:(CGRect)frame withType:(CreatefamilyTreeType)type;

@end
