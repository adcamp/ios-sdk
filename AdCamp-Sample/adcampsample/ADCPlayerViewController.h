//
//  ADCPlayerViewController.h
//  adcampsdk
//
//  Created by Mikhail on 24.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ADCampSDK/ADCampSDK.h>

@class ADCMoviePlayer;
@interface ADCPlayerViewController : UIViewController <ADCPlayerDelegate> {
	IBOutlet ADCMoviePlayer *player;
}

- (IBAction)play;
- (IBAction)pause;
- (IBAction)stop;

@end
