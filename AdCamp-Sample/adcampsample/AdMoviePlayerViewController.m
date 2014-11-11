//
//  AdMoviePlayerViewController.m
//  aikino
//
//  Created by Vladimir on 10.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "AdMoviePlayerViewController.h"

@interface AdMoviePlayerViewController ()

@property (nonatomic, assign) BOOL playingAd;
@property (nonatomic, strong) ADCAdvertising *pauseRoll;
@property (nonatomic, strong) ADCAdvertising *preRoll;
@property (nonatomic, strong) ADCAdvertising *postRoll;
@property (nonatomic, assign) BOOL playbackPaused;
@property (nonatomic, strong) NSTimer *playbackTimer;
@property (nonatomic, strong) NSMutableArray *playbreaks;

@end

@implementation AdMoviePlayerViewController

@synthesize adplayer, adRequest;

- (id)init {
    self = [super init];
    if (self) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			self.edgesForExtendedLayout = UIRectEdgeNone;
		}
		
        self.adRequest = [ADCRequest defaultRequest];
		[self.adRequest setDelegate:self];
		
		CGRect frame = [UIScreen mainScreen].bounds;
		self.adplayer = [[ADCVideoView alloc] initWithFrame:frame];
		[self.adplayer setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	   
	[self.view addSubview:self.adplayer];
	
	// пытаемся избежать удаления плеера при выходе в фоновый режим
	// http://stackoverflow.com/questions/10122097/mpmovieplayerviewcontroller-exits-after-background
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification object:nil];
	
	// пытаемся избежать удаления плеера после окончания ролика
	// http://stackoverflow.com/questions/13420564/how-to-stop-mpmovieplayerviewcontrollers-automatic-dismiss-on-movieplaybackdidf/13420566#13420566
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playbackStateChanged)
												 name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playbackDidFinish:)
												 name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self flipViewAccordingToStatusBarOrientation];
}

- (void)flipViewAccordingToStatusBarOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	self.adplayer.transform = CGAffineTransformIdentity;
	self.adplayer.center = CGPointMake(0, 0);
    
	CGFloat angle = 0.0;
	CGRect bounds = [UIScreen mainScreen].bounds;	
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            {
                bounds = CGRectMake(0, 0, bounds.size.height, bounds.size.width);
                break;
            }
		case UIInterfaceOrientationPortraitUpsideDown:
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                angle = 0;
            } else {
                angle = M_PI; 
            }
            break;
        default:
            angle = 0.0;
            break;
    }
	CGAffineTransform t = CGAffineTransformMakeRotation(angle);
	self.adplayer.frame = bounds;
	self.adplayer.transform = t;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self flipViewAccordingToStatusBarOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Notifications

- (void) playbackStateChanged {
    if (_playingAd)
        return;
	switch (self.moviePlayer.playbackState) {
		case MPMoviePlaybackStatePaused:
			_playbackPaused = YES;
			break;
		case MPMoviePlaybackStateSeekingBackward:
		case MPMoviePlaybackStateSeekingForward:
			_playbackPaused = NO;
			break;
		case MPMoviePlaybackStatePlaying:
		{
            if (_playingAd) {
				//
			} else if (_playbackPaused && _pauseRoll) {
				[adplayer performSelector:@selector(playAd:) withObject:_pauseRoll afterDelay:0.1f];
			}
			_playingAd = NO;
			_playbackPaused = NO;
			_playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
															  target:self
															selector:@selector(playerTick:)
															userInfo:nil repeats:YES];
		}
			break;
		case MPMoviePlaybackStateStopped:
		{
            [_playbackTimer invalidate];
			_playbackTimer = nil;
		}
			break;
		default:
			break;
	}
}

- (void)playerTick:(NSTimer *)timer {
	NSTimeInterval currentTime = self.moviePlayer.currentPlaybackTime;
	for (ADCAdvertising *eachAd in _playbreaks) {
		if ((eachAd.startOffset < currentTime) && (currentTime <  eachAd.startOffset + 2)) {
			[adplayer playAd:eachAd];
			[_playbreaks removeObject:eachAd];
			break;
		}
	}
}

- (void)playbackDidFinish: (NSNotification*)notification {
    NSNumber *reason = [notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([reason intValue] != MPMovieFinishReasonUserExited) {
        if (_postRoll) {
            [self.adplayer playAd:_postRoll];
        }
    }
}

#pragma mark - ADCPlayerDelegate methods

- (void)player:(id <ADCPlayer>)player willStartAd:(ADCAdvertising *)ad {
	_playingAd = YES;
//    if ([self.moviePlayer isPreparedToPlay])
        [self.moviePlayer pause];
}

- (void)player:(id <ADCPlayer>)player didFinishAd:(ADCAdvertising *)ad {
    if (ad ==_postRoll) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.moviePlayer play];
        
        if (ad == _preRoll) {
            [_pauseRoll preload];
        } else if (ad == _pauseRoll) {
            [_postRoll preload];
        }
    }
    _playingAd = NO;
}

- (void)player:(id<ADCPlayer>)player wantsFullscreen:(BOOL)fullscreen {
	[self.moviePlayer setFullscreen:fullscreen animated:NO];
}

#pragma mark - ADCRequestDelegate methods

- (void)request:(ADCRequest *)request didReceivePreroll:(ADCAdvertising *)preroll {
	_preRoll = preroll;
	[self.adplayer playAd:preroll preloadRate:0.5f];
}

- (void)request:(ADCRequest *)request didReceivePauseroll:(ADCAdvertising *)pauseroll {
	_pauseRoll = pauseroll;
}

- (void)request:(ADCRequest *)request didReceivePostroll:(ADCAdvertising *)postroll {
	_postRoll = postroll;
}

- (void)request:(ADCRequest *)request didReceivePlaybreaks:(NSArray *)breaks {
	_playbreaks = [breaks mutableCopy];
}

- (void)request:(ADCRequest *)request didFailWithError:(NSError *)error {
	
}

- (void)request:(ADCRequest *)request didReceiveError:(NSError *)error forWrapper:(ADCWrapperAd *)wrapperAd {
	
}

- (void)requestDidFinishLoading:(ADCRequest *)request {
	
}

@end
