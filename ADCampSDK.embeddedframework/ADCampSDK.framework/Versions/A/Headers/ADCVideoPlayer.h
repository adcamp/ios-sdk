//
//  ADCVideoPlayer.h
//  adcampsample
//
//  Created by Mikhail on 11.09.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ADCRequest.h"
#import "ADCRequestDelegate.h"
#import "ADCPlayerDelegate.h"

/**
	Видеоплеер с поддержкой рекламы
 */
@interface ADCVideoPlayer : UIView
 <ADCRequestDelegate, ADCPlayerDelegate, MPMediaPlayback>

/**
	Длительность основного контента
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
	URL для контента
 */
@property (nonatomic, strong) NSURL *contentURL;

/**
	Включен ли полноэкранный режим в данный момент
 */
@property (nonatomic, readonly) BOOL isFullscreen;

@property (nonatomic, assign) BOOL shouldShowPreloadBar;

/**
	Удаляет всю запланированную рекламу из рекламного запроса
 */
- (void)resetPlaybreaks;

/**
	Добавляет в рекламный запрос новое рекламное место. См. ADCVideoPosition
	@param position позиция рекламного места
 */
- (void)addVideoPlayBreakAtPosition:(ADCVideoPosition)position;

/**
	Добавляет в рекламный запрос новое рекламное место после указанной секунды основного контента
	@param timeOffset время в секундах после которого добавить рекламное место
 */
- (void)addVideoPlayBreakAtTimeOffset:(int)timeOffset;


@end
