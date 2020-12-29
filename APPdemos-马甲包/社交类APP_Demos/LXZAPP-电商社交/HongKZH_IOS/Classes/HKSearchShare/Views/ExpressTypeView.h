//
//  ExpressTypeView.h
//  LHand
//
//  Created by wanghui on 2018/1/8.
//  Copyright © 2018年 HandsUp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ExpressType_0 = 0,
    ExpressType_1 = 1,
    ExpressType_2 = 2
}ExpressType;
@protocol ExpressTypeViewDelegate <NSObject>

@optional
-(void)btnClicks:(ExpressType)expressType;
@end
@interface ExpressTypeView : UIView
+(instancetype)getExpressTypeView;
-(void)btnClick:(UIButton*)btn;
@property (nonatomic,weak) id<ExpressTypeViewDelegate> delegete;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property(nonatomic, assign) int type;
@end
