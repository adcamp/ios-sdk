//
//  FullscreenVideoViewController.m
//  adcampsample
//
//  Created by Михаил Любимов on 07.07.14.
//  Copyright (c) 2014 Sebbia. All rights reserved.
//

#import "FullscreenVideoViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface FullscreenVideoViewController ()

@end

@implementation FullscreenVideoViewController {
    ADCRequest *request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    request = [ADCRequest fullscreenVideoRequestWithPlacementID:@"afed2b33-c3c0-46f2-bf34-ecf420b9a0b9"];
    [request runAsInterstitialFromRootViewController:self];
}

- (void)dealloc {
    [request cancel];
}
@end
