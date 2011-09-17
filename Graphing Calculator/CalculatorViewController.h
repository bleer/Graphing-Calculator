//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Michael Mangold on 6/18/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#import "GraphViewController.h"
@interface CalculatorViewController: UIViewController {
    CalculatorBrain *brain;
    BOOL userIsInTheMiddleOfTypingANumber;
    BOOL radiansIsSelected;
    BOOL expressionSolved;
    BOOL operandIsAVariable;
    BOOL variablePressed;
}
@property (assign) NSString *digit;
@property (assign) IBOutlet UILabel *display;
@property (assign) IBOutlet UILabel *displayMemory;
@property (assign) IBOutlet UILabel *miniDisplay; // Shows current operand
@property (assign) IBOutlet UISwitch *radiansDegreesSwitch;

- (IBAction) digitPressed: (UIButton *) sender;
- (IBAction) operationPressed: (UIButton *) sender;
- (IBAction) variablePressed: (UIButton *) sender;
- (IBAction) changeRadiansDegreesSwitch: (id) sender;
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation;

@end