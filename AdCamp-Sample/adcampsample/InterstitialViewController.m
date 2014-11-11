//
//  InterstitialViewController.m
//  adcampsample
//
//  Created by Mikhail on 08.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "InterstitialViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface InterstitialViewController () <ADCRequestDelegate>

@end

@implementation InterstitialViewController {
	BOOL displayingBanner;
	ADCRequest *_adRequest;
	ADCAdvertising *_ad;
}

- (id)initWithAd:(ADCAdvertising *)ad {
    self = [super init];
    if (self) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			self.edgesForExtendedLayout = UIRectEdgeNone;
		}
		
        _ad = ad;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
    [_ad presentAsInterstitialFromRootViewController:self];
    _ad = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if ([self isBeingDismissed] || [self isMovingFromParentViewController]) {
		[_adRequest cancel];
	}
}

@end
