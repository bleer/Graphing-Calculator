//
//  GraphViewController.m
//  Graphing Calculator
//
//  Created by Michael Mangold on 7/15/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import "GraphView.h"
#import "GraphViewController.h"
#define DEFAULT_SCALE 1;

@implementation GraphViewController

@synthesize graphView, controllerScale, expressionForGraph;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.controllerScale = DEFAULT_SCALE;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    if  (interfaceOrientation == UIInterfaceOrientationPortrait ||
         interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
         interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else {
        return NO;
    }
}

- (void) updateUI
{
    [self.graphView setNeedsDisplay];
}

- (float) scaleForGraphView:(GraphView *) requester;
{
    float tempScale = 0;
    if (requester == self.graphView) {
        tempScale = (float)self.controllerScale;
    }
    return tempScale;
}

- (void) setControllerScale: (int)newControllerScale
{
    if (newControllerScale < 0) newControllerScale = 0;
    if (newControllerScale > 100) newControllerScale = 100;
    controllerScale = newControllerScale;
    [self updateUI];
}

- (id) expressionForGraphView:(GraphView *)requestor
{
    return self.expressionForGraph;
}

- (IBAction)Zoom:(id)sender
{
    NSString *zoomLabel = [[sender titleLabel] text];
    if ([zoomLabel isEqual:@"ZOOM IN"]) {
        self.controllerScale++;
    } else if
        ([zoomLabel isEqual:@"ZOOM OUT"]) {
            self.controllerScale--;
        }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.graphView.delegate = self;
    [self updateUI];
}

@end
