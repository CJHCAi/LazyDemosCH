//
//  LLTableViewDataSource.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "LLTableViewDataSource.h"
#import "UIView+Sunshine.h"

@interface LLTableViewDataSource ()<UITableViewDataSource, UITableViewDelegate>

@end
@implementation LLTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView loading]) {
        return [self.loadingDelegate loadingTableView:tableView numberOfRowsInSection:section];
    }else {
        return [self.replace_dataSource tableView:tableView numberOfRowsInSection:section];
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView loading]) {
        UITableViewCell *cell = [self.loadingDelegate loadingTableView:tableView cellForRowAtIndexPath:indexPath];
        [self beginLoadingAnimation:cell];
        return cell;
    }else {
        UITableViewCell *cell = [self.replace_dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        [self stopLoadingAnimation:cell];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView loading]) {
        if ([self.loadingDelegate respondsToSelector:@selector(sectionsOfloadingTableView:)]) {
            return [self.loadingDelegate sectionsOfloadingTableView:tableView];
        }
        return 1;
    }else {
        if ([self.replace_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            return [self.replace_dataSource numberOfSectionsInTableView:tableView];
        }
        return 1;
    }
}              // Default is 1 if not implemented

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.replace_dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [self.replace_dataSource tableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}    // fixed font style. use custom view (UILabel) if you want something different

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([self.replace_dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [self.replace_dataSource tableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.replace_dataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return YES;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [self.replace_dataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return YES;
}

// Index

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([self.replace_dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [self.replace_dataSource sectionIndexTitlesForTableView:tableView];
    }
    return nil;
}                             // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self.replace_dataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [self.replace_dataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    return index;
}  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.replace_dataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if ([self.replace_dataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.replace_dataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}
// Display customization



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.replace_delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [self.replace_delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [self.replace_delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [self.replace_delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView loading]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingTableView:viewForHeaderInSection:)]) {
            UIView *header = [self.loadingDelegate loadingTableView:tableView viewForHeaderInSection:section];
            if (header) {
                return [self.replace_delegate tableView:tableView heightForHeaderInSection:section];
            }
        }
    }else {
        if ([self.replace_delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
            return [self.replace_delegate tableView:tableView heightForHeaderInSection:section];
        }
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView loading]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingTableView:viewForFooterInSection:)]) {
            UIView *footer = [self.loadingDelegate loadingTableView:tableView viewForFooterInSection:section];
            if (footer) {
                return [self.replace_delegate tableView:tableView heightForFooterInSection:section];
            }
        }
    }else {
        if ([self.replace_delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
            return [self.replace_delegate tableView:tableView heightForFooterInSection:section];
        }
    }
    return 0.0001f;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)]) {
        return [self.replace_delegate tableView:tableView estimatedHeightForHeaderInSection:section];
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)]) {
        return [self.replace_delegate tableView:tableView estimatedHeightForFooterInSection:section];
    }
    return 0.0001f;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView loading]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingTableView:viewForHeaderInSection:)]) {
            UIView *header = [self.loadingDelegate loadingTableView:tableView viewForHeaderInSection:section];
            [self beginLoadingAnimation:header];
            return header;
        }
        return nil;
    }else {
        if ([self.replace_delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
            UIView *header = [self.replace_delegate tableView:tableView viewForHeaderInSection:section];
            [self stopLoadingAnimation:header];
            return header;
        }
        return nil;
    }
}   // custom view for header. will be adjusted to default or specified header height

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView loading]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingTableView:viewForFooterInSection:)]) {
            UIView *footer = [self.loadingDelegate loadingTableView:tableView viewForFooterInSection:section];
            [self beginLoadingAnimation:footer];
            return footer;
        }
        return nil;
    }else {
        if ([self.replace_delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
            UIView *footer = [self.replace_delegate tableView:tableView viewForFooterInSection:section];
            [self beginLoadingAnimation:footer];
            return footer;
        }
        return nil;
    }
}   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures).

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    if ([self.replace_delegate respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)]) {
//        return [self.replace_delegate tableView:tableView accessoryTypeForRowWithIndexPath:indexPath];
//    }
//    return UITableViewCellAccessoryNone;
//}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)]) {
        [self.replace_delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

// Use -tableView:trailingSwipeActionsConfigurationForRowAtIndexPath: instead of this method, which will be deprecated in a future release.
// This method supersedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    return nil;
}

// Swipe actions
// These methods supersede -editActionsForRowAtIndexPath: if implemented
// return nil to get the default swipe actions
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 && TARGET_OS_IOS
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView leadingSwipeActionsConfigurationForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView leadingSwipeActionsConfigurationForRowAtIndexPath:indexPath];
    }
    return nil;
}
#endif
// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    return YES;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [self.replace_delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [self.replace_delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    return sourceIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    return 0;
} // return 'depth' of row for hierarchies

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return [self.replace_delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    return NO;

}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [self.replace_delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

// Focus
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000 && TARGET_OS_IOS
- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:canFocusRowAtIndexPath:)]) {
        return [self.replace_delegate tableView:tableView canFocusRowAtIndexPath:indexPath];
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:shouldUpdateFocusInContext:)]) {
        return [self.replace_delegate tableView:tableView shouldUpdateFocusInContext:context];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:didUpdateFocusInContext:withAnimationCoordinator:)]) {
        [self.replace_delegate tableView:tableView didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    }
}

- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView {
    if ([self.replace_delegate respondsToSelector:@selector(indexPathForPreferredFocusedViewInTableView:)]) {
        return [self.replace_delegate indexPathForPreferredFocusedViewInTableView:tableView];
    }
    return nil;
}

#endif
// Spring Loading
// Allows opting-out of spring loading for an particular row.
// If you want the interaction effect on a different subview of the spring loaded cell, modify the context.targetView property. The default is the cell.
// If this method is not implemented, the default is YES except when the row is part of a drag session.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 && TARGET_OS_IOS
- (BOOL)tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context {
    if ([self.replace_delegate respondsToSelector:@selector(tableView:shouldSpringLoadRowAtIndexPath:withContext:)]) {
        return [self.replace_delegate tableView:tableView shouldSpringLoadRowAtIndexPath:indexPath withContext:context];
    }
    return NO;
}
#endif

- (void)beginLoadingAnimation:(__kindof UIView *)view {
    [view beginSunshineAnimation];
    for (UIView *subview in view.subviews) {
        [self beginLoadingAnimation:subview];
    }
}

- (void)stopLoadingAnimation:(__kindof UIView *)view {
    [view endSunshineAnimation];
    for (UIView *subview in view.subviews) {
        [self stopLoadingAnimation:subview];
    }
}
@end
