//
//  ADCMixedAdView.h
//  AdCampSDK
//
//  Created by Mikhail on 10.10.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "ADCEmbeddedPlayer.h"
#import "ADCAdvertising.h"

@class ADCRequest;
@interface ADCMixedAdView : ADCEmbeddedPlayer

/**
	Предпочитаемый тип рекламы в случае получения рекламы обоих типов
 */
@property (nonatomic, assign) ADCAdvertisingType preferredAdType;

/**
	Должен ли показываться баннер после проигрывания видео (в случае наличия)
 */
@property (nonatomic, assign) BOOL shouldShowBannerAfterVideo;


/**
 Запускает показ баннера.
 */
- (void)start;

/**
 Запускает показ рекламы с указанным объектом запроса.
 @param request запрос баннера
 */
- (void)startWithRequest:(ADCRequest *)request;

@end
