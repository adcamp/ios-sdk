//
//  OpenRTBBidRequest.h
//  adcampsdk
//
//  Created by Mikhail on 06.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JSONAble.h"


typedef NS_ENUM(NSInteger, OpenRTBBannerAdType) {
	OpenRTBBannerAdTypeXHTMLText	= 1,
	OpenRTBBannerAdTypeXHTMLBanner	= 2,
	OpenRTBBannerAdTypeJS			= 3,
	OpenRTBBannerAdTypeIFrame		= 4
};

typedef NS_ENUM(NSInteger, OpenRTBBannerCreativeAttribute) {
	OpenRTBBannerCreativeAttributeAudioAutoplay			= 1,
	OpenRTBBannerCreativeAttributeAudioUser             = 2,
	OpenRTBBannerCreativeAttributeExpandableAutomatic	= 3,
	OpenRTBBannerCreativeAttributeExpandableClick		= 4,
	OpenRTBBannerCreativeAttributeExpandableRollover	= 5,
	OpenRTBBannerCreativeAttributeInBannerVideoAutoplay	= 6,
	OpenRTBBannerCreativeAttributeInBannerVideoUser		= 7,
	OpenRTBBannerCreativeAttributePop					= 8,
	OpenRTBBannerCreativeAttributeProvocative			= 9,
	OpenRTBBannerCreativeAttributeExtremeAnimation		= 10,
	OpenRTBBannerCreativeAttributeSurveys				= 11,
	OpenRTBBannerCreativeAttributeTextOnly				= 12,
	OpenRTBBannerCreativeAttributeUserInteractive		= 13,
	OpenRTBBannerCreativeAttributeAlert					= 14,
	OpenRTBBannerCreativeAttributehasAudioOnOff			= 15,
	OpenRTBBannerCreativeAttributeSkippable				= 16
};

typedef NS_ENUM(NSInteger, OpenRTBApiFramework) {
	OpenRTBApiFrameworkVPAID10	= 1,
	OpenRTBApiFrameworkVPAID20	= 2,
	OpenRTBApiFrameworkMRAID	= 3,
	OpenRTBApiFrameworkORMMA	= 4
};

typedef NS_ENUM(NSInteger, OpenRTBAdPosition) {
	OpenRTBAdPositionUnknown		= 0,
	OpenRTBAdPositionAboveTheFold	= 1,
	OpenRTBAdPositionBelowTheFold	= 3,
	OpenRTBAdPositionHeader			= 4,
	OpenRTBAdPositionFooter			= 5,
	OpenRTBAdPositionSidebar		= 6,
	OpenRTBAdPositionFullscreen		= 7
};

typedef NS_ENUM(NSInteger, OpenRTBVideoLinearity) {
    OpenRTBVideoLinear		= 1,
    OpenRTBVideoNonLinear	= 2
};

typedef NS_ENUM(NSUInteger, OpenRTBBidResponseProtocols) {
	OpenRTBBidResponseProtocolsVAST1		= 1,
	OpenRTBBidResponseProtocolsVAST2		= 2,
	OpenRTBBidResponseProtocolsVAST3		= 3,
	OpenRTBBidResponseProtocolsVASTWrapper1	= 4,
	OpenRTBBidResponseProtocolsVASTWrapper2	= 5,
	OpenRTBBidResponseProtocolsVASTWrapper3	= 6,
};

typedef NS_ENUM(NSInteger, OpenRTBVideoPlaybackMethod) {
    OpenRTBVideoPlaybackMethodAutoplaySoundOn	= 1,
    OpenRTBVideoPlaybackMethodAutoplaySoundOff	= 2,
	OpenRTBVideoPlaybackMethodClickToPlay		= 3,
	OpenRTBVideoPlaybackMethodMouseOver			= 4,
};

typedef NS_ENUM(NSInteger, OpenRTBConnectionType) {
	OpenRTBConnectionTypeUnknown				= 0,
    OpenRTBConnectionTypeEthernet				= 1,
	OpenRTBConnectionTypeWiFi					= 2,
    OpenRTBConnectionTypeCellularUnknown		= 3,
	OpenRTBConnectionTypeCellular2G				= 4,
	OpenRTBConnectionTypeCellular3G				= 5,
	OpenRTBConnectionTypeCellular4G				= 6
};

typedef NS_ENUM(NSInteger, OpenRTBExpandableDirection) {
    OpenRTBExpandableDirectionLeft				= 1,
	OpenRTBExpandableDirectionRight				= 2,
    OpenRTBExpandableDirectionUp				= 3,
	OpenRTBExpandableDirectionDown				= 4,
	OpenRTBExpandableDirectionFullscreen		= 5
};

typedef NS_ENUM(NSInteger, OpenRTBDeliveryMethod) {
    OpenRTBDeliveryMethodStreaming		= 1,
    OpenRTBDeliveryMethodProgressive	= 2
};

typedef NS_ENUM(NSInteger, OpenRTBContentContext) {
    OpenRTBContentContextVideo			= 1,
    OpenRTBContentContextGame			= 2,
	OpenRTBContentContextMusic			= 3,
	OpenRTBContentContextApplication	= 4,
	OpenRTBContentContextText			= 5,
	OpenRTBContentContextOther			= 6,
	OpenRTBContentContextUnknown		= 7
};

typedef NS_ENUM(NSInteger, OpenRTBVideoQuality) {
    OpenRTBVideoQualityUnknown					= 0,
    OpenRTBVideoQualityProfessionallyProduced	= 1,
	OpenRTBVideoQualityProsumer					= 2,
	OpenRTBVideoQualityUserGenerated			= 3
};

typedef NS_ENUM(NSInteger, OpenRTBGeoLocationType) {
	OpenRTBGeoLocationTypeGPS			= 1,
	OpenRTBGeoLocationTypeIPAddress		= 2,
	OpenRTBGeoLocationTypeUserProvied	= 3
};

typedef NS_ENUM(NSInteger, OpenRTBDeviceType) {
	OpenRTBDeviceTypeMobile	= 1,
	OpenRTBDeviceTypePC		= 2,
	OpenRTBDeviceTypeTV		= 3
};

typedef NS_ENUM(NSInteger, OpenRTBVASTCompanionType) {
	OpenRTBVASTCompanionTypeStatic	= 1,
	OpenRTBVASTCompanionTypeHTML	= 2,
	OpenRTBVASTCompanionTypeIFrame	= 3
};

typedef NS_ENUM(NSInteger, OpenRTBQAGMediaRating) {
	OpenRTBQAGMediaRatingAll	= 1,
	OpenRTBQAGMediaRatingOver12	= 2,
	OpenRTBQAGMediaRatingMature	= 3
};

typedef NS_ENUM(NSInteger, OpenRTBContentSourceRelationship) {
	OpenRTBContentSourceRelationshipIndirect	= 0,
	OpenRTBContentSourceRelationshipDirect		= 1
};

typedef NS_ENUM(NSInteger, ADCAuctionType) {
    ADCFirstPrice	= 1,
    ADCSecondPrice	= 2
};

static const int ADCPreRoll			=  0;
static const int ADCGenericMidRoll	= -1;
static const int ADCGenericPostRoll	= -2;
static const int ADCPauseRoll		= -3; // не в стандарте

extern NSString *const ADCImpressionExtensionPLIDIMHO;

@interface OpenRTBProducer : NSObject <JSONable>

@property (nonatomic, strong) NSString *producerID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSDictionary *ext;

@end


@interface OpenRTBContent : NSObject <JSONable>

@property (nonatomic, strong) NSString *contentID;
@property (nonatomic, strong) NSString *episode;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSString *season;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *categoriesOfContent;
@property (nonatomic, strong) NSNumber *quality;//OpenRTBVideoQuality
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSNumber *context;
@property (nonatomic, strong) NSNumber *isLiveStream;
@property (nonatomic, strong) NSNumber *sourceRelationship;//OpenRTBContentSourceRelationship
@property (nonatomic, strong) OpenRTBProducer *producer;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, strong) NSNumber *QAGMediaRating;
@property (nonatomic, strong) NSNumber *embeddable;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSDictionary *ext;

@end


@interface OpenRTBPublisher : NSObject <JSONable>

@property (nonatomic, strong) NSString *publisherID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSDictionary *ext;

@end

@interface OpenRTBApp : NSObject <JSONable>

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *sectionCategories;
@property (nonatomic, strong) NSArray *pageCategories;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *bundle;
@property (nonatomic, strong) NSNumber *privacyPolicy;
@property (nonatomic, strong) NSNumber *paid;
@property (nonatomic, strong) OpenRTBPublisher *publisher;
@property (nonatomic, strong) OpenRTBContent *content;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *storeURL;
@property (nonatomic, strong) NSDictionary *ext;

@end

@interface OpenRTBGeo : NSObject <JSONable>

@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *regionfips104;
@property (nonatomic, strong) NSString *metro;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSDictionary *ext;

@end


@interface OpenRTBDevice : NSObject <JSONable>

@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *ipv4;
@property (nonatomic, strong) NSString *ipv6;
@property (nonatomic, strong) OpenRTBGeo *geo;
@property (nonatomic, strong) NSString *dpidsha1;
@property (nonatomic, strong) NSString *carrier;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *make;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSNumber *jsSupported;
@property (nonatomic, strong) NSNumber *connectionType;
@property (nonatomic, strong) NSNumber *deviceType;
@property (nonatomic, strong) NSDictionary *ext;

@end

@interface OpenRTBUser : NSObject <JSONable>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *buyerID;
@property (nonatomic, strong) NSNumber *yearOfBirth;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *customData;
@property (nonatomic, strong) OpenRTBGeo *homeGeo;
@property (nonatomic, strong) NSDictionary *ext;

@end

@interface OpenRTBVideo : NSObject <JSONable>

@property (nonatomic, strong) NSArray *allowedMimeTypes;
@property (nonatomic) OpenRTBVideoLinearity linearity;
@property (nonatomic) int minDuration;
@property (nonatomic) int maxDuration;
@property (nonatomic, strong) NSArray *responseProtocols;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) NSNumber *startDelay;
@property (nonatomic, strong) NSNumber *sequence;
@property (nonatomic, strong) NSArray *blockedAttributes;
@property (nonatomic, strong) NSNumber *maxExtended;
@property (nonatomic) int minBitrate;
@property (nonatomic) int maxBitrate;
@property (nonatomic) BOOL boxingAllowed;
@property (nonatomic, strong) NSArray *playbackMethods;
@property (nonatomic, strong) NSArray *deliveryMethods;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) NSArray *companionAds;
@property (nonatomic, strong) NSArray *companionTypes;
@property (nonatomic, strong) NSDictionary *ext;

+ (OpenRTBVideo *)videoWithSize:(CGSize)size;

- (NSString *)placementID;
- (void)setPlacementID:(NSString *)placementID;

@end

@interface OpenRTBBanner : NSObject <JSONable>

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic, strong) NSString *bannerID;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) NSArray *blockedCreativeTypes;
@property (nonatomic, strong) NSArray *blockedCreativeAttributes;
@property (nonatomic, strong) NSArray *allowedMimeTypes;
@property (nonatomic, strong) NSNumber *topframe;
@property (nonatomic, strong) NSNumber *expandableDirection;
@property (nonatomic, strong) NSDictionary *ext;

+ (OpenRTBBanner *)bannerWithSize:(CGSize)size;

- (NSString *)placementID;
- (void)setPlacementID:(NSString *)placementID;

- (NSDictionary *)originalJSONDictionary;
- (void)addExt:(NSDictionary *)ext;

@end

@interface OpenRTBImpression : NSObject <JSONable>

@property (nonatomic, strong) NSString *impressionID;
@property (nonatomic, strong) OpenRTBBanner *banner;
@property (nonatomic, strong) OpenRTBVideo *video;
@property (nonatomic, strong) NSString *displaymanager;
@property (nonatomic, strong) NSString *displaymanagerver;
@property (nonatomic) BOOL interstitial;
@property (nonatomic, strong) NSString *tagID;
@property (nonatomic) float bidFloor;
@property (nonatomic, strong) NSString *bidFloorCurrency;
@property (nonatomic, strong) NSDictionary *ext;

@property (nonatomic, weak) id context;

+ (OpenRTBImpression *)impressionWithBanner:(OpenRTBBanner *)banner;
+ (OpenRTBImpression *)impressionWithVideo:(OpenRTBVideo *)video;

- (void)addExtValue:(NSObject *)value forKey:(NSString *)key;

@end

@interface OpenRTBBidRequest : NSObject <JSONable>

@property (nonatomic, strong) NSString *bidRequestID;
@property (nonatomic, readonly) NSArray *impressions;
@property (nonatomic, strong) OpenRTBApp *app;
@property (nonatomic, strong) OpenRTBDevice *device;
@property (nonatomic, strong) OpenRTBUser *user;
@property (nonatomic) ADCAuctionType auctionType;
@property (nonatomic) long tmax;
@property (nonatomic, strong) NSArray *blockedCategories;
@property (nonatomic, strong) NSArray *blockedAdvertisers;
@property (nonatomic, strong) NSDictionary *ext;

- (void)addImpression:(OpenRTBImpression *)impression;
- (void)addExt:(NSDictionary *)ext;

@end