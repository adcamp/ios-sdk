//
//  InterstitialRequestViewController.m
//  adcampsample
//
//  Created by Михаил Любимов on 04.07.14.
//  Copyright (c) 2014 Sebbia. All rights reserved.
//

#import "InterstitialRequestViewController.h"

@interface InterstitialRequestViewController ()

@end

@implementation InterstitialRequestViewController
{
    ADCInterstitialViewController *interstitialController_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    interstitialController_ = [[ADCInterstitialViewController alloc] init];
    interstitialController_.placementID = @"7";
    interstitialController_.delegate = self;
    [interstitialController_ start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)interstitialControllerDidReceiveAd:(ADCInterstitialViewController *)interstitial
{
    [interstitial presentFromRootViewController:self];
}

@end
