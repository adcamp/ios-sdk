[TOC]

Руководство по интеграции SDK AdCamp для iOS	{#top}
=====================

Подготовка к работе
-------------------
SDK AdCamp IOS позволяет разработчикам размещать рекламные объявления в своем приложении. Эти объявления могут быть как текстовыми,так и графическими или межстраничными (картинки на весь экран). Большой выбор дейтвий при клике на рекламу позволяет направлять пользователей в App Store, iTunes, браузер, а также производить переход к картам, видео и набору номера и смс. Опционально для объявлений можно настраивать географический (по GPS) и демографический таргетинг, передавая данные в запросе на рекламу.

Данный документ является пошаговой инструкцией по встраиванию SDK в приложение на IOS. Документация по доступным классам и методам доступна здесь: http://tst.adcamp.ru/adcamp/ios/doc/index.html.

### Требования
AdCampSDK для платформе iOS поддерживает:

 - Устройства с операционной системой iOS версии 5.0 и выше
 - Xcode версии 4.5 и выше

### Загрузка

Для начала вам необходимо загрузить следующие файлы:

 1. AdCampSDK для IOS по ссылке: https://github.com/adcamp/ios-sdk/releases/latest
 2. Проект демонстрационного приложения по ссылке: http://tst.adcamp.ru/adcamp/ios/adcamp-examples.zip
Данный пример содержит все варианты использования SDK и его можно использовать как практическое пособие при встраивании sdk в ваше собственное приложение
 


----------


### Интеграция SDK в ваш проект
AdCamp SDK позволяет Вам встроить различные виды рекламы в свое IOS приложение.
На данный момент поддерживаются следующие виды рекламы:

Баннерная реклама (графические, html5 и MRAID баннеры) может быть использована на любом экране приложения и в любом формате.
Полноэкранная баннерная реклама (заставки на весь экран, которые появляются в переходные моменты, например при запуске приложения).
Видеореклама, встроенная в видеоконтент приложения, либо показываемая отдельно

 1. Разархивируйте скачанный архив с SDK. Архив с SDK содержит папку __ADCampSDK.embeddedframework__
 2. Нажмите правой кнопкой мыши на свой проект в Xcode и выберите Add Files to "YourProjectName" (Добавить файлы в YourProjectName).
 3. Добавьте папку ADCampSDK.embeddedframework. Эта папка содержит статический фреймворк и папку ресурсов SDK.
 4. Библиотека ADCampSDK ссылается на следующие библиотеки и фреймворки. (Возможно часть из них уже включены в ваш проект)
    - libsqlite3
    - libxml2
    - AdSupport
    - AudioToolbox
    - AVFoundation
    - CFNetwork
    - CoreGraphics
    - CoreLocation
    - CoreMedia
    - CoreTelephony
    - EventKit
    - EventKitUI
    - Foundation
    - MediaPlayer
    - MessageUI
    - Security
    - StoreKit
    - SystemConfiguration
    - UIKit
    
Чтобы добавить эти библиотеки и фреймворки, дважды нажмите правой кнопкой мыши на название проекта. На вкладке Build Phases (этапы разработки) откройте раздел Link Binary With Libraries (cвязать двоичный код с библиотеками). 
Добавьте среды разработки из SDK для iOS, нажав на появившуюся кнопку +
 


----------


### Инициализация SDK
Откройте в вашем проекте класс реализующий протокол UIApplicationDelegate. Импортируйте заголовочные файлы SDK `#import <ADCampSDK/ADCampSDK.h>`
и в методе `-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions:` добавьте строки инициализации (значения appId и appSecret приведены для примера, вам необходимо поставить данные из личного кабинета [cp.adcamp.ru][1]):
```{.objectivec}
// Инициализируем рекламное sdk
 ADCAdsManager *adManager = [ADCAdsManager sharedManager];
// указываем идентификатор приложения
[adManager setAppId:@"44c30e29-73b4-47ef-87e3-26a89bc7df53"];
// и секрет приложения
[adManager setAppSecret:@"22f72768-8fba-49a0-9d4c-84c1bce3a243"];
```
Для удобства тестирования приложения вы можете включить тестовый режим. 
В тестовом режиме вы всегда будете получать рекламу на каждый запрос, а данные о просмотрах и кликах при этом не будут засчитываться в статистику вашего аккаунта на cp.adcamp. 
Чтобы включить тестовый режим, вы должны сообщить SDK идентификатор вашего устройства. Идентификатор устройства можно узнать в консоли при запуске приложения со встроенным AdCampSDK. Строка с идентификатором будет выглядеть так: 
```{.objectivec}
    15:22:34.785 l: 69 |<----> TEST DEVICE ID:"dfd6cd727e40cf07be1fe8ec1c4db376b73194a1" (-[ADCAdsManager init])
```
На следующей строке после иниализации SDK необходимо добавить тестовые устройства:
```{.objectivec}
    [adManager setTestDevices:[NSArray arrayWithObjects:@"dfd6cd727e40cf07be1fe8ec1c4db376b73194a1", nil]];
```
Для удобства тестирования вы можете установить нужный уровень логирования событий SDK. 
Для этого установите значение глобальной переменной adcloglevel используя значения ADCLogLevel. 

**ВАЖНО: После окончания отладки не забудьте выключить логирование установив значение ADCLogOff**

----------


### Показ баннерной рекламы

#### Встраиваемые баннеры (inline)

Создаём и добавляем новый контейнер рекламы
```{.objectivec}
ADCBannerView *bannerView = [[ADCBannerView alloc] initWithFrame:CGRectMake(0, 0, width, height)]
[self.view addSubview:bannerView];
```
где 0,0 - это координаты расположения, а width, height - размеры
Указываем идентификатор размещения баннера (Placement ID - данные из личного кабинета [cp.adcamp.ru][1])
```{.objectivec}
bannerView.placementID = @"9ce44852-885d-4bdb-8a62-c486ab6eae81";
```
После этого Вы можете запросить рекламу __одним из__ способов:

 - Самый простой способ: выполнить запрос на рекламу исходя из текущего размера баннера:
 
 ```{.objectivec}
[bannerView start];
 ```
 - Если необходимо, чтобы баннер обновлялся каждые 30 или N секунд, то выполняем запрос на рекламу в таком виде:
 
 ```{.objectivec}
[bannerView startWithChangeTimeInterval:30];
 ```
 - Если необходимо указать дополнительные параметры к OpenRTB запросу

 ```{.objectivec}
ADCRequest *adRequest = [ADCRequest defaultRequest];
[adRequest addBannerImpressionForPlayer:bannerView];
OpenRTBBidRequest *bidRequest = adRequest.bidRequest;
bidRequest.app.paid = @NO;
bidRequest.app.keywords = @"video, tes, vast, openrtb";
[bannerView startWithRequest:adRequest];
 ```
Объект bidRequest содержит все объекты OpenRTB запроса, которые указаны в спецификации [OpenRTB v.2.0][2]. Более подробно все доступные объекты описаны ниже в разделе "Настройка параметров OpenRTB запроса"

 - Если есть необходимость иметь больший контроль над временем показа баннера, то есть возможность разделить рекламный запрос и начало отображения.
 ```{.objectivec}
// Создаём рекламный запрос
ADCRequest *adRequest = [ADCRequest defaultRequest];
// Устанавливаем текущий объект делегатом запроса
[adRequest setDelegate:self];
// Запускаем рекламный запрос
[adRequest run];
 ```
Реализуем метод делегата вызываемый при получении баннерной рекламы
 ```{.objectivec}
- (void)request:(ADCRequest *)request didReceiveBanner:(ADCAdvertising *)banner {
    // полученный объект banner может быть запущен сразу в созданном ранее баннерном месте
	[bannerView playAd:banner];
    // либо указатель на него может быть сохранён и использован позднее в удобное время
}
 ```


----------

#### Настройка параметров OpenRTB запроса

У объекта OpenRTBBidRequest могут быть добавлены любые дополнительные свойства описаннные в спецификации OpenRTB. А именно
##### OpenRTBBidRequest
Сам корневой объект OpenRTBBidRequest (реализация BidRequest) может содержать следующие поля:

- app (OpenRTBApp) - объект отвечающий за свойства приложения в котором размещена реклама
- device (OpenRTBDevice) -  объект отвечающий за свойства устройства на котором запущено приложение
- user (OpenRTBUser) - объект отвечающий за свойства пользователя приложения
- blockedCategories - список заблокированных категорий рекламы для данного приложения
- blockedAdvertisers - список хаблокированных рекламодателей для данного приложения

##### OpenRTBUser
Объект содержащий информацию о пользователе приложения. Может содержать следующие поля:
- userID - идентификатор пользователя
- buyerID - идентификатор покупателя 
- yearOfBirth - год рождения
- gender - пол (строка "M", "F" или "O")
- keywords - строка со списком интересов или других ключевых слов для данного польщователя
- customData - любая другая информация о пользователе
- homeGeo (OpenRTBGeo) - информация о местонахождении пользователя

##### OpenRTBDevice
Информация об устройстве на котором запущено приложение. Большинство полей заполняется автоматически.

##### OpenRTBApp
Информация о приложении для которого запрашивается реклама. Часть полей заполняется автоматически (bundle, version). Остальные могут быть настроены:
- appID - идентификатор приложения на рекламной бирже
- name -  название приложения
- domain - домен приложения
- categories - список категорий к которым можно отнести всё приложение
- sectionCategories - список категорий к которым можно отнести текущий раздел приложения
- pageCategories - список категорий к которым можно отнести текущий экран/страницу приложения
- privacyPolicy - содержит ли приложение политику конфиденциальности (1 или 0)
- paid - индикатор платного приложения (1 или 0)
- publisher (OpenRTBPublisher) - издатель приложения
- content (OpenRTBContent) - информация о контенте приложения
- keywords - строка со списком ключевых слов к приложению
- storeURL - ссылка на приложение в AppStore

##### OpenRTBPublisher
Объект содержащий информацию об издателе приложения. Может содержать следующие свойства:
- publisherID - идентификатор издателя
- name - название издателя
- categories - список категорий контента для данного издателя
- domain - домен верхнего уровня издателя (например foopub.com)

##### OpenRTBContent
Объект содержащий информацию о контенте приложения. Могут быть заполнены только те поля которые применимы к текущему контенту. Доступны следующие поля:
- contentID - идентификатор контента
- episode - название эпизода
- title - название контента
- series - название серии контента
- season - название сезона контента
- url - ссылка на контент в вебе
- categoriesOfContent - список категорий контента
- quality - качество контента (OpenRTBVideoQuality)
- keywords - ключевые слова
- context - тип контента (видео, игра и т.д. Список доступен в OpenRTBContentContext)
- isLiveStream - индикатор прямой трансляции (1 или 0)
- producer (OpenRTBProducer) - издатель контента
- length - длительность в секундах
- language - язык контента

##### OpenRTBProducer
 Информация о продюсере контента приложения. Доступны следующие поля:
- producerID - идентифкатор продюсера
- name - название продюсера
- categories - список характерных категорий
- domain - url продюсера контента 

##### OpenRTBGeo
Информация о местоположении. Объект данного типа существует как для объекта OpenRTBUser так и для OpenRTBDevice. В первом случае указывается "регион интересов" пользователя независимо от его местоположения в данный момент. Например пользователь мог указать в профиле свой город, но находиться в данный момент в другом.
- lat, lon - географические координаты пользователя
- country, region, city - страна, регион, город
- metro - станция метро
- zip - почтовый код
- type - источник информации о местоположении (OpenRTBGeoLocationType)

##### OpenRTBImpression
Каждый объект OpenRTBBidRequest содержит несколько описаний рекламных мест. Если известно, что такое место одно - для получения этого объекта можно воспользоваться одним из методов -findVideoImpression, -findBannerImpression. OpenRTBImpression содержит следующие опциональные поля и объекты доступны для настройки:
- banner (OpenRTBBanner) - описание баннерного места
- video (OpenRTBVideo) - описание видео рекламного места
- bidFloor - стоимость рекламного места в bidFloorCurrency
- bidFloorCurrency - валюта в которой указывается стоимость (по умолчанию USD)

##### OpenRTBBanner
Описание баннерного места. Доступны для настройки следующие поля:
- bannerID - идентификатор баннерного места
- position - позиция размещения баннера (OpenRTBAdPosition)
- blockedCreativeTypes - список кодов заблокированных типов рекламы (OpenRTBBannerAdType)
- blockedCreativeAttributes - список заблокированных атрибутов (OpenRTBBannerCreativeAttribute)
- allowedMimeTypes - список разрешённых MIME типов контента
- expandableDirection - список направлений в которых баннер может "разворачиваться" (OpenRTBExpandableDirection)

##### OpenRTBVideo
Описание рекламного видео места.
- allowedMimeTypes - список разрешённых MIME типов контента
- linearity - индикатор линейная ли реклама (OpenRTBVideoLinearity)
- minDuration, maxDuration - минимальная/максимальная длительность контента
- startDelay -интервал времени от начала контента до показа рекламы, либо особые значения (ADCPreRoll, ADCGenericMidRoll, ADCGenericPostRoll	, ADCPauseRoll)
- blockedAttributes - заблокированные атрибуты для креативов
- minBitrate, maxBitrate - минимальный и максимальны битрейты для видео рекламы
- deliveryMethods - способ доставки контента (OpenRTBDeliveryMethod)
- position - позиция размещения рекламы (OpenRTBAdPosition)

##### Пример настройки баннерного запроса
```{.objectivec}
ADCRequest *adRequest = [ADCRequest defaultRequest];
	OpenRTBBidRequest *bidRequest = adRequest.bidRequest;
	bidRequest.app.content.producer.name = @"Никита Михалков";
	bidRequest.app.content.producer.categories = @[@"IAB25-2", @"IAB25-3"];
	bidRequest.app.content.producer.domain = @"ru.mikhalkov";
	bidRequest.app.content.producer.ext = @{@"some_key": @"some_value"};
	bidRequest.app.content.episode = @"2";
	bidRequest.app.content.title = @"Утомлённые солнцем 2: Предстояние";
	bidRequest.app.content.season = @"Сезон 1";
	bidRequest.app.content.url = @"us2.ru";
	bidRequest.app.content.categoriesOfContent = @[@"IAB25-2"];
	bidRequest.app.content.quality = @(OpenRTBVideoQualityProsumer);
	bidRequest.app.content.keywords = @"Утомлённые, солнцем, Предстояние";
	bidRequest.app.content.context = @(OpenRTBContentContextVideo);
	bidRequest.app.content.isLiveStream = @YES;
	bidRequest.app.content.sourceRelationship = @(OpenRTBContentSourceRelationshipIndirect);
	bidRequest.app.content.length = @96;
	bidRequest.app.content.QAGMediaRating = @(OpenRTBQAGMediaRatingMature);
	bidRequest.app.content.embeddable = @NO;
	bidRequest.app.content.language = @"ru";
	bidRequest.app.publisher.name = @"Бесогон ТВ";
	bidRequest.app.publisher.categories = @[@"IAB25-2", @"IAB25-3"];
	bidRequest.app.publisher.domain = @"tv.besogon";
	bidRequest.app.publisher.ext = @{@"some_key": @"some_value"};
	bidRequest.app.name = @"ADC TEST";
	bidRequest.app.domain = @"com.sebbia.vi";
	bidRequest.app.categories = @[@"IAB25-3"];
	bidRequest.app.sectionCategories = @[@"IAB25-3"];
	bidRequest.app.pageCategories = @[@"IAB25-3"];
	bidRequest.app.privacyPolicy = @NO;
	bidRequest.app.paid = @NO;
	bidRequest.app.keywords = @"video, international, vast, openrtb";
	[bannerView startWithRequest:adRequest];
```

#### Полноэкранные баннеры (interstitial)

Для показа полноэкранных баннеров предназначен класс ADCInterstitialViewController. Чтобы запросить полноэкранную рекламы нужно инстанцировать экземпляр класса, указать placementID и делегат
```
	self.interstitial = [[ADCInterstitialViewController alloc] init];
    self.interstitial.delegate  = self;
    self.interstitial.placementID = @"144";
```
Запускаем загрузку баннера одним из методов
```
[self.interstitial start];
```
либо с указанием объекта запроса
```
[self.interstitial startWithRequest:request];
```
После чего в указанном объекте-делегате реализующем протокол ADCInterstitialViewControllerDelegate (в данном случае self) в методе `- (void)interstitialControllerDidReceiveAd:(ADCInterstitialViewController *)interstitial` запускаем показ полноэкранной рекламы
```
- (void)interstitialControllerDidReceiveAd:(ADCInterstitialViewController *)interstitial {
    [interstitial presentFromRootViewController:self];
}
```
В случае возникновения проблем с загрузкой баннера вызовется метод `- (void)interstitialControllerDidFailToPlayAd:(ADCInterstitialViewController *)interstitial withError:(ADCError *)error`
в котором будет указана причина невозможности загрузки рекламы

При необходимости большего контроля за событиями времени жизни полноэкранного баннера реализуйте остальные методы делегата
```
- (void)interstitialControllerWillStartAd:(ADCInterstitialViewController *)interstitial;
- (void)interstitialControllerDidFinishAd:(ADCInterstitialViewController *)interstitial;
- (void)interstitialControllerWillLeaveApplication:(ADCInterstitialViewController *)interstitial;
- (void)interstitialControllerWillReturnToApplication:(ADCInterstitialViewController *)interstitial;
```


#### Передача параметров в баннер

В случае если вам необходимо передать некоторые данные для обработки в баннер - вы можете сделать это при создании контейнера рекламы в указав параметры в свойстве creativeParams объектов `ADCBannerView` или `ADCInterstitialViewController` для встроенной и полноэкранной рекламы соответственно. 

Например:
```{.objectivec}
ADCBannerView *bannerView = [[ADCBannerView alloc] initWithFrame:CGRectMake(0, 0, width, height)]
bannerView.creativeParams = @{ADCCreativeParamFirstName:@"John", @"param2":@"value2"};
[self.view addSubview:bannerView];
```

#### Вызов пользовательских событий баннера

Пользователь имеет возможность вызывать собственные конверсионные события баннера. Для этого необходимо вызвать метод
```
- (void)trackUserEvent:(NSString *)userEventName;
```
у рекламного объекта `ADCBannerView` или `ADCInterstitialViewController` для встроенной и полноэкранной рекламы соответственно. 
В качестве параметра следует передавать одну из доступных констант kAdEventUser1, kAdEventUser2 или kAdEventUser3.
Конкретный смысл каждого типа пользовательского события  определяется самим разработчиком и задается на этапе создания рекламной кампании.


  [1]: http://cp.adcamp.ru
  [2]: http://www.iab.net/media/file/OpenRTB_API_Specification_Version2.0_FINAL.PDF