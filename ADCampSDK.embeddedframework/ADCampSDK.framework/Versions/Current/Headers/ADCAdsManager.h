//
//  ADCAdsManager.h
//  adcampsdk
//
//  Created by Mikhail on 07.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "OpenRTBBidRequest.h"

@class ADCSkin;

extern NSString *const ADCCredentialLocation;

/**
	Менеджер конфигурации ADCSDK
 */
@interface ADCAdsManager : NSObject

/**
	Текущий стиль оформления по умолчанию для всех создаваемых плееров видеорекламы и баннеров.
	Может быть изменён у каждого конкретного плеера.
 */
@property (nonatomic, strong) ADCSkin *currentSkin;

/**
	Application Id полученный при регистрации приложения в AdCamp
 */
@property (nonatomic, strong) NSString *appId;

/**
	Application Secret полученный при регистрации приложения в AdCamp
 */
@property (nonatomic, strong) NSString *appSecret;

/**
 Доступно ли SDK получение местоположения устройства через CoreLocation.framework
 По умолчанию YES
 */
@property (nonatomic, assign, getter = isLocationEnabled) BOOL locationEnabled;


/**
 При первом вызове создает объект менеджера с учётом выданных разрешений

 @notes
 В данный момент поддерживается только разрешение на доступ к геолокации
 Для этого необходимо поставить значения @YES(разрещено) либо @NO(запрещено) для ключа ADCCredentialLocation
 По-умолчанию доступ к геолокации разрешён
 
 @returns возвращает синглтон-объект менеджера
 */
+ (ADCAdsManager *)sharedManagerWithCredentials:(NSDictionary *)credentials;


/**
	При первом вызове создает объект менеджера
	@returns возвращает синглтон-объект менеджера
 */
+ (ADCAdsManager *)sharedManager;


/**
	@returns URL для запросов рекламы
 */
- (NSURL *)requestURL;

/**
	Возвращает включено ли логирование SDK в данный момент
	@returns YES если логирование включено (на любом уровне)
 */
- (BOOL)isLoggingEnabled;

/**
	@returns Последнее известное положение устройства
 */
- (CLLocation *)lastDeviceLocation;

/**
	@returns уникальный идентификатор устройства
 */
- (NSString *)advertisingID;

/**
	@returns Текущий тип соединения с интернетом
 */
- (OpenRTBConnectionType)deviceConnectionType;

/**
	Возвращает номер версии SDK
	@returns строка содержащая номер версии
 */
- (NSString *)version;


@end
