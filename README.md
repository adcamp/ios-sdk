<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AdCampSDKv2</title>
<link rel="stylesheet" href="https://stackedit.io/res-min/themes/base.css" />
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML"></script>
</head>
<body><div class="container"><p><div class="toc">
<ul>
<li><a href="#top">Руководство по интеграции SDK AdCamp для iOS   </a><ul>
<li><a href="#подготовка-к-работе">Подготовка к работе</a><ul>
<li><a href="#требования">Требования</a></li>
<li><a href="#загрузка">Загрузка</a></li>
<li><a href="#интеграция-sdk-в-ваш-проект">Интеграция SDK в ваш проект</a></li>
<li><a href="#инициализация-sdk">Инициализация SDK</a></li>
<li><a href="#показ-баннерной-рекламы">Показ баннерной рекламы</a><ul>
<li><a href="#встраиваемые-баннеры-inline">Встраиваемые баннеры (inline)</a></li>
<li><a href="#настройка-openrtb-параметров-при-запросе-рекламы">Настройка OpenRTB параметров при запросе рекламы</a><ul>
<li><a href="#bid-request-object-adcrequest">(Bid Request Object) ADCRequest</a></li>
<li><a href="#user-object-openrtbuser">(User Object) OpenRTBUser</a></li>
<li><a href="#app-object-openrtbapp">(App Object) OpenRTBApp</a></li>
<li><a href="#publisher-object-openrtbpublisher">(Publisher Object) OpenRTBPublisher</a></li>
<li><a href="#content-object-openrtbcontent">(Content Object) OpenRTBContent</a></li>
<li><a href="#producer-object-openrtbproducer">(Producer Object) OpenRTBProducer</a></li>
<li><a href="#geo-object-openrtbgeo">(Geo Object) OpenRTBGeo</a></li>
<li><a href="#banner-object-adcbannerview-adcinterstitialviewcontroller">(Banner Object) ADCBannerView / ADCInterstitialViewController</a></li>
<li><a href="#пример-настройки-баннерного-запроса">Пример настройки баннерного запроса</a></li>
</ul>
</li>
<li><a href="#полноэкранные-баннеры-interstitial">Полноэкранные баннеры (Interstitial)</a></li>
<li><a href="#передача-параметров-в-баннер">Передача параметров в баннер</a></li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ul>
</div>
</p>



<h1 id="top">Руководство по интеграции SDK AdCamp для iOS   </h1>



<h2 id="подготовка-к-работе">Подготовка к работе</h2>

<p>SDK AdCamp для iOS позволяет разработчикам размещать рекламные объявления в своем приложении. Эти объявления могут быть как текстовыми, так и графическими или межстраничными (картинки на весь экран). Большой выбор действий при клике на рекламу позволяет направлять пользователей в App Store, iTunes, браузер, а также производить переход к картам, видео и набору номера и смс. Опционально для объявлений можно настраивать географический (по GPS) и демографический таргетинг, передавая данные в запросе на рекламу.</p>

<p>Данный документ является пошаговой инструкцией по встраиванию SDK в приложение на iOS. Документация по доступным классам и методам доступна здесь: <a href="http://tst.adcamp.ru/adcamp/ios/doc/index.html">http://tst.adcamp.ru/adcamp/ios/doc/index.html</a>.</p>



<h3 id="требования">Требования</h3>

<p>AdCampSDK для платформы iOS поддерживает:</p>

<ul>
<li>Устройства с операционной системой iOS версии 5.0 и выше</li>
<li>Xcode версии 4.5 и выше</li>
</ul>



<h3 id="загрузка">Загрузка</h3>

<p>Для начала работы необходимо загрузить следующие файлы из текущего репозитория:</p>

<ol>
<li>AdCampSDK для iOS</li>
<li>Проект демонстрационного приложения<br>
Данный пример содержит все варианты использования SDK и его можно использовать как практическое пособие при встраивании sdk в ваше собственное приложение</li>
</ol>

<hr>



<h3 id="интеграция-sdk-в-ваш-проект">Интеграция SDK в ваш проект</h3>

<p>AdCamp SDK позволяет Вам встроить различные виды рекламы в свое iOS приложение. <br>
На данный момент поддерживаются следующие виды рекламы:</p>

<p>Баннерная реклама (графические, html5 и MRAID баннеры) может быть использована на любом экране приложения и в любом формате. <br>
Полноэкранная баннерная реклама (заставки на весь экран, которые появляются в переходные моменты, например при запуске приложения).</p>

<ol>
<li>Разархивируйте скачанный архив с SDK. Архив с SDK содержит папку <strong>ADCampSDK.embeddedframework</strong></li>
<li>Нажмите правой кнопкой мыши на свой проект в Xcode и выберите Add Files to “YourProjectName” (Добавить файлы в YourProjectName).</li>
<li>Добавьте папку ADCampSDK.embeddedframework. Эта папка содержит статический фреймворк и папку ресурсов SDK.</li>
<li>Библиотека ADCampSDK ссылается на следующие библиотеки и фреймворки. (Возможно часть из них уже включены в ваш проект) <br>
<ul><li>libsqlite3</li>
<li>libxml2</li>
<li>AdSupport</li>
<li>AudioToolbox</li>
<li>AVFoundation</li>
<li>CFNetwork</li>
<li>CoreGraphics</li>
<li>CoreLocation</li>
<li>CoreMedia</li>
<li>CoreTelephony</li>
<li>EventKit</li>
<li>EventKitUI</li>
<li>Foundation</li>
<li>MediaPlayer</li>
<li>MessageUI</li>
<li>Security</li>
<li>StoreKit</li>
<li>SystemConfiguration</li>
<li>UIKit</li></ul></li>
</ol>

<p>Чтобы добавить эти библиотеки и фреймворки, дважды нажмите правой кнопкой мыши на название проекта. На вкладке Build Phases (этапы разработки) откройте раздел Link Binary With Libraries (cвязать двоичный код с библиотеками).  <br>
Добавьте среды разработки из SDK для iOS, нажав на появившуюся кнопку +</p>

<hr>



<h3 id="инициализация-sdk">Инициализация SDK</h3>

<p>Откройте в вашем проекте класс реализующий протокол UIApplicationDelegate. Импортируйте заголовочные файлы SDK <code>#import &lt;ADCampSDK/ADCampSDK.h&gt;</code> <br>
и в методе <code>-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions:</code> добавьте строки инициализации ):</p>



<pre class="prettyprint"><code class="language-{.objectivec} hljs scss"><span class="hljs-comment">// Инициализируем рекламное sdk</span>
<span class="hljs-attr_selector">[ADCAdsManager sharedManager]</span>;</code></pre>

<p>Если необходимо установить особые разрешения при инициализации сдк воспользуйтесь методом: <code>+ (ADCAdsManager *)sharedManagerWithCredentials:(NSDictionary *)credentials</code></p>



<pre class="prettyprint"><code class="language-{.objectivec} hljs java"><span class="hljs-comment">// Инициализируем рекламное sdk</span>
<span class="hljs-comment">// и запрещаем отправку координат пользователя</span>
[ADCAdsManager sharedManagerWithCredentials:@{ADCCredentialLocation:<span class="hljs-annotation">@NO</span>}];</code></pre>

<p>Для удобства тестирования вы можете установить нужный уровень логирования событий SDK.  <br>
Для этого установите значение глобальной переменной adcloglevel используя значения ADCLogLevel. Например:</p>



<pre class="prettyprint"><code class=" hljs fix"><span class="hljs-attribute">adcloglevel </span>=<span class="hljs-string"> ADCLogDebug;</span></code></pre>

<p><strong>ВАЖНО: После окончания отладки не забудьте выключить логирование установив значение ADCLogOff</strong></p>

<hr>



<h3 id="показ-баннерной-рекламы">Показ баннерной рекламы</h3>



<h4 id="встраиваемые-баннеры-inline">Встраиваемые баннеры (inline)</h4>

<p>Создаём и добавляем новый контейнер рекламы</p>



<pre class="prettyprint"><code class="language-{.objectivec} hljs fix"><span class="hljs-attribute">ADCBannerView *bannerView </span>=<span class="hljs-string"> [[ADCBannerView alloc] initWithFrame:CGRectMake(0, 0, width, height)]
[self.view addSubview:bannerView];</span></code></pre>

<p>где 0,0 - это координаты расположения, а width, height - размеры рекламной области. <br>
Указываем идентификатор размещения баннера Placement ID (идентификатор вы сможете получить по запросу на электронной почте <a href="mailto:account@adcamp.ru">account@adcamp.ru</a> в письме необходимо указать название площадки и тип плейсмента)</p>



<pre class="prettyprint"><code class="language-{.objectivec} hljs avrasm">bannerView<span class="hljs-preprocessor">.placementID</span> = @<span class="hljs-string">"9ce44852-885d-4bdb-8a62-c486ab6eae81"</span><span class="hljs-comment">;</span></code></pre>

<p>После этого Вы можете запросить рекламу <strong>одним из</strong> способов:</p>

<ul>
<li><p>Самый простой способ: выполнить запрос на рекламу исходя из текущего размера баннера:</p>

<pre class="prettyprint"><code class="language-{.objectivec} hljs sql">[bannerView <span class="hljs-operator"><span class="hljs-keyword">start</span>];</span></code></pre></li>
<li><p>Если необходимо необходимо уточнить параметры запроса (подробно далее в разделе “Настройка OpenRTB параметров при запросе рекламы”):</p>

<pre class="prettyprint"><code class="language-{.objectivec} hljs ini"><span class="hljs-title">[bannerView startWithRequest:request]</span><span class="hljs-comment">;</span></code></pre></li>
</ul>

<p>Если есть необходимость иметь контроль за жизненным циклом ADCBannerView можно реализовать протокол ADCBannerViewDelegate <br>
 <code>{.objectivec} <br>
 ADCBannerView *bannerView = [[ADCBannerView alloc] initWithFrame:CGRectMake(0, 0, width, height)]; <br>
 //... <br>
// после создание баннера устанавливаем текущий объект делегатом <br>
bannerView.delegate = self; <br>
</code> <br>
Все методы протокола ADCBannerViewDelegate опциональны. Полный список можно найти в файле ADCBannerViewDelegate.h</p>

<hr>



<h4 id="настройка-openrtb-параметров-при-запросе-рекламы">Настройка OpenRTB параметров при запросе рекламы</h4>

<p>Если необходимо указать дополнительные параметры к запросу это можно сделать при его создании. Например:</p>

<p><code>{.objectivec} <br>
ADCRequest *request = [ADCRequest defaultRequest]; <br>
request.user.gender = @"M"; <br>
request.user.keywords = @"auto,audi,dtm"; <br>
request.user.homeGeo.city = @"Moscow"; <br>
request.app.paid = @NO; <br>
request.app.keywords = @"auto,sport"; <br>
[bannerView startWithRequest:request]; <br>
</code></p>

<p>Объект ADCRequest содержит объекты OpenRTBUser (User), OpenRTBApp (App) OpenRTB запроса, которые указаны в спецификации <a href="http://www.iab.net/media/file/OpenRTB_API_Specification_Version2.0_FINAL.PDF">OpenRTB v.2.0</a>, а также свойства blockedCategories, blockedAdvertisers</p>

<p>Ниже указан список OpenRTB объектов доступных для настройки в сдк</p>



<h5 id="bid-request-object-adcrequest">(Bid Request Object) ADCRequest</h5>

<ul>
<li>app (OpenRTBApp) - объект отвечающий за свойства приложения в котором размещена реклама</li>
<li>user (OpenRTBUser) - объект отвечающий за свойства пользователя приложения</li>
<li>blockedCategories - список заблокированных категорий рекламы для данного приложения</li>
<li>blockedAdvertisers - список заблокированных рекламодателей для данного приложения</li>
</ul>



<h5 id="user-object-openrtbuser">(User Object) OpenRTBUser</h5>

<p>Объект содержащий информацию о пользователе приложения. Может содержать следующие поля: <br>
- userID - идентификатор пользователя <br>
- buyerID - идентификатор покупателя  <br>
- yearOfBirth - год рождения <br>
- gender - пол (строка “M”, “F” или “O”) <br>
- keywords - строка со списком интересов или других ключевых слов для данного польщователя <br>
- customData - любая другая информация о пользователе <br>
- homeGeo (OpenRTBGeo) - информация о местонахождении пользователя</p>



<h5 id="app-object-openrtbapp">(App Object) OpenRTBApp</h5>

<p>Информация о приложении для которого запрашивается реклама. Часть полей заполняется автоматически (bundle, version). Остальные могут быть настроены: <br>
- appID - идентификатор приложения на рекламной бирже <br>
- name -  название приложения <br>
- domain - домен приложения <br>
- categories - список категорий к которым можно отнести всё приложение <br>
- sectionCategories - список категорий к которым можно отнести текущий раздел приложения <br>
- pageCategories - список категорий к которым можно отнести текущий экран/страницу приложения <br>
- privacyPolicy - содержит ли приложение политику конфиденциальности (1 или 0) <br>
- paid - индикатор платного приложения (1 или 0) <br>
- publisher (OpenRTBPublisher) - издатель приложения <br>
- content (OpenRTBContent) - информация о контенте приложения <br>
- keywords - строка со списком ключевых слов к приложению <br>
- storeURL - ссылка на приложение в AppStore</p>



<h5 id="publisher-object-openrtbpublisher">(Publisher Object) OpenRTBPublisher</h5>

<p>Объект содержащий информацию об издателе приложения. Может содержать следующие свойства: <br>
- publisherID - идентификатор издателя <br>
- name - название издателя <br>
- categories - список категорий контента для данного издателя <br>
- domain - домен верхнего уровня издателя (например foopub.com)</p>



<h5 id="content-object-openrtbcontent">(Content Object) OpenRTBContent</h5>

<p>Объект содержащий информацию о контенте приложения. Могут быть заполнены только те поля которые применимы к текущему контенту. Доступны следующие поля: <br>
- contentID - идентификатор контента <br>
- episode - название эпизода <br>
- title - название контента <br>
- series - название серии контента <br>
- season - название сезона контента <br>
- url - ссылка на контент в вебе <br>
- categoriesOfContent - список категорий контента <br>
- quality - качество контента (OpenRTBVideoQuality) <br>
- keywords - ключевые слова <br>
- context - тип контента (видео, игра и т.д. Список доступен в OpenRTBContentContext) <br>
- isLiveStream - индикатор прямой трансляции (1 или 0) <br>
- producer (OpenRTBProducer) - издатель контента <br>
- length - длительность в секундах <br>
- language - язык контента</p>



<h5 id="producer-object-openrtbproducer">(Producer Object) OpenRTBProducer</h5>

<p>Информация о продюсере контента приложения. Доступны следующие поля: <br>
- producerID - идентифкатор продюсера <br>
- name - название продюсера <br>
- categories - список характерных категорий <br>
- domain - url продюсера контента </p>



<h5 id="geo-object-openrtbgeo">(Geo Object) OpenRTBGeo</h5>

<p>Информация о местоположении. Объект данного типа настраивает только для объекта OpenRTBUser. В этом случае указывается “регион интересов” пользователя независимо от его местоположения в данный момент. Например пользователь мог указать в профиле свой город, но находиться в данный момент в другом. <br>
- lat, lon - географические координаты пользователя <br>
- country, region, city - страна, регион, город <br>
- metro - станция метро <br>
- zip - почтовый код <br>
- type - источник информации о местоположении (OpenRTBGeoLocationType)</p>



<h5 id="banner-object-adcbannerview-adcinterstitialviewcontroller">(Banner Object) ADCBannerView / ADCInterstitialViewController</h5>

<p>Описание баннерного места. Доступны для настройки следующие поля: <br>
- position - позиция размещения баннера (OpenRTBAdPosition) <br>
- blockedCreativeAttributes - список заблокированных атрибутов (OpenRTBBannerCreativeAttribute) <br>
- expandableDirection - список направлений в которых баннер может “разворачиваться” (OpenRTBExpandableDirection)</p>



<h5 id="пример-настройки-баннерного-запроса">Пример настройки баннерного запроса</h5>



<pre class="prettyprint"><code class="language-{.objectivec} hljs avrasm">ADCBannerView *bannerView = [[ADCBannerView alloc] initWithFrame:CGRectMake(<span class="hljs-number">0</span>, <span class="hljs-number">0</span>, [UIScreen mainScreen]<span class="hljs-preprocessor">.bounds</span><span class="hljs-preprocessor">.size</span><span class="hljs-preprocessor">.width</span>, <span class="hljs-number">50</span>)]<span class="hljs-comment">;</span>
bannerView<span class="hljs-preprocessor">.placementID</span> = self<span class="hljs-preprocessor">.placement</span><span class="hljs-comment">;</span>
bannerView<span class="hljs-preprocessor">.blockedCreativeAttributes</span> = @[@(OpenRTBBannerCreativeAttributeSurveys), @(OpenRTBBannerCreativeAttributeProvocative)]<span class="hljs-comment">;</span>
bannerView<span class="hljs-preprocessor">.position</span> = @(OpenRTBAdPositionFooter)<span class="hljs-comment">;</span>
bannerView<span class="hljs-preprocessor">.expandableDirections</span> = @[@(OpenRTBExpandableDirectionUp)]<span class="hljs-comment">;</span></code></pre>



<h4 id="полноэкранные-баннеры-interstitial">Полноэкранные баннеры (Interstitial)</h4>

<p>Для показа полноэкранной рекламы необходимо воспользоваться классом ADCInterstitialViewController <br>
<code>.h файл</code></p>



<pre class="prettyprint"><code class=" hljs css"><span class="hljs-at_rule">@<span class="hljs-keyword">interface</span> MyController </span>{
    <span class="hljs-tag">ADCInterstitialViewController</span> *<span class="hljs-tag">interstitialController</span>;
}</code></pre>

<p><code>.m файл</code></p>



<pre class="prettyprint"><code class="language-{.objectivec} hljs cs">    <span class="hljs-comment">// создаём рекламный объект</span>
    interstitialController = [[ADCInterstitialViewController alloc] init];
    <span class="hljs-comment">// указываем placementID полученный в административном разделе</span>
    interstitialController.placementID = <span class="hljs-string">@"myplacement"</span>;
    <span class="hljs-comment">// указываем класс реализующий ADCInterstitialViewControllerDelegate</span>
    interstitialController.<span class="hljs-keyword">delegate</span> = self;
    <span class="hljs-comment">// запускаем рекламный запрос</span>
    [interstitialController start];
    <span class="hljs-comment">// либо </span>
    <span class="hljs-comment">// [interstitialController startWithRequest:request];</span>
    <span class="hljs-comment">// где request - объект ADCRequest созданный аналогично примеру с баннерной рекламой</span></code></pre>

<p>Реклама может быть отображена в любой момент после её получения в методе</p>



<pre class="prettyprint"><code class="language-{.objectivec} hljs objectivec">- (<span class="hljs-keyword">void</span>)interstitialControllerDidReceiveAd:(ADCInterstitialViewController *)interstitial {
    <span class="hljs-comment">// запускаем показ полноэкранной рекламы</span>
    [interstitial presentFromRootViewController:<span class="hljs-keyword">self</span>];
}</code></pre>



<h4 id="передача-параметров-в-баннер">Передача параметров в баннер</h4>

<p>В случае если вам необходимо передать некоторые данные для обработки в баннер - вы можете сделать это при запросе баннерной рекламы</p>

<ul>
<li>в случае inline баннера ADCBannerView</li>
</ul>



<pre class="prettyprint"><code class="language-{.objectivec} hljs avrasm">ADCBannerView *bannerView = [[ADCBannerView alloc] initWithFrame:CGRectMake(<span class="hljs-number">0</span>, <span class="hljs-number">0</span>, width, height)]
bannerView<span class="hljs-preprocessor">.creativeParams</span> = @{@<span class="hljs-string">"name"</span>:@<span class="hljs-string">"John"</span>, @<span class="hljs-string">"param2"</span>:@<span class="hljs-string">"value2"</span>}<span class="hljs-comment">;</span></code></pre>

<ul>
<li>в случае полноэкранного баннера ADCInterstitialViewController</li>
</ul>



<pre class="prettyprint"><code class="language-{.objectivec} hljs avrasm">   interstitialController = [[ADCInterstitialViewController alloc] init]<span class="hljs-comment">;</span>
   interstitialController<span class="hljs-preprocessor">.creativeParams</span> = @{@<span class="hljs-string">"param1"</span>:@<span class="hljs-string">"value1"</span>, @<span class="hljs-string">"param2"</span>:@<span class="hljs-string">"value2"</span>}<span class="hljs-comment">;</span></code></pre></div></body>
</html>
