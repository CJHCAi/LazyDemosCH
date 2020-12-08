//
//  ARSearchBar.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARSearchBar.h"

@implementation ARSearchBar

+ (ARSearchBar *)searchBarWithPlaceholder:(NSString *)placeholder {
    ARSearchBar *searchBar = [[ARSearchBar alloc] init];
    searchBar.delegate = searchBar;
    searchBar.placeholder = placeholder;
    searchBar.tintColor = [UIColor whiteColor];
    [searchBar setImage:[UIImage imageNamed:@"search_sousuoicon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UIView *searchBarSub = searchBar.subviews[0];
    for (UIView *subView in searchBarSub.subviews) {
        
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            [subView setBackgroundColor:RGB(196, 30, 28)];
            
        }
        
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subView removeFromSuperview];
        }
        
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subView;
            textField.textColor = [UIColor whiteColor];
            [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
            textField.borderStyle = UITextBorderStyleNone;
        }
    }
    
    
    return searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    !self.searchBarShouldBeginEditingBlock ? : self.searchBarShouldBeginEditingBlock();
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    !self.searchBarTextDidChangedBlock ? : self.searchBarTextDidChangedBlock();
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    !self.searchBarDidSearchBlock ? : self.searchBarDidSearchBlock();
}


@end
