//
//  ORTBBannerViewController.m
//  adcampsample
//
//  Created by Mikhail on 25.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "ORTBBannerViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface ORTBBannerViewController () <ADCRequestDelegate>

@end

@implementation ORTBBannerViewController {
	ADCBannerView *bannerView;
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
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self adjustBanner];
	[self updateBanner];
}

- (void)updateBanner {
	ADCRequest *adRequest = [ADCRequest defaultRequest];
	OpenRTBBidRequest *bidRequest = adRequest.bidRequest;
	bidRequest.app.content.producer.name = @"Никита Михалков";
	bidRequest.app.content.producer.categories = @[@"IAB25-2", @"IAB25-3"];
	bidRequest.app.content.producer.domain = @"ru.mikhalkov";
	bidRequest.app.content.producer.ext = @{@"some_key": @"some_value"};
	bidRequest.app.content.episode = @"2";
	bidRequest.app.content.title = @"Утомлённые солнцем 2: Предстояние";
	bidRequest.app.content.season = @"Сезон 1";
	bidRequest.app.content.url = @"us2.ru";
	bidRequest.app.content.categoriesOfContent = @[@"IAB25-2"];
	bidRequest.app.content.quality = @(OpenRTBVideoQualityProsumer);
	bidRequest.app.content.keywords = @"Утомлённые, солнцем, Предстояние";
	bidRequest.app.content.context = @(OpenRTBContentContextVideo);
	bidRequest.app.content.isLiveStream = @YES;
	bidRequest.app.content.sourceRelationship = @(OpenRTBContentSourceRelationshipIndirect);
	bidRequest.app.content.length = @96;
	bidRequest.app.content.QAGMediaRating = @(OpenRTBQAGMediaRatingMature);
	bidRequest.app.content.embeddable = @NO;
	bidRequest.app.content.language = @"ru";
	bidRequest.app.publisher.name = @"Бесогон ТВ";
	bidRequest.app.publisher.categories = @[@"IAB25-2", @"IAB25-3"];
	bidRequest.app.publisher.domain = @"tv.besogon";
	bidRequest.app.publisher.ext = @{@"some_key": @"some_value"};
	bidRequest.app.name = @"ADC TEST";
	bidRequest.app.domain = @"com.sebbia.vi";
	bidRequest.app.categories = @[@"IAB25-3"];
	bidRequest.app.sectionCategories = @[@"IAB25-3"];
	bidRequest.app.pageCategories = @[@"IAB25-3"];
	bidRequest.app.privacyPolicy = @NO;
	bidRequest.app.paid = @NO;
	bidRequest.app.keywords = @"video, international, vast, openrtb";
	[bannerView startWithRequest:adRequest];
}

- (void)adjustBanner {
	bannerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{
		[self adjustBanner];
	}];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updateBanner];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

@end
