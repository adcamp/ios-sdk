//
//  UIDevice+Orientation.m
//  adcampsdk
//
//  Created by Mikhail on 08.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "UIScreen+Orientation.h"

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIScreen (Orientation)

- (CGRect)boundsWithOrientation:(UIInterfaceOrientation)orientation {
	CGRect result = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		result = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	}
	return result;
}

- (CGRect)boundsWithCurrentStatusBarOrientation {
	return [self boundsWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
}


@end
