//
//  singleMajiangNode.m
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "singleMajiangNode.h"

@interface singleMajiangNode ()


@property (nonatomic) NSString *imageName;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@end

@implementation singleMajiangNode

- (void)settingWithMj:(SingleMajiang *)mj
{
    _mj = mj;
    [self settingStatus:mj.status];
    //[self setColor:[UIColor blueColor]];
}

- (void)settingStatus:(MajiangStatus)status
{
    switch (status) {
        case Pile:
            
            break;
        case PileUpAndDown:
            _imageName = @"mjBack_v";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case PileLeftAndRight:
            _imageName = @"mjBack_h";
            _width = mjBackWidth_h;
            _height = mjBackHeight_h;
            break;
            
        case RrightHave:
            _imageName = @"rightHave";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case UpHave:
            _imageName = @"upHave";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case LeftHave:
            _imageName = @"leftHave";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case MeHave:
            _imageName = [NSString stringWithFormat:@"%d",(int)_mj.type];
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case RightPut:
            _imageName = @"mjBack_v";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case UpPut:
            _imageName = @"mjBack_v";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case LeftPut:
            _imageName = @"mjBack_v";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        case MePut:
            _imageName = @"mjBack_v";
            _width = mjBackWidth_v;
            _height = mjBackHeight_v;
            break;
            
        default:
            break;
    }
    NSLog(@"inageNae:  %@",_imageName);
    [self updateUI];
}

- (void)updateUI
{
    [self setTexture:[SKTexture textureWithImage:[UIImage imageNamed:_imageName]]];
    [self setSize:CGSizeMake(_width, _height)];
        [self reloadInputViews];
}
@end
