//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Michael Mangold on 6/18/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphView.h"

@interface CalculatorBrain : NSObject <GraphViewDelegate>
{   // instance variables
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    double memory;
    NSMutableArray *internalExpression;
    BOOL errorForGraph;
    GraphView *graphView;
}

- (void)setOperand:(double)anOperand :(BOOL)radiansIsSelected;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOperation:(NSString *)operation;
- (double)setMemoryDisplay;

@property (copy) NSString *waitingOperation;
@property (strong, readonly) id expression;
@property (nonatomic) double operand;
@property double waitingOperand;
@property double memory;
@property (strong, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic) BOOL errorForGraph;

+ (double)evaluateExpression:(id)anExpression usingVariable:(double)variable;
+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
