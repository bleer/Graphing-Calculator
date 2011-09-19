//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Mangold on 6/18/11.
//  Copyright 2011 Michael Mangold. All rights reserved..
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
@property (nonatomic, retain) CalculatorBrain *brain; 
@end

@implementation CalculatorViewController

@synthesize digit, display, displayMemory, miniDisplay, radiansDegreesSwitch, brain;

- (CalculatorBrain *)brain
{
    if (!brain) {
        brain = [[CalculatorBrain alloc] init];
        if (self.radiansDegreesSwitch.on) {
            radiansIsSelected = YES;
        } else {
            radiansIsSelected = NO;
        }
    }
    return brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    operandIsAVariable = NO;
    self.digit = [[sender titleLabel] text];
    if ([@"Π" isEqual:self.digit]) {
        self.digit = @"3.14159265";
    }
    if (userIsInTheMiddleOfTypingANumber) {
        NSRange range = [self.display.text rangeOfString:@"."];
        if ((range.length < 1) || (![self.digit isEqual:@"."])) { // Ignore more than one decimal
            [self.display setText:[self.display.text stringByAppendingString:self.digit]];
            self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:self.digit];
        }
    } else if (variablePressed) {
        NSString *tempExpression;
        tempExpression = [CalculatorBrain descriptionOfExpression:brain.expression];
        [self.display setText:[tempExpression stringByAppendingString:self.digit]];
        [self.miniDisplay setText:self.digit];
    }
    else {
        [self.display setText:self.digit];
        [self.miniDisplay setText:self.digit];
    }
    userIsInTheMiddleOfTypingANumber = YES;
}

- (IBAction)operationPressed:(UIButton *)sender;
{
    NSString *operation = [[sender titleLabel] text];
    NSString *operand = self.miniDisplay.text;
    if ([operation isEqual:@"C"]) {
        self.miniDisplay.text = @"0";
    } else {
        self.miniDisplay.text = operation;
    }
    if ([@"BACKSPACE" isEqual:operation]) {
        double displayTextLength = [self.display.text length];
        if ( displayTextLength > 1 ) {
            [self.display setText:[self.display.text substringToIndex:[self.display.text length] - 1]]; // strip last digit from display
        } else {
            self.display.text = @"0";
        }
        double miniDisplayTextLength = [self.miniDisplay.text length];
        if ( miniDisplayTextLength > 1 ) {
            [self.miniDisplay setText:[self.miniDisplay.text substringToIndex:[self.miniDisplay.text length] - 1]]; // strip last digit from miniDisplay
        } else {
            self.miniDisplay.text = @"0";
        }
    } else {
        NSString *checkText = self.display.text;
        if (([checkText isEqual:@"0"]) && ([operation isEqual:@"INV"])) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Divide by Zero Error."
                                  message:@"Cannot Use Inverse When Operand is 0."
                                  delegate:nil
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil];
            [alert show];
        } else {
            if (userIsInTheMiddleOfTypingANumber) { // send operand to brain
                [[self brain] setOperand:[operand doubleValue]: radiansIsSelected];
                userIsInTheMiddleOfTypingANumber = NO;
            }
            double result;
            if (!([operation isEqual:@"GRAPH"])) { // don't perform the operation if GRAPH is chosen
                result = [[self brain] performOperation:operation];
                if (!operandIsAVariable || ([operation isEqual:@"C"])) { // not an equation or if Clear operation
                    [self.display setText:[NSString stringWithFormat:@"%g", result]]; // update display
                }
            }
            if (!variablePressed) {
                double transferMemory = [[self brain] setMemoryDisplay];
                [self.displayMemory setText:[NSString stringWithFormat:@"%g", transferMemory]];
            }
            if (variablePressed) {
                NSString *tempExpression;
                tempExpression = [CalculatorBrain descriptionOfExpression:brain.expression];
            }
            if ([operation isEqual:@"GRAPH"]) {
                variablePressed = NO; // reset variablePressed for next go-around
                GraphViewController *gvc = [[GraphViewController alloc] init];
                gvc.title = @"Graph";
                gvc.view.autoresizesSubviews = YES;
                gvc.expressionForGraph = brain.expression;
                [self.navigationController pushViewController:gvc animated:YES];
            }
        }
    }
}

- (IBAction)variablePressed:(UIButton *)sender;
{
    variablePressed = YES;
    operandIsAVariable = YES;
    NSString *variableName = [[sender titleLabel] text];
    [[self brain] setVariableAsOperand:variableName];
    [self.display setText:[CalculatorBrain descriptionOfExpression: brain.expression]];
    [self.miniDisplay setText:variableName];
}

- (IBAction) changeRadiansDegreesSwitch: (id) sender {  
    if (self.radiansDegreesSwitch.on) {
        radiansIsSelected = YES;
    } else {
        radiansIsSelected = NO;
    }
} 

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    if  (interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else {
        return NO;
    }
}

@end
