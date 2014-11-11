//
//  MixedAdViewController.m
//  adcampsample
//
//  Created by Mikhail on 11.10.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "MixedAdViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface MixedAdViewController ()

@end

@implementation MixedAdViewController {
	ADCMixedAdView *adView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			self.edgesForExtendedLayout = UIRectEdgeNone;
		}
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (!adView) {
		adView = [[ADCMixedAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        adView.placementID = @"a01892d1-6aed-486b-8bf0-a2b65a821b63";
		adView.preferredAdType = ADCAdTypeBanner;
		[self.view addSubview:adView];
	}
	
	[adView start];
}

@end
