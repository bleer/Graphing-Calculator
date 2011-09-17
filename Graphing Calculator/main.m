//
//  main.m
//  Graphing Calculator
//
//  Created by Michael Mangold on 7/10/11.
//  Copyright 2011 Michael Mangold. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Graphing_CalculatorAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    @autoreleasepool {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([Graphing_CalculatorAppDelegate class]));
    }
    return retVal;
}
