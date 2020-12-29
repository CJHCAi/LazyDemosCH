//
//  HKSearchView.h
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSearchViewDelegate <NSObject>
@optional
-(void)textChange:(UITextField*)textFile;
@end
@interface HKSearchView : UIView
+(instancetype)searchView;
@property (nonatomic, copy)NSString *searchText;
@property (nonatomic, copy)NSString *placeHoder;
@property (nonatomic, assign)BOOL resignResponder;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@property(nonatomic,weak)id<HKSearchViewDelegate>delegate;
@property (nonatomic, strong)UITextField *tf ;



@end
