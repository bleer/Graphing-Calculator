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
    CGFloat x, y;                                                     // x and y axes for local view (origin at upper-left)
    CGFloat functionX, functionY;                                     // x and y axes for the function (origin at center)
    CGFloat xMax = self.bounds.size.width * self.contentScaleFactor;  // x-axis maximum = width in points x pixels per point
    CGFloat yMax = self.bounds.size.height * self.contentScaleFactor; // y-axis maximum = height in points x pixels per point
    for (int i = 0; i <= xMax; i++) {
        x = i;                                                        // x-axis value is simply the loop index
        functionX = x - self.bounds.size.width / theScale / 2;        // convert to expression's coordinate system
        functionY = [CalculatorBrain evaluateExpression:self.expression usingVariable:i]; // functionY = f(functionX)
        y = self.bounds.size.height / 2 / theScale - functionY;
        if (i == 0) {
            CGContextMoveToPoint(theContext, x, y);                   // move to initial point
        } else {
            if (y <= yMax) {
                CGContextAddLineToPoint(theContext, x, y);            // plot line only to the bottom of the graph
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