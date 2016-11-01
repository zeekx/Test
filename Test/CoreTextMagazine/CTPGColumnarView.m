//
//  CTPGColumnarView.m
//  Test
//
//  Created by yubinqiang on 16/10/27.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGColumnarView.h"

@interface CTPGColumnarView ()
@property (copy  , nonatomic) NSAttributedString *attributedString;
@end

@implementation CTPGColumnarView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.attributedString = [[NSAttributedString alloc] initWithString:@"One of the most common operations in typesetting is laying out a multiline paragraph within an arbitrarily sized rectangular area. Core Text makes this operation easy, requiring only a few lines of Core Text–specific code. To lay out the paragraph, you need a graphics context to draw into, a rectangular path to provide the area where the text is laid out, and an attributed string. Most of the code in this example is required to create and initialize the context, path, and string. After that is done, Core Text requires only three lines of code to do the layout.\n"
                                 "Laying out text in multiple columns is another common typesetting operation. Strictly speaking, Core Text itself only lays out one column at a time and does not calculate the column sizes or locations. You do those operations before calling Core Text to lay out the text within the path area you’ve calculated. In this sample, Core Text, in addition to laying out the text in each column, also provides the subrange within the text string for each column."];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context coordinates in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Initializing a graphic context in OS X is different:
    // CGContextRef context =
    //     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    
    // Call createColumnsWithColumnCount function to create an array of
    // three paths (columns).
    CFArrayRef columnPaths = [self createColumnsWithColumnCount:3];
    
    // Create a frame for each column (path).
    for (CFIndex column = 0, startIndex = 0; column < CFArrayGetCount(columnPaths); column++) {
        // Get the path for this column.
        CGPathRef path = (CGPathRef)CFArrayGetValueAtIndex(columnPaths, column);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        // Create a frame for this column and draw it.
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        
        // Start the next frame at the first character not visible in this frame.
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    CFRelease(columnPaths);
    CFRelease(framesetter);
}

- (CFArrayRef)createColumnsWithColumnCount:(int)columnCount
{
    int column;
    
    CGRect* columnRects = (CGRect*)calloc(columnCount, sizeof(*columnRects));
    // Set the first column to cover the entire view.
    columnRects[0] = self.bounds;
    
    // Divide the columns equally across the frame's width.
    CGFloat columnWidth = CGRectGetWidth(self.bounds) / columnCount;
    for (column = 0; column < columnCount - 1; column++) {
        CGRectDivide(columnRects[column], &columnRects[column],
                     &columnRects[column + 1], columnWidth, CGRectMinXEdge);
    }
    
    // Inset all columns by a few pixels of margin.
    for (column = 0; column < columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column], 8.0, 15.0);
    }
    
    // Create an array of layout paths, one for each column.
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, columnCount, &kCFTypeArrayCallBacks);
    
    for (column = 0; column < columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    free(columnRects);
    return array;
}
@end
