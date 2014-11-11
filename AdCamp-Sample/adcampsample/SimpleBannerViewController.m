//
//  SimpleBannerViewController.m
//  adcampsample
//
//  Created by Mikhail on 17.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "SimpleBannerViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface SimpleBannerViewController () <ADCPlayerDelegate>

@end

@implementation SimpleBannerViewController {
	ADCBannerView *bannerView;
    UIWebView *webView;
}

- (id)init {
    self = [super init];
    if (self) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			self.edgesForExtendedLayout = UIRectEdgeNone;
		}
    }
    return self;
}

- (void)dealloc {
    [bannerView finalize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://adcamp.ru"]]];
    [self.view addSubview:webView];
    
	bannerView = [[ADCBannerView alloc] initWithFrame:CGRectZero];
    bannerView.delegate = self;
    bannerView.placementID = @"a01892d1-6aed-486b-8bf0-a2b65a821b63";
    [self adjustLayout];
	[self.view addSubview:bannerView];
    
    [bannerView startWithChangeTimeInterval:20];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self adjustLayout];
}

- (void)adjustLayout {
    BOOL haveBanner = !bannerView.hidden;
    CGFloat bannerHeight = 50;
    
    CGFloat h = self.view.bounds.size.height;
    webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, h - (haveBanner ? bannerHeight : 0));
	bannerView.frame = CGRectMake(0, h - bannerHeight, self.view.bounds.size.width, bannerHeight);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{
		[self adjustLayout];
	}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark - ADCPlayerDelegate

- (void)player:(id<ADCPlayer>)player willStartAd:(ADCAdvertising *)ad {
    [self adjustLayout];
}

- (void)player:(id<ADCPlayer>)player didFinishAd:(ADCAdvertising *)ad {
    [self adjustLayout];
}

@end
