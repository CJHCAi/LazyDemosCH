//
//  SearchTVC.h
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"
#import "DetailListController.h"
@interface SearchTVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)Search *search;
@end
