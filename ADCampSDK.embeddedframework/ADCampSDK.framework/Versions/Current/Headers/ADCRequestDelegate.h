//
//  ADCRequestDelegate.h
//  adcampsdk
//
//  Created by Mikhail on 06.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADCRequest;
@class ADCWrapperAd;
@class ADCAdvertising;

/**
	Набор методов для отслеживания состояния ADCRequest
 */
@protocol ADCRequestDelegate <NSObject>

@optional

/**
 Метод вызываемый при начале запроса
 @param request запрос
 */
- (void)requestDidStart:(ADCRequest *)request;

/**
	Метод вызываемый при успешном завершении запроса на рекламу
	@param request запрос, который завершен
 */
- (void)requestDidFinishLoading:(ADCRequest *)request;

/**
	Метод вызываемый в случае ошибки запроса на рекламу
	@param request запрос завершившийся ошибкой
	@param error объект ошибки
 */
- (void)request:(ADCRequest *)request didFailWithError:(NSError *)error;

/**
	Метод вызываемый в случае ошибки при получении одного из Wrapper документов
	@param request запрос завершившийся ошибкой
	@param error объект ошибки
	@param wrapperAd объект Wrapper для которого произошла ошибка
 */
- (void)request:(ADCRequest *)request didReceiveError:(NSError *)error forWrapper:(ADCWrapperAd *)wrapperAd;

/**
	Метод вызываемый для передачи списка точек остановки основного плеера в случае линейной рекламы
	@param request запрос на рекламу
	@param breaks список точек остановки
 */
- (void)request:(ADCRequest *)request didReceivePlaybreaks:(NSArray *)breaks;

/**
	Метод вызываемый для передачи pre-roll рекламы
	@param request запрос на рекламу
	@param preroll pre-roll реклама
 */
- (void)request:(ADCRequest *)request didReceivePreroll:(ADCAdvertising *)preroll;

/**
 Метод вызываемый для передачи рекламы проигрываемой в паузе основного плеера
 @param request запрос на рекламу
 @param pauseroll pre-roll реклама
 */
- (void)request:(ADCRequest *)request didReceivePauseroll:(ADCAdvertising *)pauseroll;

/**
 Метод вызываемый для передачи рекламы проигрываемой после основного контента
 @param request запрос на рекламу
 @param postroll post-roll реклама
 */
- (void)request:(ADCRequest *)request didReceivePostroll:(ADCAdvertising *)postroll;

/**
 Метод вызываемый для передачи баннерной рекламы
 @param request запрос на рекламу
 @param banner реклама содержащая баннер
 */
- (void)request:(ADCRequest *)request didReceiveBanner:(ADCAdvertising *)banner;

/**
 Метод вызываемый для передачи видеорекламы без привязки к основному контенту
 @param request запрос на рекламу
 @param video реклама содержащая видео
 */
- (void)request:(ADCRequest *)request didReceiveCommonVideo:(ADCAdvertising *)video;

@end
