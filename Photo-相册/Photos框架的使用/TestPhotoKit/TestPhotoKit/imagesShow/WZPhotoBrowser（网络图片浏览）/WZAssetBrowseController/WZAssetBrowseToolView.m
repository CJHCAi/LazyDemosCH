//
//  WZAssetBrowseToolView.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZAssetBrowseToolView.h"

@implementation WZAssetBrowseToolView

+ (instancetype)customAssetBrowseToolWithDelegate:(id<WZProtocolAssetBrowseTool>)delegate {
    WZAssetBrowseToolView *tool = [[WZAssetBrowseToolView alloc] init];
    tool.delegate = delegate;
    CGFloat toolH = 49.0;
    tool.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - toolH, [UIScreen mainScreen].bounds.size.width, toolH);
    tool.backgroundColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:0.4];
    
    tool.selectedButtonClear = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat button_origionHW = 72 / 2.0;
    tool.selectedButtonClear.frame = CGRectMake(5.0, (toolH - button_origionHW)/2.0 , button_origionHW, button_origionHW);
    
    [tool.selectedButtonClear setImage:[UIImage imageNamed:@"asset_selectedOrigion_normal"] forState:UIControlStateNormal];
        [tool.selectedButtonClear setImage:[UIImage imageNamed:@"asset_selectedOrigion_selected"] forState:UIControlStateSelected];
    
    tool.clearInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tool.selectedButtonClear.frame), 0.0, [UIScreen mainScreen].bounds.size.width / 2.0, toolH)];
    tool.clearInfoLabel.text = @"选择原图";
    tool.clearInfoLabel.textColor = [UIColor whiteColor];
    
    __weak typeof(tool) weakTool = tool;
    tool.fetchClearInfo = ^(NSString *info){
        weakTool.clearInfoLabel.text = [NSString stringWithFormat:@"选择原图(%@)", info];
    };
    
    tool.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat completeButtonHW = 45.0;
    tool.completeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - completeButtonHW - 15.0, (toolH - completeButtonHW)/2.0, completeButtonHW, completeButtonHW);
    [tool.completeButton setTitle:@"发送" forState:UIControlStateNormal];
    tool.completeButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [tool.completeButton setTitleColor:[UIColor colorWithRed:254.0 / 255  green:191.0 / 255 blue:39.0 / 255 alpha:1.0] forState:UIControlStateNormal];
    [tool.completeButton setTitleColor:[UIColor colorWithRed:254.0 / 255  green:191.0 / 255 blue:39.0 / 255 alpha:1.0] forState:UIControlStateHighlighted];
    CGFloat label_HW = 20.0;
    
    tool.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tool.completeButton.frame) -label_HW, (toolH - label_HW)/2.0, label_HW, label_HW)];
    tool.countLabel.backgroundColor = [UIColor colorWithRed:254.0 / 255  green:191.0 / 255 blue:39.0 / 255 alpha:1.0];
    tool.countLabel.text = @"0";
    tool.restrictNumber = ^(NSUInteger restrictNumber){
        weakTool.countLabel.text = [NSString stringWithFormat:@"%ld", restrictNumber];
    };
    tool.countLabel.layer.cornerRadius = label_HW / 2.0;
    tool.countLabel.layer.masksToBounds = true;
    tool.countLabel.textAlignment = NSTextAlignmentCenter;
    tool.countLabel.textColor = [UIColor whiteColor];
    
    [tool addSubview:tool.selectedButtonClear];
    [tool addSubview:tool.completeButton];
    [tool addSubview:tool.clearInfoLabel];
    [tool addSubview:tool.countLabel];
    
    [tool.completeButton addTarget:tool action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tool.selectedButtonClear addTarget:tool action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    return tool;
}

- (void)clickedBtn:(UIButton *)sender {
    if (sender == self.selectedButtonClear) {
        if ([_delegate respondsToSelector:@selector(selectedOrigionAction)]) {
            [_delegate selectedOrigionAction];
        }
    } else if (sender == self.completeButton) {
        if ([_delegate respondsToSelector:@selector(completeAction)]) {
            [_delegate completeAction];
        }
    }
}

@end
