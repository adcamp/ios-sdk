//
//  AdMoviePlayerViewController.h
//  aikino
//
//  Created by Vladimir on 10.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import <ADCampSDK/ADCampSDK.h>

@interface AdMoviePlayerViewController : MPMoviePlayerViewController <ADCPlayerDelegate, ADCRequestDelegate>

@property (nonatomic, strong) ADCVideoView* adplayer;
@property (nonatomic, strong) ADCRequest *adRequest;

@end

