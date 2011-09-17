//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Michael Mangold on 6/18/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import "CalculatorBrain.h"
#define VARIABLE_PREFIX @"$"

@implementation CalculatorBrain

@synthesize expression, waitingOperation, operand, waitingOperand, memory;

// overriding the default initializer
- (id) init {
    // initializing the internalExpression array
    internalExpression = [[NSMutableArray alloc] init];
    return self;
}

// overriding the setter for 'operand' property
- (void)setOperand:(double)anOperand :(BOOL)radiansIsSelected
{
    if (radiansIsSelected) {
        operand = anOperand;
    } else {
        operand = anOperand * M_PI / 180;
    }
    // Transfer operand to the expression array, used for X Y Z and SOLVE buttons
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [internalExpression addObject:operandObject];
}

// getter for expression property
- (id) expression {
    // return a copy of the internal expression array
    NSMutableArray *exp = [internalExpression copy];
    return exp;
}

- (double)setMemoryDisplay
{
    return memory;
}

-(void)performWaitingOperation:(NSString *) operation
{
    // if waitingOperation is nil then return
    if (!self.waitingOperation) {
        return;
    }
    if ([waitingOperation isEqual:@"+"]) {
        operand = waitingOperand + operand;
    } else if ([waitingOperation isEqual:@"-"]) {
        operand = waitingOperand - operand;
    } else if ([waitingOperation isEqual:@"*"]) {
        operand = waitingOperand * operand;
    } else if ([waitingOperation isEqual:@"/"]) {
        if (operand) {
            operand = waitingOperand / operand;
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Divide by Zero Error."
                                  message:@"Cannot Use Division When Operand is 0."
                                  delegate:nil
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (double)performOperation:(NSString *)operation;
{
    if ([operation isEqual:@"SQRT"]) {
        if (operand < 0) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Imaginary Number Error."
                                  message:@"Cannot Use Sqrt When Operand is negative."
                                  delegate:nil
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else {
            operand = sqrt(operand);
        }
    } else if ([operation isEqual:@"INV"]) {
        operand = 1 / operand;
    } else if ([operation isEqual:@"+/-"]) {
        operand = -1 * operand;
    } else if ([operation isEqual:@"SIN"]) {
        operand = sin(operand);
    } else if ([operation isEqual:@"COS"]) {
        operand = cos(operand);
    } else if ([operation isEqual:@"MR"]) {
        operand = memory;
    } else if ([operation isEqual:@"M+"]) {
        memory = operand + memory;
    } else if ([operation isEqual:@"MC"]) {
        memory = 0;
    } else if ([operation isEqual:@"C"]) {
        operand = 0;
        waitingOperand = 0;
        self.waitingOperation = nil;
        [internalExpression removeAllObjects];
    } else {
        [self performWaitingOperation:operation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    // Transfer operation to the expression array, used for X Y Z and SOLVE buttons
    if (![operation isEqual:@"C"]) {
        [internalExpression addObject:operation];
    }
    if ([operation isEqual:@"="]) { // Reset internalExpression after = is pressed and processed.
        [internalExpression removeAllObjects];
    }
    return self.operand;
}

// Transfer variableName to the expression array, used for X Y Z buttons
- (void)setVariableAsOperand:(NSString *)variableName
{
    NSString *vp = VARIABLE_PREFIX;
    NSString *variableNameWithPrefix = [vp stringByAppendingString:variableName];
    [internalExpression addObject:variableNameWithPrefix];
}

+ (double)evaluateExpression:(id)anExpression usingVariable:(double)variable {
    CalculatorBrain *evaluateBrain = [[CalculatorBrain alloc] init];
    for (id expressor in anExpression) {
        if ([expressor isKindOfClass:[NSNumber class]]) {
            evaluateBrain.operand = [expressor doubleValue];
        } else if ([expressor isKindOfClass:[NSString class]] && ([expressor length] == 2)) {    // expressor is a variable.
            evaluateBrain.operand = variable;
        }
        [evaluateBrain performOperation:expressor];
    }
    double evaluation = evaluateBrain.operand;
    return evaluation;
}

// returns the list of unique variables in the expression
+ (NSSet *) variablesInExpression: (id) anExpression {
    // declaring a set to store variables uniquely
    NSMutableSet *variableSet = [[NSMutableSet alloc] init];
    // memory management
    // looping through the expression to search for string objects that start with a '$'
    for (id object in anExpression) {
        // check if current object in expression is a string
        if ([object isKindOfClass:[NSString class]]) {
            // if the string object is a variable that is marked by the sign '$'
            if ([object rangeOfString:@"$"].location != NSNotFound) {
                // add the variable to the set
                [variableSet addObject:[NSString stringWithFormat:@"%c", [object characterAtIndex:1]]];
            }
        }
    }
    // if the set is empty return nil
    if ([variableSet count] == 0) {
        variableSet = nil;
    }
    return variableSet;
}

// class method that returns the entire expression without evaluating.
+ (NSString *) descriptionOfExpression: (id) anExpression {
    NSMutableString *description = [[NSMutableString alloc] init];
    // enumerating through the expression array and appending to the mutable string
    for (id object in anExpression) {
        if (([object isKindOfClass:[NSString class]]) && ([object characterAtIndex:0] == '$')) {
            [description appendString:[NSString stringWithFormat:@"%c", [object characterAtIndex:1]]];
        } else {
            [description appendString:[object description]];
        }
    }
    return description;
}

+ (id) propertyListForExpression: (id) anExpression {
    
    // return a copy of the internal expression mutable array
    NSMutableArray *pl = [anExpression copy];
    return pl;
}

+ (id) expressionForPropertyList: (id) propertyList {
    // return a copy of the internal expression mutable array
    NSMutableArray *exp = [propertyList copy];
    return exp;
}

@end
