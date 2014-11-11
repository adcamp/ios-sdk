//
//  ADCSkin.h
//  visdk
//
//  Created by Mikhail on 05.08.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ADCSkin : NSObject

@property (nonatomic, strong) UIColor *progressBarBackColor;
@property (nonatomic, strong) UIColor *progressBarTopColor;
@property (nonatomic, strong) UIColor *progressBarPreloadColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIImage *bannerCloseButtonImage;

+ (ADCSkin *)defaultSkin;
+ (ADCSkin *)alternativeSkin;

@end
