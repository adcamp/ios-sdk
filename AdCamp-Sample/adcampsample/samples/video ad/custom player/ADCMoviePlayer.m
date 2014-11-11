//
//  ADCPlayer.m
//  adcampsdk
//
//  Created by Mikhail on 24.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "ADCMoviePlayer.h"

#import <AVFoundation/AVFoundation.h>
#import "UIScreen+Orientation.h"

typedef NS_ENUM(NSInteger, ADCPlayerInternalState) {
	stop,
	adrequest,
	adready,
	adplay,
	contentplay,
	contentpause
};

typedef NS_ENUM(NSInteger, ADCPlayerControlState) {
	control_stop,
	control_play,
	control_pause,
	control_prepare_to_play
};

@interface ADCMoviePlayer () <ADCPlayerDelegate, ADCRequestDelegate> {
	UIView *_playerView;
	AVPlayerLayer *_playerLayer;
	__strong id _timeObserver;
	ADCPlayerInternalState state;
	ADCPlayerControlState controlState;
	BOOL paused;
	BOOL _isFullscreen;
	CGRect _originalFrame;
	int _parentIndex;
	UIView *_parent;
	UIButton *_fullscreenButton;
	
	ADCVideoView *_adPlayer;
	ADCRequest *_adRequest;
	ADCAdvertising *_preroll;
	ADCAdvertising *_pauseroll;
	ADCAdvertising *_postroll;
	NSArray *playbreaks;
}

@end

@implementation ADCMoviePlayer {
	BOOL _playbackPaused;
	BOOL _playingAd;
	BOOL _observeBackground;
}

- (void)setup {
	state = stop;
	controlState = control_stop;
	
	_adRequest = [ADCRequest defaultRequest];
	_adRequest.delegate = self;
	_playerView = [[UIView alloc] initWithFrame:self.bounds];
	_playerView.backgroundColor = [UIColor blackColor];
	[self addSubview:_playerView];
	_adPlayer = [[ADCVideoView alloc] initWithFrame:self.bounds];
	[_adPlayer setDelegate:self];
	[self addSubview:_adPlayer];
	
	_fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_fullscreenButton addTarget:self action:@selector(shrink) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_fullscreenButton];
	[self updateFullscreen];
	
	if (!_observeBackground) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didEnterBackground)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(willEnterForeground)
													 name:UIApplicationWillEnterForegroundNotification
												   object:nil];
		_observeBackground = YES;
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (void)_setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	_playerView.frame = self.bounds;
	_playerLayer.frame = self.bounds;
	_adPlayer.frame = self.bounds;
	_fullscreenButton.frame = CGRectMake(self.bounds.size.width - 44, 0, 44, 44);
}

- (void)setFrame:(CGRect)frame {
	if (_isFullscreen) {
		_originalFrame = frame;
	} else {
		[self _setFrame:frame];
	}
}

- (void)dealloc {
	[self _stop];
}

- (ADCRequest *)adRequest {
	return _adRequest;
}

- (void)addVideoPlayBreakAtPosition:(ADCVideoPosition)position {
	[_adRequest addVideoImpressionForPlayer:_adPlayer atPosition:position];
}

- (void)addVideoPlayBreakAtTimeOffset:(int)timeOffset {
	[_adRequest addVideoImpressionForPlayer:_adPlayer atTimeOffset:timeOffset];
}

- (void)setShouldShowPreloadBar:(BOOL)shouldShowPreloadBar {
	[_adPlayer setShouldShowPreloadBar:shouldShowPreloadBar];
}

- (BOOL)shouldShowPreloadBar {
	return _adPlayer.shouldShowPreloadBar;
}

#pragma mark - fullscreen

- (void)statusBarDidChangeOrientation:(NSNotification *)n {
//	NSLog(@"%@", n.userInfo);
	[self flipViewToOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)saveParentInfo {
	_originalFrame = self.frame;
	_parent = self.superview;
	_parentIndex = (int)[[self.superview subviews] indexOfObject:self];
}

- (void)updateFullscreen {
	if (_isFullscreen) {
		[_fullscreenButton setImage:[UIImage imageNamed:@"fullscreen_off.png"] forState:UIControlStateNormal];
	} else {
		[_fullscreenButton setImage:[UIImage imageNamed:@"fullscreen_on.png"] forState:UIControlStateNormal];
	}
}

- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated {
	if (_isFullscreen == fullscreen)
		return;
	_isFullscreen = fullscreen;
	[self updateFullscreen];
	
	void(^layoutBlock)(void) = ^{
		if (_isFullscreen) {
			[self saveParentInfo];
			UIView *window = (UIView *)[[[UIApplication sharedApplication] windows] objectAtIndex:0];
			[self removeFromSuperview];
			[window addSubview:self];
			[self flipViewToOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
			
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(statusBarDidChangeOrientation:)
														 name:UIApplicationDidChangeStatusBarOrientationNotification
													   object:nil];
		} else {
			self.transform = CGAffineTransformIdentity;
			[self _setFrame:_originalFrame];
			[self removeFromSuperview];
			[_parent insertSubview:self atIndex:_parentIndex];
			[[NSNotificationCenter defaultCenter] removeObserver:self
															name:UIApplicationDidChangeStatusBarOrientationNotification
														  object:nil];
		}
	};
    layoutBlock();
}

- (void)shrink {
	[self setFullscreen:!_isFullscreen animated:YES];
}

- (BOOL)isFullscreen {
	return _isFullscreen;
}

- (void)flipViewToOrientation:(UIInterfaceOrientation)orientation {
	CGFloat statusBar = MIN([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width);
	CGRect bounds = [UIScreen mainScreen].bounds;
	int shift = (bounds.size.height - bounds.size.width - statusBar) / 2;
	self.transform = CGAffineTransformIdentity;
	self.center = CGPointMake(0, 0);
    CGFloat angle = 0.0;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI / 2.0f;
			bounds = CGRectMake(-shift, shift, bounds.size.height, bounds.size.width);
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI / 2.0f;
			bounds = CGRectMake(-shift, shift, bounds.size.height, bounds.size.width);
            break;
		case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        default: // as UIInterfaceOrientationPortrait
            angle = 0.0;
            break;
    }
	bounds.origin.y += statusBar;
	bounds.size.height -= statusBar;
	CGAffineTransform t = CGAffineTransformMakeRotation(angle);
	[self _setFrame:bounds];
	self.transform = t;
}

#pragma mark - MPMediaPlayback

- (BOOL)isPreparedToPlay {
	BOOL adIsPrepared = (state != stop) && (state != adrequest);
	return adIsPrepared;
}

- (NSTimeInterval)currentPlaybackTime {
	return CMTimeGetSeconds(_playerLayer.player.currentTime);
}

- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime {
	if (state == contentplay || state == contentpause) {
		[_playerLayer.player seekToTime:CMTimeMake(currentPlaybackTime, 1)];
	}
}

- (float)currentPlaybackRate {
	return _playerLayer.player.rate;
}

- (void)setCurrentPlaybackRate:(float)currentPlaybackRate {
	if (state == contentplay || state == contentpause) {
		[_playerLayer.player setRate:currentPlaybackRate];
	}
}

- (void)prepareToPlay {
	controlState = control_prepare_to_play;
	
	[self _prepareToPlay];
}

- (void)play {
	controlState = control_play;
	
	switch (state) {
		case stop:
			[self _prepareToPlay];
			break;
		case adrequest:
			//
			break;
		case adready:
			[self _play];
			break;
		case adplay:
		case contentplay:
			//
			break;
		case contentpause:
			[self _resume];
			break;
		default:
			break;
	}
}

- (void)pause {
	controlState = control_pause;
	
	[self _pause];
}

- (void)stop {
	controlState = control_stop;
	
	[self _stop];
}

- (void)beginSeekingForward {
	ADCLogW(@"not implemented");
};

- (void)beginSeekingBackward {
	ADCLogW(@"not implemented");
};

- (void)endSeeking {
	ADCLogW(@"not implemented");
};

- (NSTimeInterval)duration {
	CMTime d = [_playerLayer.player currentItem].duration;
	NSTimeInterval t = CMTimeGetSeconds(d);
	return t;
}

#pragma mark -

- (void)_prepareToPlay {
	state = adrequest;
	_adRequest.delegate = self;
	[_adRequest run];
}

- (void)_play {
	AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.contentURL];
	[item addObserver:self forKeyPath:@"status" options:0 context:nil];
	[item addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:nil];
	AVPlayer *avplayer = [[AVPlayer alloc] initWithPlayerItem:item];
	[avplayer addObserver:self forKeyPath:@"rate" options:0 context:nil];
	_timeObserver = nil;
	_playerLayer = [AVPlayerLayer playerLayerWithPlayer:avplayer];
	[_playerView.layer addSublayer:_playerLayer];
	[_playerLayer addObserver:self
					 forKeyPath:@"readyForDisplay"
						options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew)
						context:NULL];
	_playerLayer.frame = self.bounds;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(itemDidFinishPlaying:)
												 name:AVPlayerItemDidPlayToEndTimeNotification
											   object:item];
	switch (state) {
        case adready:
		case contentpause:
		case stop:
			[_playerLayer.player play];
			break;
		default:
			break;
	}
}

- (void)_stop {
	if (_playingAd) {
		[_adPlayer stop];
	}
	
	[_adRequest cancel];
	
	[[_playerLayer.player currentItem] removeObserver:self forKeyPath:@"status"];
	[[_playerLayer.player currentItem] removeObserver:self forKeyPath:@"playbackBufferEmpty"];
	
	[_playerLayer.player removeObserver:self forKeyPath:@"rate"];
	[_playerLayer.player pause];
	if (_timeObserver) {
		[_playerLayer.player removeTimeObserver:_timeObserver];
	}
	_playerLayer.player = nil;
	_timeObserver = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:AVPlayerItemDidPlayToEndTimeNotification
												  object:nil];
	[_playerLayer removeObserver:self forKeyPath:@"readyForDisplay"];
	[_playerLayer removeFromSuperlayer];
	_playerLayer = nil;
	
	state = stop;
}

- (void)_pause {
	state = contentpause;
	[_playerLayer.player pause];
}

- (void)_resume {
	if (_playerLayer) {
		[_playerLayer.player play];
	} else {
		[self _play];
	}
}

- (void)precacheNextAd {
	ADCAdvertising *nextAd = nil;
	NSTimeInterval timeToNextAd = HUGE_VALF;
	NSTimeInterval currentTime = CMTimeGetSeconds(_playerLayer.player.currentTime);
	for (ADCAdvertising *eachAd in playbreaks) {
		NSTimeInterval diff = eachAd.startOffset - currentTime;
		if ((0 < diff) && (diff < timeToNextAd)) {
			timeToNextAd = diff;
			nextAd = eachAd;
		}
	}
	if (nextAd) {
		ADCLogD(@"trying to cache next ad in %.2f seconds", timeToNextAd);
		[nextAd preload];
	}
}

- (void)didEnterBackground {
	switch (state) {
		case adrequest:
			[_adRequest cancel];
			state = stop;
			break;
		case contentplay:
			[_playerLayer.player pause];
			break;
		default:
			break;
	}
}

- (void)willEnterForeground {
	switch (state) {
		case contentplay:
			[_playerLayer.player play];
			break;
		default:
			break;
	}
}

#pragma mark - ADCRequestDelegate

- (void)request:(ADCRequest *)request didReceivePreroll:(ADCAdvertising *)ad {
	_preroll = ad;
	if (controlState == control_play) {
		[_adPlayer playAd:_preroll preloadRate:0.5f];
	}
}

- (void)request:(ADCRequest *)request didReceivePauseroll:(ADCAdvertising *)ad {
	_pauseroll = ad;
}

- (void)request:(ADCRequest *)request didReceivePostroll:(ADCAdvertising *)ad {
	_postroll = ad;
}

- (void)request:(ADCRequest *)request didReceivePlaybreaks:(NSArray *)breaks {
	playbreaks = breaks;
	
	NSMutableArray *times = [NSMutableArray array];
	ADCLogD(@"schedule playbreaks at:");
	for (ADCAdvertising *eachAd in playbreaks) {
		ADCLogD(@"%.f sec.", [eachAd startOffset]);
		CMTime timeOffset = CMTimeMake((int)[eachAd startOffset], 1);
		[times addObject:[NSValue valueWithCMTime:timeOffset]];
	}
	__weak AVPlayer *weak_player = _playerLayer.player;
	__weak ADCVideoView *weak_adplayer = _adPlayer;
	_timeObserver = [_playerLayer.player addBoundaryTimeObserverForTimes:times
																	   queue:NULL
																  usingBlock:
					 ^{
						 NSTimeInterval elapsed = CMTimeGetSeconds(weak_player.currentTime);
						 ADCLogD(@"player observer fire at %f", elapsed);
						 for (ADCAdvertising *eachAd in breaks) {
							 if (elapsed - eachAd.startOffset < 1) {
								 [weak_adplayer playAd:eachAd];
								 break;
							 }
						 }
					 }];
}

- (void)request:(ADCRequest *)request didFailWithError:(NSError *)error {
	
}

- (void)request:(ADCRequest *)request didReceiveError:(NSError *)error forWrapper:(ADCWrapperAd *)wrapperAd {
	
}

- (void)requestDidFinishLoading:(ADCRequest *)request {
	state = adready;
	switch (controlState) {
		case control_play:
			[self _play];
			break;
		default:
			break;
	}
}

#pragma mark - ADCPlayerDelegate

- (void)player:(id <ADCPlayer>)player willStartAd:(ADCAdvertising *)ad {
	ADCLogD(@"main player will start ad");
	state = adplay;
	_playingAd = YES;
	[self _pause];
	if (self.delegate) {
		[self.delegate player:player willStartAd:ad];
	}
}

- (void)player:(id <ADCPlayer>)player didFinishAd:(ADCAdvertising *)ad {
	ADCLogD(@"main player did finish ad");
	switch (controlState) {
		case control_play:
		{
			state = contentplay;
			[self _resume];
		}
			break;
		default:
			break;
	}
	if (ad == _preroll) {
		[_pauseroll preload];
	} else {
		[self precacheNextAd];
	}
	if (self.delegate) {
		[self.delegate player:player didFinishAd:ad];
	}
}

#pragma mark - Content Player

- (void)itemDidFinishPlaying:(NSNotification *)n {
	if (_postroll) {
		[_adPlayer playAd:_postroll];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	ADCLogD(@"player playback did finish");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if ([keyPath isEqualToString:@"status"]) {
            switch (item.status) {
                case AVPlayerItemStatusFailed:
                    ADCLogD(@"content status failed: %@", _playerLayer.player.error);
					break;
                case AVPlayerItemStatusReadyToPlay:
                    ADCLogD(@"content status is ready to play");
					break;
                case AVPlayerItemStatusUnknown:
                    ADCLogD(@"content status is unknown");
					break;
            }
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            if (item.playbackBufferEmpty) {
                ADCLogD(@"content playback buffer is empty");
			}
        }
    } else if ([object isKindOfClass:[AVPlayerLayer class]]) {
		if ([keyPath isEqualToString:@"readyForDisplay"]) {
			ADCLogD(@"content ready for display");
		}
	} else if ([object isKindOfClass:[AVPlayer class]]) {
		if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
			if ([keyPath isEqualToString:@"rate"]) {
				if ([_playerLayer.player rate] > 0.f) {
					// playing
					if (_playingAd) {
						//
					} else if (_playbackPaused && _pauseroll) {
						[_adPlayer performSelector:@selector(playAd:) withObject:_pauseroll afterDelay:0.1f];
					}
					_playingAd = NO;
					_playbackPaused = NO;
				} else {
					// paused
					_playbackPaused = YES;
				}
			}
		}
	}
}

@end
