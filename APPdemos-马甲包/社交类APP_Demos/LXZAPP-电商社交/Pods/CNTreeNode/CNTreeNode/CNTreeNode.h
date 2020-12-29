//
//  CNTreeNode.h
//
//  Created by Frank Gregor on 13.01.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2014 Frank Gregor, <phranck@cocoanaut.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


/**
 Using `CNTreeNode` is a convenient and easy way to build a tree of nested objects. You can use it as a datasource for your table view, source view etc.
 */
@interface CNTreeNode : NSObject

#pragma mark - Child Node Collections
/** @name Child Node Collections */

/**
 Property that indicates whether the receiver has child nodes or not.
 
 @return `YES` if the receiver has child nodes, otherwise `NO`.
 */
@property (assign, nonatomic, readonly) BOOL hasChildNodes;

/**
 An array of all child nodes.
 */
@property (strong, nonatomic, readonly) NSArray *childNodes;

/**
 An array of all child nodes flattened to one level.
 
 This tree of nodes:

    node 1.0.0
        node 1.1.0
            node 1.1.1
        node 1.2.0
    node 2.0.0
    node 3.0.0
        node 3.1.0

 Will become this:

    node 1.0.0
    node 1.1.0
    node 1.1.1
    node 1.2.0
    node 2.0.0
    node 3.0.0
    node 3.1.0

 */
@property (strong, nonatomic, readonly) NSArray *childNodesFlattened;

/**
 Returns the number of all child nodes up to the highest level.
 
 It searches recursively all child nodes starting at the receiver.
 */
@property (assign, nonatomic, readonly) NSUInteger deepNumberOfChildNodes;



#pragma mark - Manipulating Child Node Collections
/** @name Manipulating Child Node Collections */

/**
 Adds an instance of `CNTreeNode` to the receiver as a child.
 
 The level for newly added child will be set automatically (increased by 1).

 @param theChild An instance of `CNTreeNode`.
 @see nodeLevel
 */
- (void)addChild:(CNTreeNode *)theChild;

/**
 Adds an array of nodes.
 
 All array elements *must* be a `CNTreeNode` instance.

 @param theChildNodes An array of child nodes.
 */
- (void)addChildNodes:(NSArray *)theChildNodes;

/**
 Inserts an instance of `CNTreeNode` at the given index.
 
 All following indexes will be moved backwards.

 @param childNode An instance of `CNTreeNode` to be inserted.
 @param index     The index the child node should be placed.
 */
- (void)insertChild:(CNTreeNode *)childNode atIndex:(NSUInteger)index;

/**
 Removes the given child node.

 @param childNode An instance of `CNTreeNode` to be removed.
 */
- (void)removeChild:(CNTreeNode *)childNode;

/**
 Removes a child node at the given index.

 @param index The index of the child node that should be removed.
 */
- (void)removeChildAtIndex:(NSUInteger)index;



#pragma mark - Handling Child Nodes
/** @name Handling Child Nodes */

/**
 Returns the child node at the given index.

 @param index The index of the child node that should be returned.

 @return The requested `CNTreeNode` instance.
 */
- (CNTreeNode *)childAtIndex:(NSUInteger)index;



#pragma mark - Managing Parent Nodes
/** @name Managing Parent Nodes */

/**
 Property representing the parent `CNTreeNode` object.

 The parent object is one level up from the receivers level. The lowest level is `0`.
 @see nodeLevel
 */
@property (strong) CNTreeNode *parentNode;



#pragma mark - Child Node States
/** @name Child Node States */

/**
 Property that indicates whether the receiver is expanded.
 
 This property is useful if `CNTreeNode` is used to visualize a tree. You can mark specific tree nodes as 
 being expanded or collapsed.
 
 @return `YES` if the node is expanded (default value), otherwise `NO`.
 */
@property (assign, getter = isExpanded) BOOL expanded;

/**
 Property that indicates the current level.
 
 Example:
 
    node 1.0.0              -> level 0
        node 1.1.0          -> level 1
            node 1.1.1      -> level 2
        node 1.2.0          -> level 1
    node 2.0.0              -> level 0
    node 3.0.0              -> level 0
        node 3.1.0          -> level 1
 
 The level will be determined dynamically each time it is requested. It starts from the receiver up to all its
 parent nodes. The lowest level is `1`.
 */
@property (assign, nonatomic, readonly) NSUInteger nodeLevel;


#pragma mark - Child Node Content
/** @name Child Node Content */

/**
 Property to hold yor data object.
 
 This is meant as the "placeholder" for your data object the receiver represents.
 */
@property (strong) id objectValue;

@end
