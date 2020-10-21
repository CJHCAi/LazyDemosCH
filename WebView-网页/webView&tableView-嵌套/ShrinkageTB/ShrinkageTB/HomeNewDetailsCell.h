//
//  HomeNewDetailsCell.h
//  BasicFW
//
//  Created by xxlc on 2019/6/13.
//  Copyright © 2019 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface HomeNewDetailsCell : UITableViewCell
@property (nonatomic, copy) NSString *urlStr;
/** WKWebView */
@property (nonatomic, strong) WKWebView *wkWebView;


@property (nonatomic, copy) void(^gotoNextBtnBlock)(CGFloat wkHeight);

@end

NS_ASSUME_NONNULL_END
