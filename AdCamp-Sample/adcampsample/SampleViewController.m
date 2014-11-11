//
//  SampleViewController.m
//  ADCSample
//
//  Created by Mikhail on 03.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "SampleViewController.h"

#import <CoreMedia/CoreMedia.h>

#import <ADCampSDK/ADCampSDK.h>

@interface SampleViewController ()

@end

@implementation SampleViewController {
	__strong id _timeObserver;
	int _sampleNumber;
}

- (id)initWithSampleNumber:(int)sn {
	self = [super init];
	if (self) {
		_sampleNumber = sn;
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			self.edgesForExtendedLayout = UIRectEdgeNone;
		}
	}
	return self;
}

- (void)dealloc {
	[_player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.player = [[ADCVideoPlayer alloc] initWithFrame:CGRectZero];
	self.player.shouldShowPreloadBar = YES;
	[self.view addSubview:self.player];
	
	[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Reset"
																				style:UIBarButtonItemStyleBordered
																			   target:self
																			   action:@selector(resetPressed:)]];
	[self resetPressed:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self adjustLayout];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if (!self.player.isFullscreen) {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[_player stop];
	}
}

- (void)adjustLayout {
	[self.player setFrame:CGRectInset(self.view.bounds, 10, 10)];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{
		[self adjustLayout];
	}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)run {
	[self adjustLayout];
	
	NSURL *contentURL = [NSURL URLWithString:@"http://test.sebbia.com/bbb.mp4"];
	[self.player setContentURL:contentURL];
	
	switch (_sampleNumber) {
		case 0:
			[_player addVideoPlayBreakAtPosition:ADCVideoPositionPreRoll];
			[_player addVideoPlayBreakAtPosition:ADCVideoPositionPauseRoll];
			break;
		case 1:
			[_player addVideoPlayBreakAtPosition:ADCVideoPositionPreRoll];
			[_player addVideoPlayBreakAtPosition:ADCVideoPositionPostRoll];
			break;
		case 2:
			[_player addVideoPlayBreakAtPosition:ADCVideoPositionPreRoll];
			[_player addVideoPlayBreakAtTimeOffset:30];
			[_player addVideoPlayBreakAtPosition:ADCVideoPositionPauseRoll];
			[_player addVideoPlayBreakAtPosition:ADCVideoPositionPostRoll];
			break;
		default:
			break;
	}
	[_player play];
}

- (void)resetPressed:(UIButton *)sender {
	[_player stop];
	[self run];
}

@end
