//
//  UITableView+Loading.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "UITableView+Loading.h"
#import "LLTableViewDataSource.h"

@interface UITableView ()
@property (nonatomic, strong)LLTableViewDataSource<UITableViewDataSource, UITableViewDelegate> *origin_delegate;

@end
@implementation UITableView (Loading)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method datasource = class_getInstanceMethod(self.class, @selector(setDataSource:));
        Method datasource_replace = class_getInstanceMethod(self.class, @selector(t_setDataSource:));
        BOOL didAddMethod = class_addMethod(self.class, @selector(setDataSource:), method_getImplementation(datasource_replace), method_getTypeEncoding(datasource_replace));
        if (didAddMethod) {
            class_replaceMethod(self.class, @selector(t_setDataSource:),
                                method_getImplementation(datasource),
                                method_getTypeEncoding(datasource));
        } else {
            method_exchangeImplementations(datasource, datasource_replace);
        }
        
        Method delegate = class_getInstanceMethod(self.class, @selector(setDelegate:));
        Method delagate_replace = class_getInstanceMethod(self.class, @selector(t_setDelegate:));
        BOOL didAddMethod2 = class_addMethod(self.class, @selector(setDelegate:), method_getImplementation(delagate_replace), method_getTypeEncoding(delagate_replace));
        if (didAddMethod2) {
            class_replaceMethod(self.class, @selector(t_setDelegate:),
                                method_getImplementation(delegate),
                                method_getTypeEncoding(delegate));
        } else {
            method_exchangeImplementations(delegate, delagate_replace);
        }

    });
}


- (void)t_setDataSource:(id<UITableViewDataSource>)dataSource {
    
    [self origin_delegate].replace_dataSource = dataSource;
    [self t_setDataSource:[self origin_delegate]];
}

- (void)t_setDelegate:(id<UITableViewDelegate>)delegate {
     [self origin_delegate].replace_delegate = delegate;
    [self t_setDelegate:[self origin_delegate]];
}

- (void)setLoading:(BOOL)loading {
    objc_setAssociatedObject(self, @selector(loading), @(loading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)loading {
    return [objc_getAssociatedObject(self, @selector(loading)) boolValue];
}

- (void)setLoadingDelegate:(id<UITableViewLoadingDelegate>)loadingDelegate {
    ((LLTableViewDataSource *)self.dataSource).loadingDelegate = loadingDelegate;
    objc_setAssociatedObject(self, @selector(loadingDelegate), loadingDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UITableViewLoadingDelegate>)loadingDelegate {
    return objc_getAssociatedObject(self, @selector(loadingDelegate));
}

- (void)setOrigin_delegate:(LLTableViewDataSource<UITableViewDataSource,UITableViewDelegate> *)origin_delegate {
    objc_setAssociatedObject(self, @selector(origin_delegate), origin_delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LLTableViewDataSource<UITableViewDataSource,UITableViewDelegate> *)origin_delegate {
    LLTableViewDataSource<UITableViewDataSource,UITableViewDelegate> *del = objc_getAssociatedObject(self, @selector(origin_delegate));
    if (!del) {
        del = (id<UITableViewDataSource, UITableViewDelegate>)[LLTableViewDataSource new];
        [self setOrigin_delegate:del];
    }
    return del;
}


- (void)startLoading {
    if ([self.loadingDelegate conformsToProtocol:@protocol(UITableViewLoadingDelegate)]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingTableView:numberOfRowsInSection:)] && [self.loadingDelegate respondsToSelector:@selector(loadingTableView:cellForRowAtIndexPath:)]) {
            self.loading = YES;
            self.allowsSelection = NO;
            self.scrollEnabled = NO;
            [self reloadData];
        }
    }
}

- (void)stopLoading {
    if ([self.loadingDelegate conformsToProtocol:@protocol(UITableViewLoadingDelegate)]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingTableView:numberOfRowsInSection:)] && [self.loadingDelegate respondsToSelector:@selector(loadingTableView:cellForRowAtIndexPath:)]) {
            self.loading = NO;
            self.allowsSelection = YES;
            self.scrollEnabled = YES;
            [self reloadData];
        }
    }
}

@end
