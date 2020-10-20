//
//  LeftViewController.h
//  Text_QQMainView
//
//  Created by jaybin on 15/4/18.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  CellSelectedBolck
 */
typedef  void (^CellSelectedBolck)(NSString *desc);


@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    CellSelectedBolck _cellSelectedBolck;
}

@property (nonatomic, strong) CellSelectedBolck cellSelectedBolck;

@end
