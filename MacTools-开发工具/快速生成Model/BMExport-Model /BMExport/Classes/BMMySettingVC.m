//
//  BMMySettingVC.m
//  BMExport
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "BMMySettingVC.h"

@interface BMMySettingVC ()

@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *noAddButton;
@property (weak) IBOutlet NSButton *alignmentButton;
@property (weak) IBOutlet NSButton *noAlignmentButton;

@end

@implementation BMMySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_add) {
        _addButton.state = 1;
    } else {
        _noAddButton.state = 1;
    }
    if (_alignment) {
        _alignmentButton.state = 1;
    } else {
        _noAlignmentButton.state = 1;
    }
}

- (IBAction)saveButtonClick:(id)sender {
    [self dismissController:nil];
    !_block ? : _block(_addButton.state, _alignmentButton.state);
}

- (IBAction)addButtonClick:(id)sender {
    _noAddButton.state = 0;
    !_block ? : _block(_addButton.state, _alignmentButton.state);
}

- (IBAction)noAddButtonClick:(id)sender {
    _addButton.state = 0;
    !_block ? : _block(_addButton.state, _alignmentButton.state);
}

- (IBAction)alignmentButtonClick:(id)sender {
    _noAlignmentButton.state = 0;
    !_block ? : _block(_addButton.state, _alignmentButton.state);
}

- (IBAction)noAlignmentButtonClick:(id)sender {
    _alignmentButton.state = 0;
    !_block ? : _block(_addButton.state, _alignmentButton.state);
}

- (IBAction)back:(id)sender {
    [self dismissController:nil];
}

@end
