/*
 https://github.com/waynezxcv/Gallop
 
 Copyright (c) 2016 waynezxcv <liuweiself@126.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "LWTextContainer.h"
#import <objc/runtime.h>
#import "GallopUtils.h"
#import "GallopDefine.h"




@interface LWTextContainer ()

@property (nonatomic,assign) CGSize size;
@property (nonatomic,strong) UIBezierPath* path;
@property (nonatomic,assign) UIEdgeInsets edgeInsets;

@end

@implementation LWTextContainer{
    dispatch_semaphore_t _lock;
    CGFloat _pathLineWidth;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    LWTextContainer* one = [[LWTextContainer alloc] init];
    one.vericalAlignment = self.vericalAlignment;
    one.size = self.size;
    one.path = [self.path copy];
    one.edgeInsets = self.edgeInsets;
    one.maxNumberOfLines = self.maxNumberOfLines;
    return one;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.vericalAlignment forKey:@"vericalAlignment"];
    [aCoder encodeCGSize:self.size forKey:@"size"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeUIEdgeInsets:self.edgeInsets forKey:@"edgeInsets"];
    [aCoder encodeInteger:self.maxNumberOfLines forKey:@"maxNumberOfLines"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.vericalAlignment = [aDecoder decodeIntegerForKey:@"vericalAlignment"];
        self.size = [aDecoder decodeCGSizeForKey:@"size"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.edgeInsets = [aDecoder decodeUIEdgeInsetsForKey:@"edgeInsets"];
        self.maxNumberOfLines = [aDecoder decodeIntegerForKey:@"maxNumberOfLines"];
    }
    return self;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _lock = dispatch_semaphore_create(1);
    return self;
}


+ (id)lw_textContainerWithSize:(CGSize)size {
    LWTextContainer* textContainer = [[LWTextContainer alloc] init];
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    textContainer.path = bezierPath;
    textContainer.size = size;
    textContainer.edgeInsets = UIEdgeInsetsZero;
    textContainer.maxNumberOfLines = 0;
    textContainer.vericalAlignment = LWTextVericalAlignmentTop;
    return textContainer;
}

+ (id)lw_textContainerWithSize:(CGSize)size edgeInsets:(UIEdgeInsets)edgeInsets {
    LWTextContainer* textContainer = [[LWTextContainer alloc] init];
    CGRect rect = (CGRect) {CGPointZero,size};
    rect = UIEdgeInsetsInsetRect(rect,edgeInsets);
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRect:rect];
    textContainer.path = bezierPath;
    textContainer.size = size;
    textContainer.edgeInsets = edgeInsets;
    textContainer.maxNumberOfLines = 0;
    textContainer.vericalAlignment = LWTextVericalAlignmentTop;
    return textContainer;
}

#pragma mark - Getter

- (CGFloat)pathLineWidth {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    CGFloat width = _pathLineWidth;
    dispatch_semaphore_signal(_lock);
    return width;
}


@end
