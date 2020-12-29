//
// Copyright 2011-2014 NimbusKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <UIKit/UIKit.h>

#import "NIPagingScrollView.h"

/**
 * A skeleton implementation of a page view.
 *
 * This view simply implements the required properties of NIPagingScrollViewPage.
 *
 * @ingroup NimbusPagingScrollView
 */
@interface NIPagingScrollViewPage : NIRecyclableView <NIPagingScrollViewPage>
@property (nonatomic) NSInteger pageIndex;
@end

/**
 * Use NIPagingScrollViewPage instead.
 *
 * This class will be deleted after February 28, 2014.
 *
 * @ingroup NimbusPagingScrollView
 */
__NI_DEPRECATED_METHOD
@interface NIPageView : NIPagingScrollViewPage
@end

/**
 * The page index.
 *
 * @fn NIPageView::pageIndex
 */
