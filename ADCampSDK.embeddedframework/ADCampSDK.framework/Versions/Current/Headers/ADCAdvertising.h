//
//  ADCAdvertising.h
//  adcampsdk
//
//  Created by Mikhail on 13.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "ADCAdvertisingCacheDelegate.h"

typedef NS_ENUM(NSInteger, ADCAdvertisingType) {
    ADCAdTypeVideo	= 1,
    ADCAdTypeBanner	= 2
};

@class VASTAd;
@class OpenRTBImpression;
@class ADCEmbeddedPlayer;
@class VASTURLMod;
/**
	Класс рекламного объекта (баннер, видео) безотносительно к способу его получения (VAST,
	ручная сборка).
 */
@interface ADCAdvertising : NSObject {
	@protected
	OpenRTBImpression *impression;
	NSString *_placementID;// идентификатор view в котором реклама отображается
}

//#warning strong delegate property
@property (nonatomic, strong) NSObject <ADCAdvertisingCacheDelegate>*delegate;

@property (nonatomic, readonly) OpenRTBImpression *impression;
@property (nonatomic, readonly) ADCAdvertisingType type;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) NSURL *contentURL;
@property (nonatomic, readwrite) CGSize desiredSize;
@property (nonatomic, readwrite) int desiredDensity;
@property (nonatomic, readwrite) BOOL upscale;
@property (nonatomic, readwrite) NSTimeInterval duration;
@property (nonatomic, readwrite) int skipOffset;
@property (nonatomic, readonly) float currentPreloadRate;
@property (nonatomic, readonly) VASTURLMod *urlmod;
/**
	Возвращает пустой объект рекламы
	@returns возвращает пустой объект
 */
+ (ADCAdvertising *)advertising;
+ (ADCAdvertising *)bannerAdvertising;
+ (ADCAdvertising *)videoAdvertising;


// request
- (NSString *)impressionID;


// caching
/**
	Инициирует процесс кеширования рекламы, если он ещё не начат
 */
- (void)preload;

/**
	Останаливает процесс загрузки рекламы и удаляет уже загруженные данные
 */
- (void)cancelCaching;

/**
	Кешируется ли реклама в данный момент
	@returns YES если идет загрузка, NO если загрузка не была начата либо завершилась
 */
- (BOOL)isCachingNow;


/**
	Возвращает закеширована ли текущая реклама
	@returns YES если реклама полностью закеширована
 */
- (BOOL)isCached;


// miscellaneous
/**
	Возвращает время через которое реклама может быть закрыта. 0 - означает возможность закрыть сразу
	Отрицательные значения, если прекратить показ нельзя.
	@returns время в секундах
 */
- (int)skipOffset;

/**
	@returns YES если рекламный объект - pre-roll реклама
 */
- (BOOL)isPreRoll;

/**
	@returns YES если рекламный объект - middle-roll
 */
- (BOOL)isMiddleRoll;

/**
 @returns YES если рекламный объект - pause-roll
 */
- (BOOL)isPauseRoll;

/**
 @returns YES если рекламный объект - post-roll
 */
- (BOOL)isPostRoll;

/**
	@returns YES если рекламный объект - баннер
 */
- (BOOL)isBanner;

/**
 @returns YES если рекламный объект - видеоролик
 */
- (BOOL)isVideo;

/**
	@returns временной интервал задержки показа рекламы
 */
- (NSTimeInterval)startOffset;

/**
	Возвращает URL на рекламу. Источником может быть прямая ссылка, либо дисковый кеш, либо
	загружаемый в данный момент файл.
	@returns URL на контент рекламы
 */
- (NSURL *)playURL;

/**
	Отображает рекламный объект на весь экран
	@param rootViewController view controller с которого показать рекламу
 */
- (void)presentAsInterstitialFromRootViewController:(UIViewController *)rootViewController;

/**
	Возвращает содержит ли этот рекламный объект контент полученный с сервера
	@returns YES если контент есть
 */
- (BOOL)haveContent;


@end
