(function () {
    var isIOS = (/iphone|ipad|ipod/i).test(window.navigator.userAgent.toLowerCase());
    if (isIOS) {
        console = {};
        console.log = function (log) {
            var iframe = document.createElement('iframe');
            iframe.setAttribute('src', 'ios-log: ' + log);
            document.documentElement.appendChild(iframe);
            iframe.parentNode.removeChild(iframe);
            iframe = null;
        };
        console.debug = console.info = console.warn = console.error = console.log;
    }
}());

(function () {
    // Establish the root mraidbridge object.
    var mraidbridge = window.mraidbridge = {};

    // Listeners for bridge events.
    var listeners = {};

    // Queue to track pending calls to the native SDK.
    var nativeCallQueue = [];

    // Whether a native call is currently in progress.
    var nativeCallInFlight = false;

    //////////////////////////////////////////////////////////////////////////////////////////////////

    mraidbridge.fireReadyEvent = function () {
        mraidbridge.fireEvent('ready');
    };

    mraidbridge.fireSizeChangeEvent = function (width, height) {
        mraidbridge.fireEvent('sizeChange', width, height);
    };

    mraidbridge.fireViewableChangeEvent = function () {
        mraidbridge.fireEvent('viewableChange');
    };

    mraidbridge.fireChangeEvent = function (properties) {
        mraidbridge.fireEvent('change', properties);
    };

    mraidbridge.fireErrorEvent = function (message, action) {
        mraidbridge.fireEvent('error', message, action);
    };

    mraidbridge.fireEvent = function (type) {
        var ls = listeners[type];
        if (ls) {
            var args = Array.prototype.slice.call(arguments);
            args.shift();
            var l = ls.length;
            for (var i = 0; i < l; i++) {
                ls[i].apply(null, args);
            }
        }
    };

    mraidbridge.nativeCallComplete = function (command) {
        if (nativeCallQueue.length === 0) {
            nativeCallInFlight = false;
            return;
        }

        var nextCall = nativeCallQueue.pop();
        console.log('mraidbridge.executeNativeCall; window.location = ' + nextCall);
//        window.location = nextCall;
        mraidbridge.nativeCallExecutor(nextCall);
    };
 
     mraidbridge.nativeCallExecutor = function(call) {
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", call);
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
     };

    mraidbridge.executeNativeCall = function (command) {
        var call = 'mraid://' + command;

        var key, value;
        var isFirstArgument = true;

        for (var i = 1; i < arguments.length; i += 2) {
            key = arguments[i];
            value = arguments[i + 1];

            if (value === null) continue;

            if (isFirstArgument) {
                call += '?';
                isFirstArgument = false;
            } else {
                call += '&';
            }

            call += encodeURIComponent(key) + '=' + encodeURIComponent(value);
        }

        if (nativeCallInFlight) {
            console.log('mraidbridge.executeNativeCall; push ' + call);
            nativeCallQueue.push(call);
        } else {
            console.log('mraidbridge.executeNativeCall; window.location = ' + call);
            nativeCallInFlight = true;
            mraidbridge.nativeCallExecutor(call);
//            window.location = call;
        }
    };

    //////////////////////////////////////////////////////////////////////////////////////////////////

    mraidbridge.addEventListener = function (event, listener) {
        var eventListeners;
        listeners[event] = listeners[event] || [];
        eventListeners = listeners[event];

        for (var l in eventListeners) {
            // Listener already registered, so no need to add it.
            if (listener === l) return;
        }

        eventListeners.push(listener);
    };

    mraidbridge.removeEventListener = function (event, listener) {
        if (listeners.hasOwnProperty(event)) {
            var eventListeners = listeners[event];
            if (eventListeners) {
                var idx = eventListeners.indexOf(listener);
                if (idx !== -1) {
                    eventListeners.splice(idx, 1);
                }
            }
        }
    };
}());

(function () {
    var mraid = window.mraid = {};
    var bridge = window.mraidbridge;

    // Constants. ////////////////////////////////////////////////////////////////////////////////////

    var VERSION = mraid.VERSION = '2.0';

    var STATES = mraid.STATES = {
        LOADING: 'loading',     // Initial state.
        DEFAULT: 'default',
        EXPANDED: 'expanded',
        RESIZED: 'resized',
        HIDDEN: 'hidden'
    };

    var EVENTS = mraid.EVENTS = {
        ERROR: 'error',
        INFO: 'info',
        READY: 'ready',
        STATECHANGE: 'stateChange',
        VIEWABLECHANGE: 'viewableChange',
        SIZECHANGE: 'sizeChange'
    };

    var PLACEMENT_TYPES = mraid.PLACEMENT_TYPES = {
        UNKNOWN: 'unknown',
        INLINE: 'inline',
        INTERSTITIAL: 'interstitial'
    };

    var RESIZE_PROPERTIES_CUSTOM_CLOSE_POSITION = mraid.RESIZE_PROPERTIES_CUSTOM_CLOSE_POSITION = {
        TOP_LEFT: 'top-left',
        TOP_RIGHT: 'top-right',
        CENTER: 'center',
        BOTTOM_LEFT: 'bottom-left',
        BOTTOM_RIGHT: 'bottom-right'
    };

    var ORIENTATION_PROPERTIES_FORCE_ORIENTATION = mraid.ORIENTATION_PROPERTIES_FORCE_ORIENTATION = {
        PORTRAIT: 'portrait',
        LANDSCAPE: 'landscape',
        NONE: 'none'
    };

    // External MRAID state: may be directly or indirectly modified by the ad JS. ////////////////////

    var orientationProperties = {
        allowOrientationChange: true,
        forceOrientation: ORIENTATION_PROPERTIES_FORCE_ORIENTATION.NONE
    };

    var resizeProperties = {
        width: 0,
        height: 0,
        customClosePosition: RESIZE_PROPERTIES_CUSTOM_CLOSE_POSITION.TOP_RIGHT,
        offsetX: 0,
        offsetY: 0,
        allowOffscreen: false
    };

    var expandProperties = {
        width: 0,
        height: 0,
        useCustomClose: false,
        isModal: true,
    };

    var hasSetCustomSize = false;

    var hasSetCustomClose = false;

    var listeners = {};

    // Internal MRAID state. Modified by the native SDK. /////////////////////////////////////////////

    var state = STATES.LOADING;

    var isViewable = false;

    var screenSize = { width: -1, height: -1 };

    var placementType = PLACEMENT_TYPES.UNKNOWN;

    var supports = {
        sms: false,
        tel: false,
        calendar: false,
        storePicture: false,
        inlineVideo: false
    };

    //////////////////////////////////////////////////////////////////////////////////////////////////

    var EventListeners = function (event) {
        this.event = event;
        this.count = 0;
        var listeners = {};

        this.add = function (func) {
            var id = String(func);
            if (!listeners[id]) {
                listeners[id] = func;
                this.count++;
            }
        };

        this.remove = function (func) {
            var id = String(func);
            if (listeners[id]) {
                listeners[id] = null;
                delete listeners[id];
                this.count--;
                return true;
            } else {
                return false;
            }
        };

        this.removeAll = function () {
            for (var id in listeners) {
                if (listeners.hasOwnProperty(id)) this.remove(listeners[id]);
            }
        };

        this.broadcast = function (args) {
            for (var id in listeners) {
                if (listeners.hasOwnProperty(id)) listeners[id].apply({}, args);
            }
        };

        this.toString = function () {
            var out = [event, ':'];
            for (var id in listeners) {
                if (listeners.hasOwnProperty(id)) out.push('|', id, '|');
            }
            return out.join('');
        };
    };

    var broadcastEvent = function () {
        var args = new Array(arguments.length);
        var l = arguments.length;
        for (var i = 0; i < l; i++) args[i] = arguments[i];
        var event = args.shift();
//        console.log('broadcast ' + args);
        if (listeners[event]) listeners[event].broadcast(args);
    };

    var contains = function (value, array) {
        for (var i in array) {
            if (array[i] === value) return true;
        }
        return false;
    };

    var clone = function (obj) {
        if (obj === null) return null;
        var f = function () {
        };
        f.prototype = obj;
        return new f();
    };

    var stringify = function (obj) {
        if (typeof obj === 'object') {
            var out = [];
            if (obj.push) {
                // Array.
                for (var p in obj) out.push(obj[p]);
                return '[' + out.join(',') + ']';
            } else {
                // Other object.
                for (var p in obj) {
                    var val = obj[p]
                    if (typeof val == 'number')
                        out.push("\"" + p + "\": " + val);
                    else
                        out.push("\"" + p + "\": \"" + val + "\"");
                }
                return '{' + out.join(',') + '}';
            }
        } else return String(obj);
    };

    var trim = function (str) {
        return str.replace(/^\s+|\s+$/g, '');
    };

    // Functions that will be invoked by the native SDK whenever a "change" event occurs.
    var changeHandlers = {
        state: function (val) {
            if (state === STATES.LOADING) {
                broadcastEvent(EVENTS.INFO, 'Native SDK initialized.');
            }
            state = val;
            broadcastEvent(EVENTS.INFO, 'Set state to ' + stringify(val));
            broadcastEvent(EVENTS.STATECHANGE, state);
        },

        viewable: function (val) {
            isViewable = val;
            console.log('set is viewable ' + isViewable);
            broadcastEvent(EVENTS.INFO, 'Set isViewable to ' + stringify(val));
            broadcastEvent(EVENTS.VIEWABLECHANGE, isViewable);
        },

        placementType: function (val) {
            broadcastEvent(EVENTS.INFO, 'Set placementType to ' + stringify(val));
            placementType = val;
        },

        screenSize: function (val) {
            broadcastEvent(EVENTS.INFO, 'Set screenSize to ' + stringify(val));
            for (var key in val) {
                if (val.hasOwnProperty(key)) screenSize[key] = val[key];
            }

            if (!hasSetCustomSize) {
                expandProperties['width'] = screenSize['width'];
                expandProperties['height'] = screenSize['height'];
            }
        },

        expandProperties: function (val) {
            broadcastEvent(EVENTS.INFO, 'Merging expandProperties with ' + stringify(val));
            for (var key in val) {
                if (val.hasOwnProperty(key)) expandProperties[key] = val[key];
            }
        },

        supports: function (val) {
            broadcastEvent(EVENTS.INFO, 'Set supports to ' + stringify(val));
            supports = val;
        },
    };

    var validate = function (obj, validators, action, merge) {
        if (!merge) {
            // Check to see if any required properties are missing.
            if (obj === null) {
                broadcastEvent(EVENTS.ERROR, 'Required object not provided.', action);
                return false;
            } else {
                for (var i in validators) {
                    if (validators.hasOwnProperty(i) && obj[i] === undefined) {
                        broadcastEvent(EVENTS.ERROR, 'Object is missing required property: ' + i + '.', action);
                        return false;
                    }
                }
            }
        }

        for (var prop in obj) {
            var validator = validators[prop];
            var value = obj[prop];
            if (validator && !validator(value)) {
                // Failed validation.
                broadcastEvent(EVENTS.ERROR, 'Value of property ' + prop + ' is invalid.',
                    action);
                return false;
            }
        }
        return true;
    };

    var expandPropertyValidators = {
        width: function (v) {
            return !isNaN(v) && v >= 0;
        },
        height: function (v) {
            return !isNaN(v) && v >= 0;
        },
        useCustomClose: function (v) {
            return (typeof v === 'boolean');
        },
        lockOrientation: function (v) {
            return (typeof v === 'boolean');
        }
    };

    //////////////////////////////////////////////////////////////////////////////////////////////////

    bridge.addEventListener('change', function (properties) {
        for (var p in properties) {
            if (properties.hasOwnProperty(p)) {
                var handler = changeHandlers[p];
                handler(properties[p]);
            }
        }
    });

    bridge.addEventListener('error', function (message, action) {
        broadcastEvent(EVENTS.ERROR, message, action);
    });

    bridge.addEventListener('ready', function () {
        broadcastEvent(EVENTS.READY);
    });
    bridge.addEventListener('sizeChange', function (width, height) {
        broadcastEvent(EVENTS.SIZECHANGE, width, height);
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////

    //  
    mraid.returnInfo = function (call) {
        var info = '';
        var result = call();
        for (property in result) {
            if (info) {
                info += '&';
            }
            info += encodeURIComponent(property) + '=' + encodeURIComponent(result[property]);
        }
        return info;
    };

    mraid.addEventListener = function (event, listener) {
        if (!event || !listener) {
            broadcastEvent(EVENTS.ERROR, 'Both event and listener are required.', 'addEventListener');
        } else if (!contains(event, EVENTS)) {
            broadcastEvent(EVENTS.ERROR, 'Unknown MRAID event: ' + event, 'addEventListener');
        } else {
            if (!listeners[event]) listeners[event] = new EventListeners(event);
            listeners[event].add(listener);
        }
    };

    mraid.close = function () {
        if (state === STATES.HIDDEN) {
            broadcastEvent(EVENTS.ERROR, 'Ad cannot be closed when it is already hidden.',
                'close');
        } else bridge.executeNativeCall('close');
    };

    mraid.expand = function (URL) {
        console.log('mraid.expand; State: ' + mraid.getState());
        if ((this.getState() !== STATES.DEFAULT) && (this.getState() !== STATES.RESIZED)) {
            broadcastEvent(EVENTS.ERROR, 'Ad can only be expanded from the default and resized state.', 'expand');
        } else {
            var args = ['expand'];

            if (this.getHasSetCustomClose()) {
                args = args.concat(['shouldUseCustomClose', expandProperties.useCustomClose ? 'true' : 'false']);
            }

            if (this.getHasSetCustomSize()) {
                if (expandProperties.width >= 0 && expandProperties.height >= 0) {
                    args = args.concat(['w', expandProperties.width, 'h', expandProperties.height]);
                }
            }

            if (typeof expandProperties.lockOrientation !== 'undefined') {
                args = args.concat(['lockOrientation', expandProperties.lockOrientation]);
            }

            if (URL) {
                args = args.concat(['url', URL]);
            }

            bridge.executeNativeCall.apply(this, args);
        }
    };

    mraid.getHasSetCustomClose = function () {
        return hasSetCustomClose;
    };

    mraid.getHasSetCustomSize = function () {
        return hasSetCustomSize;
    };

    mraid.getExpandProperties = function () {
        var properties = {
            width: expandProperties.width,
            height: expandProperties.height,
            useCustomClose: expandProperties.useCustomClose,
            isModal: expandProperties.isModal
        };
        console.log("getExpandProperties" + stringify(properties));
        return properties;
    };

    mraid.getResizeProperties = function () {
        console.log("getResizeProperties" + stringify(resizeProperties));
        return resizeProperties;
    };

 mraid.getOrientationProperties = function() {
    console.log('getOrientationProperties');
    return orientationProperties;
 };

    mraid.getPlacementType = function () {
        console.log('mraid.getPlacementType returns ' + placementType);
        return placementType;
    };

    mraid.getState = function () {
        return state;
    };

    mraid.getVersion = function () {
        return mraid.VERSION;
    };

    mraid.isViewable = function () {
        console.log('mraid.isViewable returns ' + isViewable);
        return isViewable;
    };

    mraid.open = function (URL) {
        if (!URL) broadcastEvent(EVENTS.ERROR, 'URL is required.', 'open');
        else bridge.executeNativeCall('open', 'url', URL);
    };

    mraid.removeEventListener = function (event, listener) {
        if (!event) broadcastEvent(EVENTS.ERROR, 'Event is required.', 'removeEventListener');
        else {
            if (listener && (!listeners[event] || !listeners[event].remove(listener))) {
                broadcastEvent(EVENTS.ERROR, 'Listener not currently registered for event.',
                    'removeEventListener');
                return;
            } else if (listeners[event]) listeners[event].removeAll();

            if (listeners[event] && listeners[event].count === 0) {
                listeners[event] = null;
                delete listeners[event];
            }
        }
    };

    mraid.setExpandProperties = function (properties) {
        console.log('setExpandProperties');

        var writableFields = ["width", "height", "useCustomClose"];

        for (wf in writableFields) {
            var field = writableFields[wf];
            if (properties[field] !== undefined) {
                expandProperties[field] = properties[field];
            }
        }
        console.log("expandProperties now " + stringify(expandProperties));

        bridge.executeNativeCall('setExpandProperties', 'expandProperties', stringify(expandProperties));
    };

    mraid.useCustomClose = function (shouldUseCustomClose) {
        expandProperties.useCustomClose = shouldUseCustomClose;
        hasSetCustomClose = true;
        bridge.executeNativeCall('usecustomclose', 'shouldUseCustomClose', shouldUseCustomClose);
    };

    // MRAID 2.0 APIs ////////////////////////////////////////////////////////////////////////////////

    mraid.createCalendarEvent = function (parameters) {
        CalendarEventParser.initialize(parameters);
        if (CalendarEventParser.parse()) {
            bridge.executeNativeCall.apply(this, CalendarEventParser.arguments);
        } else {
            broadcastEvent(EVENTS.ERROR, CalendarEventParser.errors[0], 'createCalendarEvent');
        }
    };

    mraid.supports = function (feature) {
        return supports[feature];
    };

    mraid.playVideo = function (uri) {
        if (!mraid.isViewable()) {
            broadcastEvent(EVENTS.ERROR, 'playVideo cannot be called until the ad is viewable', 'playVideo');
            return;
        }

        if (!uri) {
            broadcastEvent(EVENTS.ERROR, 'playVideo must be called with a valid URI', 'playVideo');
        } else {
            bridge.executeNativeCall.apply(this, ['playVideo', 'uri', uri]);
        }
    };

    mraid.storePicture = function (uri) {
        if (!mraid.isViewable()) {
            broadcastEvent(EVENTS.ERROR, 'storePicture cannot be called until the ad is viewable', 'storePicture');
            return;
        }

        if (!uri) {
            broadcastEvent(EVENTS.ERROR, 'storePicture must be called with a valid URI', 'storePicture');
        } else {
            bridge.executeNativeCall.apply(this, ['storePicture', 'uri', uri]);
        }
    };

    mraid.resize = function () {
        bridge.executeNativeCall('resize');
    };

    mraid.setResizeProperties = function (properties) {
        console.log("setResizeProperties");
        var writableFields = ["width", "height", "customClosePosition", "offsetX", "offsetY", "allowOffscreen"];
        for (wf in writableFields) {
            var field = writableFields[wf];
            if (properties[field] !== undefined) {
                resizeProperties[field] = properties[field];
            }
        }
        console.log("resizeProperties now " + stringify(resizeProperties));
        bridge.executeNativeCall('setResizeProperties', 'resizeProperties', stringify(resizeProperties));
    };

    mraid.setOrientationProperties = function (properties) {
        console.log('setOrientationProperties');
        var writableFields = ["allowOrientationChange", "forceOrientation"];

        for (wf in writableFields) {
            var field = writableFields[wf];
            if (properties[field] !== undefined) {
                orientationProperties[field] = properties[field];
            }
        }
        bridge.executeNativeCall('setOrientationProperties', 'orientationProperties', stringify(orientationProperties));
    };

    /// size & position

    var currentPosition = {
        x: 0,
        y: 0,
        width: 0,
        height: 0
    };

    var maxSize = {
        width: 0,
        height: 0
    };

    var defaultPosition = {
        x: 0,
        y: 0,
        width: 0,
        height: 0
    };

    var screenSize = {
        width: 0,
        height: 0
    };

    var currentOrientation = 0;

    //  
    mraid.setCurrentPosition = function (position) {
//        console.log('setCurrentPosition begin' + position);
        var previousSize = mraid.getSize();
        currentPosition = position;
//        console.log('setCurrentPosition ' + position + ' ' + currentPosition);
        var currentSize = mraid.getSize();

        // Only send the size changed event if the size in the position
        // was different from the previous position
        if ((previousSize.width === currentSize.width) && (previousSize.height === currentSize.height)) {
            return;
        }

        mraid.fireSizeChangeEvent(currentPosition.width, currentPosition.height);
    };

    // MRAID
    mraid.getCurrentPosition = function () {
        console.log("getCurrentPosition" + stringify(currentPosition));
        return currentPosition;
    };

    // MRAID v1
    mraid.getSize = function () {
        console.log("getSize");

        var size =
        {
            width: currentPosition.width,
            height: currentPosition.height
        };

        return size;
    };

    //  
    mraid.setMaxSize = function (size) {
        maxSize = size;
        console.log("maxSize now" + stringify(maxSize));
    };

    // MRAID
    mraid.getMaxSize = function () {
        console.log("getMaxSize" + stringify(maxSize));

        return maxSize;
    };

    //  
    mraid.setDefaultPosition = function (position) {
        defaultPosition = position;
    };

    // MRAID
    mraid.getDefaultPosition = function () {
        console.log("getDefaultPosition" + stringify(defaultPosition));
        return defaultPosition;
    };

    //  
    mraid.setScreenSize = function (size) {
        screenSize = size;
        console.log("screenSize now" + stringify(screenSize));
    };

    // MRAID
    mraid.getScreenSize = function () {
        console.log("getScreenSize" + stringify(screenSize));

        return screenSize;
    };

    //  
    mraid.setOrientation = function (orientation) {
        currentOrientation = orientation;
    };

    var CalendarEventParser = {
        initialize: function (parameters) {
            this.parameters = parameters;
            this.errors = [];
            this.arguments = ['createCalendarEvent'];
        },

        parse: function () {
            if (!this.parameters) {
                this.errors.push('The object passed to createCalendarEvent cannot be null.');
            } else {
                this.parseDescription();
                this.parseLocation();
                this.parseSummary();
                this.parseStartAndEndDates();
                this.parseReminder();
                this.parseRecurrence();
                this.parseTransparency();
            }

            var errorCount = this.errors.length;
            if (errorCount) {
                this.arguments.length = 0;
            }

            return (errorCount === 0);
        },

        parseDescription: function () {
            this._processStringValue('description');
        },

        parseLocation: function () {
            this._processStringValue('location');
        },

        parseSummary: function () {
            this._processStringValue('summary');
        },

        parseStartAndEndDates: function () {
            this._processDateValue('start');
            this._processDateValue('end');
        },

        parseReminder: function () {
            var reminder = this._getParameter('reminder');
            if (!reminder) {
                return;
            }

            if (reminder < 0) {
                this.arguments.push('relativeReminder');
                this.arguments.push(parseInt(reminder) / 1000);
            } else {
                this.arguments.push('absoluteReminder');
                this.arguments.push(reminder);
            }
        },

        parseRecurrence: function () {
            var recurrenceDict = this._getParameter('recurrence');
            if (!recurrenceDict) {
                return;
            }

            this.parseRecurrenceInterval(recurrenceDict);
            this.parseRecurrenceFrequency(recurrenceDict);
            this.parseRecurrenceEndDate(recurrenceDict);
            this.parseRecurrenceArrayValue(recurrenceDict, 'daysInWeek');
            this.parseRecurrenceArrayValue(recurrenceDict, 'daysInMonth');
            this.parseRecurrenceArrayValue(recurrenceDict, 'daysInYear');
            this.parseRecurrenceArrayValue(recurrenceDict, 'monthsInYear');
        },

        parseTransparency: function () {
            var validValues = ['opaque', 'transparent'];

            if (this.parameters.hasOwnProperty('transparency')) {
                var transparency = this.parameters['transparency'];
                if (contains(transparency, validValues)) {
                    this.arguments.push('transparency');
                    this.arguments.push(transparency);
                } else {
                    this.errors.push('transparency must be opaque or transparent');
                }
            }
        },

        parseRecurrenceArrayValue: function (recurrenceDict, kind) {
            if (recurrenceDict.hasOwnProperty(kind)) {
                var array = recurrenceDict[kind];
                if (!array || !(array instanceof Array)) {
                    this.errors.push(kind + ' must be an array.');
                } else {
                    var arrayStr = array.join(',');
                    this.arguments.push(kind);
                    this.arguments.push(arrayStr);
                }
            }
        },

        parseRecurrenceInterval: function (recurrenceDict) {
            if (recurrenceDict.hasOwnProperty('interval')) {
                var interval = recurrenceDict['interval'];
                if (!interval) {
                    this.errors.push('Recurrence interval cannot be null.');
                } else {
                    this.arguments.push('interval');
                    this.arguments.push(interval);
                }
            } else {
                // If a recurrence rule was specified without an interval, use a default value of 1.
                this.arguments.push('interval');
                this.arguments.push(1);
            }
        },

        parseRecurrenceFrequency: function (recurrenceDict) {
            if (recurrenceDict.hasOwnProperty('frequency')) {
                var frequency = recurrenceDict['frequency'];
                var validFrequencies = ['daily', 'weekly', 'monthly', 'yearly'];
                if (contains(frequency, validFrequencies)) {
                    this.arguments.push('frequency');
                    this.arguments.push(frequency);
                } else {
                    this.errors.push('Recurrence frequency must be one of: "daily", "weekly", "monthly", "yearly".');
                }
            }
        },

        parseRecurrenceEndDate: function (recurrenceDict) {
            var expires = recurrenceDict['expires'];

            if (!expires) {
                return;
            }

            this.arguments.push('expires');
            this.arguments.push(expires);
        },

        _getParameter: function (key) {
            if (this.parameters.hasOwnProperty(key)) {
                return this.parameters[key];
            }

            return null;
        },

        _processStringValue: function (kind) {
            if (this.parameters.hasOwnProperty(kind)) {
                var value = this.parameters[kind];
                this.arguments.push(kind);
                this.arguments.push(value);
            }
        },

        _processDateValue: function (kind) {
            if (this.parameters.hasOwnProperty(kind)) {
                var dateString = this._getParameter(kind);
                this.arguments.push(kind);
                this.arguments.push(dateString);
            }
        },
    };
}());