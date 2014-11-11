//
//  UIDevice+Orientation.h
//  adcampsdk
//
//  Created by Mikhail on 08.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Orientation)

- (CGRect)boundsWithCurrentStatusBarOrientation;
- (CGRect)boundsWithOrientation:(UIInterfaceOrientation)orientation;

@end
