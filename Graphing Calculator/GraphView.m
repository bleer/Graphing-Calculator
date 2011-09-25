//
//  GraphView.m
//  Graphing Calculator
//
//  Created by Michael Mangold on 7/17/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"
#import "CalculatorViewController.h"

@implementation GraphView

@synthesize delegate, expression;

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw; // call drawRect whenever bounds change (e.g. on rotate)
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setup];
}

- (void) drawGraph:(CGRect)theGraph atOrigin:(CGPoint)theMidPoint withScale:(CGFloat)theScale inContext:(CGContextRef)theContext
{
    UIGraphicsPushContext(theContext);
    [[UIColor blackColor] setStroke];
    [[UIColor blackColor] setFill];
    [AxesDrawer drawAxesInRect:theGraph originAtPoint:theMidPoint scale:theScale];
    UIColor *curveColor = [[UIColor alloc] initWithRed:162.0f/255.0f green:139.0f/255.0f blue:72.0f/255.0f alpha:1.0f];
    [curveColor set];
    CGContextSetLineWidth(theContext, 2);
    CGContextBeginPath(theContext);
    CGFloat xUL, yUL;                                                               // x and y axes for physical view (origin at upper-left)
    CGFloat xC, yC;                                                                 // x and y axes for the function (origin at center)
    CGFloat xULMax = self.bounds.size.width * self.contentScaleFactor;              // x-axis maximum = width in points x pixels per point
    CGFloat yULMax = self.bounds.size.height * self.contentScaleFactor;             // y-axis maximum = height in points x pixels per point
    for (int i = 0; i <= xULMax; i++) {                                             // sweep across the physical x-axis
        xUL = i;                                                                    // x-axis value is simply the loop index
        xC = (xUL - xULMax / 2) / theScale;                                         // convert x to origin-at-center coordinate system
        yC = [CalculatorBrain evaluateExpression:self.expression usingVariable:xC]; // calculate y
        BOOL error = [self.delegate errorForGraphView:self];
        if (error == YES) {
            break;
        }
        yUL = yULMax / 2 - yC * theScale;                                           // convert y to origin-at-center coordinate system
        if (i == 0) {
            CGContextMoveToPoint(theContext, xUL, yUL);                             // move to initial point
        } else {
            if (yUL <= yULMax) {
                CGContextAddLineToPoint(theContext, xUL, yUL);                      // plot line only to the bottom of the graph
            }
        }
    }
    CGContextStrokePath(theContext);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
// Use delegate here to get scale
    float scale = [self.delegate scaleForGraphView:self];
    if (scale < 1) {
        scale = 1;
    }
    if (scale > 100) {
        scale = 100;
    }

// Use delegate here to get expression
    self.expression = [self.delegate expressionForGraphView:self];
    
    CGRect graph;
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawGraph:graph atOrigin:midPoint withScale:scale inContext:context];
}

@end