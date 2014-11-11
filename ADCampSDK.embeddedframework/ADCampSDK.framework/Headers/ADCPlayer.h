//
//  ADCPlayer.h
//  adcampsdk
//
//  Created by Mikhail on 03.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADCPlayerDelegate.h"

@class ADCAdvertising;

/**
	Базовый интерфейс для объектов проигрывающих рекламу
 */
@protocol ADCPlayer <NSObject>

@required
/**
	Делегат, который будет получать коллбэки для всех событий плеера
 */
@property (nonatomic, weak) NSObject <ADCPlayerDelegate>*delegate;


/**
	Проигрывает рекламный объект полученный в VAST документе
	@param ad рекламный объект описываемый в VAST документе тегом \<Ad\>
 */
- (void)playAd:(ADCAdvertising *)ad;

@optional
/**
	Проигрывает рекламный объект полученный в VAST документе
	@param ad ad рекламный объект описываемый в VAST документе тегом \<Ad\>
	@param cacheRate процент предзагрузки видеоролика перед проигрыванием
 */
- (void)playAd:(ADCAdvertising *)ad preloadRate:(float)cacheRate;

/**
 Останавливает проигрывание рекламы
 */
- (void)stop;

@end
