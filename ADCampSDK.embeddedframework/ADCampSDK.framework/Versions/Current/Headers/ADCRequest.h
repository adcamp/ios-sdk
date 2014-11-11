//
//  ADCRequest.h
//  adcampsdk
//
//  Created by Mikhail on 03.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#import "ADCRequestDelegate.h"


typedef NS_ENUM(NSInteger, ADCVideoPosition) {
	ADCVideoPositionPreRoll = 1,
	ADCVideoPositionPostRoll = 2,
	ADCVideoPositionMidRoll = 3,
	ADCVideoPositionPauseRoll = 4
};

typedef NS_ENUM(NSInteger, ADCUserGender) {
	ADCGenderNotSet	= 0,
	ADCGenderMale	= 1,
	ADCGenderFemale	= 2,
	ADCGenderOther	= 3
};

@class ADCEmbeddedPlayer;
@class ADCAdvertising;
@class OpenRTBBidRequest;
@class OpenRTBImpression;

/**
 Класс объекта формирующего запрос на получение рекламы.
 Позволяет отправку множественных рекламных мест.
 */
@interface ADCRequest : NSObject <NSURLConnectionDelegate>
{
@private
	NSURL *_url;
@protected
	NSMutableArray *_advertisements;
}

@property (nonatomic, readonly) OpenRTBBidRequest *bidRequest;

/**
	Объект-делегат для запроса. Будет получать уведомления об этапах выполнения запроса
 */
@property (nonatomic, weak) NSObject <ADCRequestDelegate>*delegate;

/**
	Завершено ли получение рекламы
 */
@property (nonatomic, readonly) BOOL isInProgress;

/**
	Успешно ли завершён запрос
 */
@property (nonatomic, readonly) BOOL isSuccessful;

/**
	Convenience constructor класса
	@returns возвращает запрос не содержащий объектов impression
 */
+ (ADCRequest *)defaultRequest;

/**
 *  Convenience constructor класса для полноэкранных баннеров
 *
 *  @param placementID идентификатор размещения рекламы
 *
 *  @return возвращает запрос рекламы содержащий описание полноэкранного баннера
 */
+ (ADCRequest *)fullscreenBannerRequestWithPlacementID:(NSString *)placementID;

/**
 *  Convenience constructor класса для полноэкранных видеороликов
 *
 *  @param placementID идентификатор размещения рекламы
 *
 *  @return запрос рекламы содержащий описание полноэкранного видеоролика
 */
+ (ADCRequest *)fullscreenVideoRequestWithPlacementID:(NSString *)placementID;

/**
	Конструктор для прямого запроса документа VAST без bid request'а
	@param url_ URL VAST документа
	@returns возвращает новый объект запроса
 */
- (id)initWithURL:(NSURL *)url_;

/**
	@returns возвращает является ли данный запрос bid request'ом (OpenRTB)
 */
- (BOOL)isBidRequest;

/**
	Запускает исполнение запроса
 */
- (void)run;

/**
	Запускает исполнения запроса и показывает полноэкранный баннер в случае успешного запроса
	@param rootViewController view controller с которого показать рекламу
 */
- (void)runAsInterstitialFromRootViewController:(UIViewController *)rootViewController;


/**
	Отменяет рекламный запрос, а также кеширование всех рекламных объектов, которые уже получены
	Удобно применять при выходе с экрана, на котором планировалось показать рекламу.
 */
- (void)cancel;


#pragma mark construct

/**
	Добавляет в запрос описание рекламы в формате OpenRTB
	@param impression описание рекламного места
	@param context плеер рекламы
 */
- (ADCAdvertising *)addImpression:(OpenRTBImpression *)impression withContext:(id)context;

/**
 Добавляет в запрос описание видеорекламы не привязанной к видеоконтенту
 @param player плеер для рекламы
 */
- (ADCAdvertising *)addVideoImpressionForPlayer:(ADCEmbeddedPlayer *)player;

/**
 Добавляет в запрос описание видеорекламы для указанной позиции в основном контенте
 @param player плеер для рекламы
 @param position позиция рекламы
 */
- (ADCAdvertising *)addVideoImpressionForPlayer:(ADCEmbeddedPlayer *)player atPosition:(ADCVideoPosition)position;

/**
 Добавляет в запрос описание видеорекламы для указанного смещения от начала основного контента
 @param player плеер рекламы
 @param timeOffset смещение рекламы в секундах
 */
- (ADCAdvertising *)addVideoImpressionForPlayer:(ADCEmbeddedPlayer *)player atTimeOffset:(int)timeOffset;

/**
 Добавляет в запрос описание баннерного места
 @param player плеер рекламы (в данном случае баннера)
 */
- (ADCAdvertising *)addBannerImpressionForPlayer:(ADCEmbeddedPlayer *)player;

#pragma mark config

/**
 Явное указание координат устройства
 */
- (void)setDeviceLocation:(CLLocationCoordinate2D)location;

/**
 Устанавливает год рождения пользователя
 @param yob год рождения
 */
- (void)setUserYearOfBirth:(int)yob;


/**
 Устанавливает половую принадлежность пользователя
 @param gender пол пользователя
 */
- (void)setUserGender:(ADCUserGender)gender;


/**
 Устанавливает известные о пользователе геоданные (например указанные им при регистрации)
 @param country Страна
 @param region Область/Штат
 @param city Город
 */
- (void)setUserCountry:(NSString *)country region:(NSString *)region city:(NSString *)city;


/**
 Устанавливает список блокируемых категорий рекламы
 @param categories список категорий
 */
- (void)setBlockedCategories:(NSArray *)categories;

/**
 Устанавливает список блокируемых рекламодателей
 @param advertisers список рекламодателей. Состоит из строк с доменами верхнего уровня
 (Например: company1.com)
 */
- (void)setBlockedAdvertisers:(NSArray *)advertisers;

@end
