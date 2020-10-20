//
//  UICollectionView+Loading.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <objc/runtime.h>
#import "UICollectionView+Loading.h"
#import "UIView+Sunshine.h"
#import "LLCollectionViewDataSource.h"

@interface UICollectionView ()
@property (nonatomic, strong)LLCollectionViewDataSource<UICollectionViewDataSource> *origin_delegate;

@end
@implementation UICollectionView (Loading)

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
    });
}


- (void)t_setDataSource:(id<UICollectionViewDataSource>)dataSource {
    [self origin_delegate].replace_dataSource = dataSource;
    [self t_setDataSource:[self origin_delegate]];
}

- (void)setLoadingDelegate:(id<UICollectionViewLoadingDelegate>)loadingDelegate {
    ((LLCollectionViewDataSource *)self.dataSource).loadingDelegate = loadingDelegate;
    objc_setAssociatedObject(self, @selector(loadingDelegate), loadingDelegate, OBJC_ASSOCIATION_ASSIGN);
}
- (id<UICollectionViewLoadingDelegate>)loadingDelegate {
    return objc_getAssociatedObject(self, @selector(loadingDelegate));
}

- (void)setOrigin_delegate:(LLCollectionViewDataSource<UICollectionViewDataSource> *)origin_delegate {
    objc_setAssociatedObject(self, @selector(origin_delegate), origin_delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LLCollectionViewDataSource<UICollectionViewDataSource> *)origin_delegate {
    LLCollectionViewDataSource<UICollectionViewDataSource> *del = objc_getAssociatedObject(self, @selector(origin_delegate));
    if (!del) {
        del = (id<UICollectionViewDataSource>)[LLCollectionViewDataSource new];
        [self setOrigin_delegate:del];
    }
    return del;
}

- (void)startLoading {
    if ([self.loadingDelegate conformsToProtocol:@protocol(UICollectionViewLoadingDelegate)]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingCollectionView:numberOfItemsInSection:)] && [self.loadingDelegate respondsToSelector:@selector(loadingCollectionView:cellForItemAtIndexPath:)]) {
            [self setLoading:YES];
            self.allowsSelection = NO;
            self.scrollEnabled = NO;
            [self reloadData];
        }
    }
}

- (void)stopLoading {
    if ([self.loadingDelegate conformsToProtocol:@protocol(UICollectionViewLoadingDelegate)]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingCollectionView:numberOfItemsInSection:)] && [self.loadingDelegate respondsToSelector:@selector(loadingCollectionView:cellForItemAtIndexPath:)]) {
            [self setLoading:NO];
            self.allowsSelection = YES;
            self.scrollEnabled = YES;
            [self reloadData];
        }
    }
}

- (void)setLoading:(BOOL)loading {
    objc_setAssociatedObject(self, @selector(loading), @(loading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)loading {
    return [objc_getAssociatedObject(self, @selector(loading)) boolValue];
}


@end
