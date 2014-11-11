//
//  RotationBannerViewController.m
//  visdk
//
//  Created by Mikhail on 22.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "RotationBannerViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface RotationBannerViewController ()

@end

@implementation RotationBannerViewController {
	ADCBannerView *banner;
	
	int bannerHeightPortrait, bannerHeightLandscape;
}

- (void)dealloc {
	[banner stop];
    NSLog(@"dealloc rotation");
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}

	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		bannerHeightLandscape = 90;
		bannerHeightPortrait = 90;
	} else {
		bannerHeightLandscape = 32;
		bannerHeightPortrait = 50;
	}
	banner = [[ADCBannerView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:banner];
	[self adjustBanner];

	OpenRTBBanner *rtbBanner = [[OpenRTBBanner alloc] init];
	rtbBanner.position = @(OpenRTBAdPositionHeader);
	OpenRTBImpression *imp = [OpenRTBImpression impressionWithBanner:rtbBanner];
	ADCRequest *adRequest = [ADCRequest defaultRequest];
	[adRequest addImpression:imp withContext:nil];
	[banner startWithRequest:adRequest changeTimeInterval:15];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self adjustBanner];
}

- (void)adjustBanner {
	banner.frame = CGRectMake(0, 0, self.view.bounds.size.width, bannerHeightPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{
		[self adjustBanner];
	}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

@end
