//
//  SampleViewController.h
//  ADCSample
//
//  Created by Mikhail on 03.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

#import <ADCampSDK/ADCampSDK.h>

@interface SampleViewController : UIViewController

@property (nonatomic, strong) ADCVideoPlayer *player;

- (id)initWithSampleNumber:(int)sn;

@end
