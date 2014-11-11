//
//  InterstitialRequestViewController.m
//  adcampsample
//
//  Created by Михаил Любимов on 04.07.14.
//  Copyright (c) 2014 Sebbia. All rights reserved.
//

#import "InterstitialRequestViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface InterstitialRequestViewController ()

@end

@implementation InterstitialRequestViewController {
    ADCRequest *request;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    request = [ADCRequest fullscreenBannerRequestWithPlacementID:@"393058cf-ea48-4ccb-8a05-d4fca4022f25"];
    [request runAsInterstitialFromRootViewController:self];
}

- (void)dealloc {
    [request cancel];
}

@end
