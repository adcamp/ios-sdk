//
//  ADCPlayerDelegate.h
//  adcampsdk
//
//  Created by Mikhail on 03.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Коды ошибок возвращаемых сдк
 */
typedef NS_ENUM(NSInteger, ADCErrorCode) {
    /**
     *  Неправильный запрос
     */
    ADCErrorInvalidRequest,
    /**
     *  Запрос рекламы прошёл успешно, но сервер не отдал рекламы
     */
    ADCErrorNoFill,
    /**
     *  Ошибка соединения. Например: отсутствует интернет соединение
     */
    ADCErrorNetworkError,
    /**
     *  Ошибка сервера
     */
    ADCErrorServerError,
    /**
     *  Ошибка сервера
     */
    ADCErrorDisplayError,
    /**
     *  Таймаут загрузки рекламы
     */
    ADCErrorTimeout,
    /**
     *  Указан неверный размер рекламы
     */
    ADCErrorInvalidAdSize
};

@protocol ADCPlayer;

@class ADCAdvertising;

/**
	Список методов вызываемых плеером
 */
@protocol ADCPlayerDelegate <NSObject>

@optional
/**
	Метод вызываемый перед началом показа рекламы
	В момент вызова следует остановить проигрывание основного плеера
	@param player плеер
	@param ad объект рекламы
 */
- (void)player:(id <ADCPlayer>)player willStartAd:(ADCAdvertising *)ad;

/**
	Метод вызываемый после окончания проигрывания рекламы
	В момент вызова следует продолжить воспроизведение основного плеера
	@param player плеер
	@param ad объект рекламы
 */
- (void)player:(id <ADCPlayer>)player didFinishAd:(ADCAdvertising *)ad;

/**
 Метод вызываемый в случае ошибки при загрузке или отображении рекламы
 @param player плеер
 @param ad объект рекламы
 */
- (void)player:(id <ADCPlayer>)player didFailToPlayAd:(ADCAdvertising *)ad withError:(NSError *)error;


/**
	Опциональный метод вызываемый при смене полноэкранного режима
	@param player плеер
	@param fullscreen YES если происходит выход в полноэкранный режим и NO иначе
 */
- (void)player:(id <ADCPlayer>)player wantsFullscreen:(BOOL)fullscreen;

/**
	Опциональный метод вызываемый при клике на рекламу с последующим выходом из приложения
	@param player плеер
 */
- (void)playerWillLeaveApplication:(id <ADCPlayer>)player;

/**
	Опциональный метод вызываемый при возврате в приложение из фона
	@param player плеер
 */
- (void)playerWillReturnToApplication:(id <ADCPlayer>)player;

/**
 
    Опциональный метод вызываемый при необходимости указать настройки ориентации экрана
    Актуально для полноэкранной рекламы
    @param player плеер
    @param orientationSettings настройки. Доступны по ключам kAllowOrientationChange, kForceOrientation
 
 */
- (void)player:(id<ADCPlayer>)player didReceiveOrientationSettings:(NSDictionary *)orientationSettings;

- (void)player:(id<ADCPlayer>)player shouldUseCustomClose:(BOOL)useCustomClose;

@end
