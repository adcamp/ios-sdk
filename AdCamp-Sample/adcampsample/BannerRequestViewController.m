//
//  RotationBannerViewController.m
//  adcampsample
//
//  Created by Mikhail on 22.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "BannerRequestViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface BannerRequestViewController () <ADCRequestDelegate>

@end

@implementation BannerRequestViewController {
	ADCBannerView *bannerView;
	ADCRequest *adRequest;
    
    ADCAdvertising *ad;
}

- (void)dealloc {
	[bannerView finalize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}

	bannerView = [[ADCBannerView alloc] initWithFrame:CGRectZero];
    bannerView.placementID = @"a01892d1-6aed-486b-8bf0-a2b65a821b63";
	[self.view addSubview:bannerView];
	[self adjustBanner];

	adRequest = [ADCRequest defaultRequest];
    adRequest.delegate = self;
	[adRequest addBannerImpressionForPlayer:bannerView];
    [adRequest run];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self adjustBanner];
}

- (void)adjustBanner {
	bannerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{
		[self adjustBanner];
	}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark - ADCRequestDelegate

- (void)request:(ADCRequest *)request didReceiveBanner:(ADCAdvertising *)banner {
    ad = banner;
}

- (void)requestDidFinishLoading:(ADCRequest *)request {
    if (ad) {
        [bannerView playAd:ad];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Не удалось получить рекламу" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

@end
