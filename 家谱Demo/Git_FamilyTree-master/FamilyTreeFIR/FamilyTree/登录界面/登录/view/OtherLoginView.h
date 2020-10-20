//
//  OtherLoginView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OtherLoginView;
@protocol OtherLoginViewDelegate <NSObject>

-(void)OtherLoginView:(OtherLoginView *)otherloginView didSelectedBtn:(UIButton *)sender;

@end
@interface OtherLoginView : UIView

@property (nonatomic,weak)   id<OtherLoginViewDelegate> delegate; /*代理人*/


@end
