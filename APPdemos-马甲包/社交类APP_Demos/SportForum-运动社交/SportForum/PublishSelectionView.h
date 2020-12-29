//
//  PublishSelectionView.h
//  SportForum
//
//  Created by zhengying on 7/10/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    PUBLISH_MODE_NORMAL,
    PUBLISH_MODE_CUSTOM,
}PUBLISH_MODE;

typedef void (^PublishActionBlock)(id sender);
typedef void (^CloseActionBlock)(id sender);

@interface PublishSelectionView : UIView
@property(nonatomic, weak) IBOutlet UIView* contentView;
@property(nonatomic, weak) IBOutlet UIButton*  btnQuit;
@property(nonatomic, weak) IBOutlet UIButton*  btnPicText;
@property(nonatomic, weak) IBOutlet UIButton*  btnRecordScroe;
@property(nonatomic, weak) IBOutlet UIButton*  btnRecordGame;
@property(nonatomic, weak) IBOutlet UIView* picTextView;
@property(nonatomic, weak) IBOutlet UIView* scoreView;
@property(nonatomic, weak) IBOutlet UIView* gameView;

@property(nonatomic, weak) IBOutlet UIView*  viewBarShadow;
@property(nonatomic, strong) PublishActionBlock ActionBlockPicText;
@property(nonatomic, strong) PublishActionBlock ScroeActionBlockRecord;
@property(nonatomic, strong) PublishActionBlock GameActionBlockRecord;
@property(nonatomic, strong) CloseActionBlock closeActionBlock;

- (void) showInView:(UIView*)view PublishMode:(PUBLISH_MODE)ePubType;
- (void) hide;
@end
