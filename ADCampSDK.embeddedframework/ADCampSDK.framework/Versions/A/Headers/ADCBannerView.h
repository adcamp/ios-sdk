//
//  ADCBannerView.h
//  adcampsdk
//
//  Created by Mikhail on 10.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "ADCEmbeddedPlayer.h"


typedef NS_ENUM(NSInteger, BannerOnClickBehaviour) {
	BannerOnClickCloseAd = 0, // by default
	BannerOnClickDoNothing,
	BannerOnClickRefresh
};

extern NSString *const kAllowOrientationChange;
extern NSString *const kForceOrientation;


@class ADCRequest;
@interface ADCBannerView : ADCEmbeddedPlayer

@property (nonatomic) BOOL canClose;
@property (nonatomic, readonly) NSTimeInterval adChangeTimeInterval;
@property (nonatomic, assign) BannerOnClickBehaviour onClickBehaviour;

/**
 Запускает показ баннера.
 */
- (void)start;

/**
 Запускает показ баннера с указанным объектом запроса.
 @param request запрос баннера
 */
- (void)startWithRequest:(ADCRequest *)request;

/**
 Запускает показ баннера с указанным временем показа.
 @param seconds время следующего запроса на обновление
 */
- (void)startWithChangeTimeInterval:(NSTimeInterval)seconds;

/**
	Запускает показ баннеров с указанным объектом запроса и временем показа. Размер области баннера 
 обновляется при каждом запросе.
	@param request запрос баннера
	@param seconds время следующего запроса на обновление
 */
- (void)startWithRequest:(ADCRequest *)request changeTimeInterval:(NSTimeInterval)seconds;

/**
	Завершает показ баннера. Метод должен быть вызван при уничтожении экрана на котором баннер отображался.
 */
- (void)finalize;



@end
