//
//  ADCSkipButtonProtocol.h
//  AdCampSDK
//
//  Created by Михаил Любимов on 29.04.14.
//  Copyright (c) 2014 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADCEmbeddedPlayer;
@protocol ADCSkipButtonProtocol <NSObject>

- (void)adPlayer:(ADCEmbeddedPlayer *)player canSkipAfter:(NSTimeInterval)seconds;

@end
