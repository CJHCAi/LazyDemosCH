//
//  singleMajiangNode.h
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SingleMajiang.h"

@interface singleMajiangNode : SKSpriteNode

@property (nonatomic) SingleMajiang *mj;

- (void)settingWithMj:(SingleMajiang *)mj;

- (void)settingStatus:(MajiangStatus)status;

@end
