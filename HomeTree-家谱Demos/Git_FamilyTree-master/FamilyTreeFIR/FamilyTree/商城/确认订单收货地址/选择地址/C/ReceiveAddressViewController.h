//
//  ReceiveAddressViewController.h
//  CheLian
//
//  Created by imac on 16/5/4.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveAddressModel.h"
@protocol ReceiveAddressViewControllerDelegate <NSObject>

- (void)didSelectAddress:(ReceiveAddressModel *)sender;

@end

@interface ReceiveAddressViewController : BaseViewController

@property (weak,nonatomic) id<ReceiveAddressViewControllerDelegate>delegate;

@end
