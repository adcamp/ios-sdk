//
//  ADCEmbeddedPlayer.h
//  adcampsdk
//
//  Created by Mikhail on 03.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADCPlayer.h"
#import "ADCSkin.h"
#import "ADCSkipButtonProtocol.h"

/**
 *  Домен ошибок IvengoSDk
 */
extern NSString *const kADCErrorDomain;

@class TouchTransparentView;
@class ADCAdvertising;

/**
 * Базовый класс плеера рекламных объектов.
 * Содержит элементы HUD
 */

@interface ADCEmbeddedPlayer : UIView <ADCPlayer> {
@protected
	UIView *_playerView;
	TouchTransparentView *_overlayView;
	UIButton *_clickThroughtButton;
	UIActivityIndicatorView *_activityView;
	UILabel *_adLabel;
    __weak id <ADCSkipButtonProtocol>_skipButton;
	UIButton <ADCSkipButtonProtocol>*_defaultSkipButton;
	UIView *_whiteBar;
	UIView *_yellowBar;
	UIView *_preloadBar;
	ADCSkin *_skin;
	BOOL _isLoading;
}

/**
	Текущий рекламный объект, который проигрывается плеером
 */
@property (nonatomic, strong, readonly) ADCAdvertising *currentAd;

/**
    Идентификатор размещения рекламы (Placement ID), который будет указан в запросе на получение рекламы
 */
@property (nonatomic, strong) NSString *placementID;

/**
    Устанавливает/возвращает возможно ли использование графики предоставляемой сдк поверх рекламного контента.
    Установите это свойство в NO, если используете собственную кнопку пропуска рекламы и/или индикаторы длительности.
 */
@property (nonatomic, readwrite) BOOL allowAdOverlay;

/**
    Текущая кнопка пропуска рекламы. Получает сообщение о времени оставшемся до возможности пропуска.
    Установка значения этого свойства в nil ведёт к использованию стандартной кнопки пропуска рекламы.
*/
@property (nonatomic, weak) id <ADCSkipButtonProtocol>skipButton;

/**
	Устанавливает новый стиль оформления плеера
	@param newSkin новый объект стиля
 */
- (void)setSkin:(ADCSkin *)newSkin;

/**
    Добавляет дополнительный параметр к рекламному запросу для текущего места рекламы
    Если по указанному ключу ранее уже было высталено значение, оно заменяется
    @param value строковое значение дополнительного параметра
    @param key название дополнительного параметра
 */
- (void)addExtValue:(NSString *)value forKey:(NSString *)key;

- (void)finalize;

@end
