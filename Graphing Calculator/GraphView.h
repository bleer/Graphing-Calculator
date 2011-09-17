//
//  GraphView.h
//  Graphing Calculator
//
//  Created by Michael Mangold on 7/17/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDelegate
- (float) scaleForGraphView:(GraphView *) requester;   // scale to zoom graph
- (id) expressionForGraphView:(GraphView *) requestor; // expression to be graphed
@end

@interface GraphView : UIView {
    __unsafe_unretained id <GraphViewDelegate> delegate;
}

@property (assign) id <GraphViewDelegate> delegate;
@property (assign) id expression;

@end