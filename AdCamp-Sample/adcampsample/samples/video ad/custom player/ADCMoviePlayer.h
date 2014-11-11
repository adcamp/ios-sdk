//
//  ADCPlayer.h
//  adcampsdk
//
//  Created by Mikhail on 24.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import <ADCampSDK/ADCampSDK.h>

@interface ADCMoviePlayer : UIView <MPMediaPlayback>

@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) ADCRequest *adRequest;
@property (nonatomic, strong) NSURL *contentURL;
@property (nonatomic, weak) id<ADCPlayerDelegate> delegate;
@property (nonatomic, readonly) BOOL isFullscreen;

- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated;

- (void)addVideoPlayBreakAtPosition:(ADCVideoPosition)position;
- (void)addVideoPlayBreakAtTimeOffset:(int)timeOffset;

@property (nonatomic, assign) BOOL shouldShowPreloadBar;

@end
