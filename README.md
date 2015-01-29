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

 1. AdCampSDK для IOS по ссылке: http://sdk.adcamp.ru/adcamp-sdk-ios.zip
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

Разместить в своём приложении полноэкранную рекламу возможно двумя способами:

Первый - показ рекламы по факту завершения рекламного запроса. 
Реклама будет показана сразу после завершения запроса или ничего не произойдёт, если рекламный запрос завершится неудачей или сервер не возвратит рекламу.
Для показа необходимо создать запрос за полноэкранной рекламой с вашим PlacementID (данные из личного кабинета [cp.adcamp.ru][1])

```{.objectivec}
    // создаём рекламный запрос с описанием полноэкранного баннера c PlacementID
    ADCRequest *request = [ADCRequest fullscreenBannerRequestWithPlacementID:@"393058cf-ea48-4ccb-8a05-d4fca4022f25"];
    // запускаем запрос с указанием необходимости полноэкранного показа
    // в качестве аргумента передаём указатель на UIViewController который будет родительским для реклмного экрана
    [request runAsInterstitialFromRootViewController:self];
```

Второй способ - предварительно получить полноэкранный баннер и показать его в удобное время. 
```{.objectivec}
    // создаём рекламный запрос с описанием полноэкранного баннера c PlacementID
    ADCRequest *request = [ADCRequest fullscreenBannerRequestWithPlacementID:@"393058cf-ea48-4ccb-8a05-d4fca4022f25"];
    // Устанавливаем текущий объект делегатом запроса
    request.delegate = self;
```
Полученная реклама может быть отображена в любой момент после её получения в методе
```{.objectivec}
- (void)request:(ADCRequest *)request didReceiveBanner:(ADCAdvertising *)banner {
    // полученный объект banner может быть запущен сразу в созданном ранее баннерном месте
	[banner presentAsInterstitialFromRootViewController:rootViewController];
}
```

__Замечание:__ При использовании первого способа показа рекламы нет возможности явно управлять кешированием рекламы до показа, во втором такая возможность имеется, однако теряется возможность автоматического показа рекламы из альтернативной рекламной сети

#### Передача параметров в баннер

В случае если вам необходимо передать некоторые данные для обработки в баннер - вы можете сделать это при запросе баннерной рекламы

* в случае если запрос производится напрямую в ADCBannerView
```{.objectivec}
ADCBannerView *bannerView = [[ADCBannerView alloc] initWithFrame:CGRectMake(0, 0, width, height)]
bannerView.creativeParams = @{ADCCreativeParamFirstName:@"John", @"param2":@"value2"};
[self.view addSubview:bannerView];
```
* в случае если запрос производится независимо от контейнера ADCBannerView следует воспользоваться свойством _creativeParams_ объекта __OpenRTBBanner__  _(Пример для полноэкранной рекламы)_
```{.objectivec}
ADCRequest *adRequest = [ADCRequest defaultRequest];
			OpenRTBBanner *banner = [OpenRTBBanner bannerWithSize:[[UIScreen mainScreen] boundsWithCurrentStatusBarOrientation].size];
            banner.creativeParams = @{@"param1":@"value1", @"param2":@"value2"};
            banner.placementID = [PlacementManager placement:@"full"];
			OpenRTBImpression *imp = [OpenRTBImpression impressionWithBanner:banner];
			[_adRequest addImpression:imp withContext:nil];
			[_adRequest runAsInterstitialFromRootViewController:self];
```

#### Вызов пользовательских событий баннера

Пользователь имеет возможность вызывать собственные конверсионные события баннера. Для этого необходимо вызвать метод
```
- (void)trackUserEvent:(NSString *)userEventName;
```
у рекламного объекта `ADCBannerView` или `ADCInterstitialViewController` для встроенной и полноэкранной рекламы соответственно. 
В качестве параметра следует передавать одну из доступных констант kAdEventUser1, kAdEventUser2 или kAdEventUser3.
Конкретный смысл каждого типа пользовательского события  определяется самим разработчиком и задается на этапе создания рекламной кампании.

----------


### Использование сторонних сетей

AdCamp может не возвращать рекламы в определенные моменты времени. Это может происходит например при отсутствии подходящей рекламы от рекламодателя или по другим причинам. 
В этом случае Вы можете автоматически размещать рекламу из других рекламных сетей, используя SDK AdCamp.
При этом реклама от AdCamp всегда имеет приоритет над рекламой других рекламных сетей.

Для того, чтобы автоматически размещать рекламу из другой рекламной сети, Вам нужно при инициализации библиотеки AdCamp указать интересующую Вас рекламную сеть и задать все необходимые для её использования параметры.
Вам также может потребоваться добавить в свой проект библиотеку, содержащию sdk указанной рекламной сети или выполнить другие шаги.


#### Инструкция на примере AdMob

Для того, чтобы использовать AdMob в качестве дополнительного источника рекламы, Вам потребуется:

 1. Зарегистрироваться как publisher на сайте http://www.admob.com/
 2. Зарегистрировать приложение в системе AdMob и получить PublisherID
 3. Добавить admob как дополнительный источник рекламы
 4. После этого все рекламные объекты будут использовать указанную рекламную сеть вместо AdCamp при отсутствии у AdCamp рекламы.

 ```{.objectivec}
// добавляем AdMob и в конфигурации указываем полученный ранее PublisherID
[adManager addAdditionalNetwork:[ADCAdditionalNetwork adMobNetwork]
 withConfig:[ADCAdMobNetworkConfig configWithPublisherID:@"MyPublisherID" testDevices:[NSArray arrayWithObjects:@"ADMOB_TEST_DEVICE_ID", nil]]];
 // здесь MyPublisherID - идентификатор полученный на шаге 2.
 ```
 
 __Замечание:__ Возможности каждой конкретной рекламной сети могут быть ограничены. Так, например, AdMob будет использоваться только для баннерной рекламы, так как SDK AdMob не поддерживает видеорекламу или предзакачку рекламы.
 
 Чтобы получать тестовую рекламу для AdMob понадобится идентификатор тестового устройства выданный библиотекой AdMob. 
Идентификатор можно найти в консоли. 
Строка будет выглядеть примерно так:
 ```{.objectivec}
`<Google> To get test ads on this device, call: request.testDevices = [NSArray arrayWithObjects:@"ADMOB_TEST_DEVICE_ID", nil];`
 ```
Где ADMOB_TEST_DEVICE_ID - идентификатор, который вы должны поместить в аргументы при вызове конструктора ADCAdMobNetworkConfig

Для того, чтобы проверить работу дополнительной рекламной сети, Вы можете добавить ваше устройство в список устройств для тестирования дополнительной рекламы:

```{.objectivec}
// Укажите свой идентификатор устройства
// Его можно получить инициализировав библиотеку
// В консоли будет распечатана такая строка:
// TEST DEVICE ID: YOUR_TEST_DEVICE_ID (-[ADCAdsManager init])
[adManager setTestDevicesForAdditionalNetworks:[NSArray arrayWithObjects:@"YOUR_TEST_DEVICE_ID", nil]];
```
При этой настройке указанное устройство не будет получать рекламу от AdCamp, что позволит протестировать срабатывание альтернативной рекламы (в данном примере AdMob).


----------


### Показ видеорекламы

SDK AdCamp позволяет размещать рекламу в формате видеороликов внутри вашего приложения. 
Это могут быть как и отдельно проигрываемые рекламные ролики (например, при запуске приложения) так и ролики встроенные непосредственно видео контент.

#### Отдельный видеоролик

Чтобы разместить отдельный рекламный видеоролик, необходимо добавить ADCVideoView на нужный экран. Например:
```{.objectivec}
// создаём видеоплеер размера (width x height) в координатах (0, 0)
videoView = [[ADCVideoView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
// добавляем его на view
[self.view addSubview:videoView];
```
Укзать идентификатор размещения рекламы (Placement ID из личного кабинета [cp.adcamp.ru][1])
```{.objectivec}
// указываем идентификатор размещения рекламы Placement ID
videoView.placementID = @"9ce44852-885d-4bdb-8a62-c486ab6eae81";
```

После этого Вы можете запросить рекламу одним из способов:

 - Выполняем запрос на рекламу исходя из текущего размера баннера
 
 ```{.objectivec}
 [videoView start];
 ```
 - Выполняем указанный запрос на рекламу с указанием дополнительные параметров к OpenRTB запросу
 
 ```{.objectivec}
 ADCRequest *adRequest = [ADCRequest defaultRequest];
[adRequest addVideoImpressionForPlayer:videoView];
OpenRTBBidRequest *bidRequest = adRequest.bidRequest;
bidRequest.app.paid = @NO;
bidRequest.app.keywords = @"video, tes, vast, openrtb";
[videoView startWithRequest:adRequest];
 ```
Объект bidRequest содержит все объекты OpenRTB запроса, которые указаны в спецификации [OpenRTB v.2.0][2]

#### Видеоплеер с поддержкой рекламы

AdCampSDK содержит класс ADCVideoPlayer, который поддерживает интерфейс MPMediaPlayback и имеет возможность проигрывать видеорекламу полученную перед началом показа основного контента

```{.objectivec}
// создаем плеер нужного размера
ADCVideoPlayer *player = [[ADCVideoPlayer alloc] initWithFrame:CGRectMake(0, 0 , 300, 200)];
// указываем URL для основного контента
[player setContentURL:[NSURL URLWithString:@"http://tst.adcamp.ru/bbb.mp4"]];
// добавляем описание рекламного места перед началом основного контента
[player addVideoPlayBreakAtPosition:ADCVideoPositionPreRoll];
// и через 30 секунд после начала
[player addVideoPlayBreakAtTimeOffset:30];
// запускаем плеер
[player play];
```

#### Видео, встроенное в специальный плеер

В связи с тем, что различных реализаци плееров очень много, невозможно привести полный алгоритм встраивания SDK в специальный плеер. Обратите внимание на пример ADCMoviePlayer, в котором реклама встраивается в плеер на основе AVPlayer.

Общие шаги и принципы работы можно сформулировать следующим образом:

 1. Добавить ADCVideoView поверх Вашего видеоплеера; ADCVideoView невидим если он не показывает рекламу
 2. Создать запрос ADCRequest
 3. Добавить в запрос спецификацию одного или нескольких рекламных мест с помощью методов:

 ```{.objectivec}
 - (ADCAdvertising *)addVideoImpressionForPlayer:(ADCEmbeddedPlayer *)player;
 - (ADCAdvertising *)addVideoImpressionForPlayer:(ADCEmbeddedPlayer *)player atPosition:(ADCVideoPosition)position;
 - (ADCAdvertising *)addVideoImpressionForPlayer:(ADCEmbeddedPlayer *)player atTimeOffset:(int)timeOffset;
 ```

 4. Выполнить запрос и получить один или несколько объектов ADCAdvertising в соответствующих методах делегата запроса
 5. (Опционально) Закешировать рекламу вызовом `- (void)preload` объекта ADCAdvertising
 6. В нужный момент показать рекламу вызвав метод:

 ```{.objectivec}
- (void)playAd:(ADCAdvertising *)ad;
// либо
- (void)playAd:(ADCAdvertising *)ad preloadRate:(float)cacheRate;
// если необходимо указать минимальный процент загрузки рекламного ролика перед проигрыванием
 ``` 


  [1]: http://cp.adcamp.ru
  [2]: http://www.iab.net/media/file/OpenRTB_API_Specification_Version2.0_FINAL.PDF