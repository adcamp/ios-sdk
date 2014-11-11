//
//  ADCAdvertisingCacheDelegate.h
//  AdCampSDK
//
//  Created by Mikhail on 11.09.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADCAdvertising;

/**
	Набор методов для отслеживания состояния кеширования рекламного объекта
 */
@protocol ADCAdvertisingCacheDelegate <NSObject>


@optional

/**
	Метод вызываемый, когда кеширование рекламы завершилось с ошибкой
	@param ad объект рекламы
 */
- (void)advertisingCachingFailed:(ADCAdvertising *)ad;


/**
	Метод вызываемый, когда кеширование рекламы завершилось успешно
	@param ad объект рекламы
 */
- (void)advertisingCached:(ADCAdvertising *)ad;


/**
	Метод вызываемый при изменении прогресса кеширования рекламы
	@param ad объект рекламы
	@param progress прогресс кеширования рекламы [0.0, 1.0]
 */
- (void)advertising:(ADCAdvertising *)ad progressChanged:(double)progress;


@end
