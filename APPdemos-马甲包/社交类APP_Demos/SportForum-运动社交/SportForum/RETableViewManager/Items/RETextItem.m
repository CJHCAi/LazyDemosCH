//
// RETextItem.m
// RETableViewManager
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RETextItem.h"

@implementation RETextItem

+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value
{
    return [[self alloc] initWithTitle:title value:value];
}

+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder
{
    return [[self alloc] initWithTitle:title value:value placeholder:placeholder];
}

- (id)initWithTitle:(NSString *)title value:(NSString *)value
{
    return [self initWithTitle:title value:value placeholder:nil];
}

- (id)initWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder
{
    self = [super init];
    if (!self)
        return nil;
    
    self.title = title;
    self.value = value;
    self.placeholder = placeholder;
    
    return self;
}

#pragma mark -
#pragma mark Error validation

- (NSArray *)errors
{
    return [REValidation validateObject:self.value name:self.name ? self.name : self.title validators:self.validators];
}

@end
