//
//  ADCPlayerViewController.m
//  adcampsdk
//
//  Created by Mikhail on 24.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "ADCPlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "ADCMoviePlayer.h"

@implementation ADCPlayerViewController {
	UIButton *playButton;
	UIButton *pauseButton;
	UIButton *stopButton;
}

- (void)dealloc {
	[player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}
	
	player = [[ADCMoviePlayer alloc] initWithFrame:CGRectZero];
//	player.translatesAutoresizingMaskIntoConstraints = NO;
	player.contentURL = [NSURL URLWithString:@"http://test.sebbia.com/bbb.mp4"];
	player.delegate = self;
	[self.view addSubview:player];
	
	[self doLayout];
	
	[player addVideoPlayBreakAtPosition:ADCVideoPositionPreRoll];
	[player addVideoPlayBreakAtTimeOffset:30];
	[player addVideoPlayBreakAtPosition:ADCVideoPositionPauseRoll];
	[player addVideoPlayBreakAtPosition:ADCVideoPositionPostRoll];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self doLayout];
}

- (IBAction)stop {
	[player stop];
}

- (IBAction)play {
	[player play];
}

- (IBAction)pause {
	[player pause];
}

- (IBAction)fullscreen {
	[player setFullscreen:!player.isFullscreen animated:YES];
}

- (void)doLayout {
	player.frame = CGRectInset(self.view.bounds, 5, 64);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self doLayout];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)player:(id<ADCPlayer>)player willStartAd:(ADCAdvertising *)ad {
	pauseButton.enabled = NO;
}

- (void)player:(id<ADCPlayer>)player didFinishAd:(ADCAdvertising *)ad {
	pauseButton.enabled = YES;
}

@end
