//
//  SKVoiceFilter.h
//  SKVoiceWave
//
//  Created by ac-hu on 2018/10/24.
//  Copyright © 2018年 SK-HU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKVoiceFilter : NSObject

@property(nonatomic,strong)NSData *data;

-(NSArray *)filteredSamplesForSize:(CGSize)size;

@end
