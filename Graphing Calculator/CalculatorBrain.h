//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Michael Mangold on 6/18/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
{   // instance variables
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    double memory;
    NSMutableArray *internalExpression;
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

+ (double)evaluateExpression:(id)anExpression usingVariable:(double)variable;
+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
