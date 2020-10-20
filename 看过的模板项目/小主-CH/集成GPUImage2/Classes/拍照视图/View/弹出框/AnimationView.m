//
//  AnimationView.m
//  CameraDemo
//
//  Created by apple on 2017/3/21.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import "AnimationView.h"
#import <CoreText/CoreText.h>

@interface AnimationView()

{
    NSMutableArray *labels;
    NSMutableArray *numArr;
    NSMutableArray *dataArr;
}

@end

@implementation AnimationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
    

        UIImageView * imageView=[[UIImageView alloc]init];
        imageView.image=[UIImage imageNamed:@"弹出框"];
        
        [self addSubview:imageView];
        
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(MatchWidth(19));
        make.right.equalTo(self).with.offset(-MatchWidth(10.0));
        make.top.equalTo(self).with.offset(MatchHeight(53));
        CGFloat W=SCREENWIDTH-MatchWidth(29);
        CGSize imageSize=[UIImage imageNamed:@"弹出框"].size;

        double X=imageSize.height/imageSize.width;
        CGFloat H=W*X;
        make.size.mas_equalTo(CGSizeMake(W, H));
        
    }];
      
        //点击事件
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
 
        
    }
    return self;
}

-(void)dismiss{

    [UIView animateWithDuration:1 animations:^{
        
        self.alpha=0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if ([self.AnimationViewDeledate respondsToSelector:@selector(dismissEndCallBack)]) {
            [self.AnimationViewDeledate dismissEndCallBack];
        }
        
    }];

}
@end
