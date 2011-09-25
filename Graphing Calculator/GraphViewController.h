//
//  GraphViewController.h
//  Graphing Calculator
//
//  Created by Michael Mangold on 7/15/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDelegate>
{
    int controllerScale; // 0 to 100
    id expressionForGraph;
    GraphView *graphView;
}

@property (strong, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic) int controllerScale;
@property (strong, nonatomic) id expressionForGraph;

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation;

@end