//
//  Graphing_CalculatorAppDelegate.h
//  Graphing Calculator
//
//  Created by Michael Mangold on 7/10/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorViewController.h"

@interface Graphing_CalculatorAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CalculatorViewController *cvc;
@property (strong, nonatomic) UINavigationController *navcon;

@end
