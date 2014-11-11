//
//  ADCVideoView.h
//  adcampsdk
//
//  Created by Mikhail on 12.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "ADCEmbeddedPlayer.h"

@class ADCRequest;
@interface ADCVideoView : ADCEmbeddedPlayer

/**
 Должен ли быть показан индикатор предзагрузки видеоролика
 */
@property (nonatomic, assign) BOOL shouldShowPreloadBar;

/**
 Текущий прогресс проигрывания видеоролика (в секундах)
 */
@property (nonatomic, readonly) NSTimeInterval currentPlaybackTime;

/**
 Длительность текущего видеоролика (в секундах) взятая из метаданных самого ролика,
 либо длительность заявленная сервером, если из метаданных её получить не удалось
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 Запускает получение видеорекламы.
 */
- (void)start;

/**
 Запускает получение видеорекламы с указанным объектом запроса.
 @param request запрос видеорекламы
 */
- (void)startWithRequest:(ADCRequest *)request;

/**
 Завершает показ текущей рекламы, если возможность пропуска доступна в этот момент времени
 */
- (void)skipAd;

@end
