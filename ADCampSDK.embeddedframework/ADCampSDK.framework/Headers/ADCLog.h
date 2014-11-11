//
//  ADCLog.h
//  adcampsdk
//
//  Created by Mikhail on 06.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#ifndef visdk_ADCLog_h
#define visdk_ADCLog_h

#include <stdio.h>
#include <sys/time.h>

typedef NS_OPTIONS(NSInteger, ADCLogLevel) {
	ADCLogOff		= 0,
	ADCLogFatal		= 1 << 0,
	ADCLogError		= 1 << 1,
	ADCLogWarn		= 1 << 2,
	ADCLogDebug		= 1 << 3,
	ADCLogVerbose	= 1 << 4
};

extern ADCLogLevel adcloglevel;

//#ifdef DEBUG
//
//#define ADCLog(type, fmt, ...)      {\
//								struct timeval tim;\
//								struct timezone tzp;\
//								gettimeofday(&tim, &tzp);\
//								time_t rawtime;\
//								struct tm * timeinfo;\
//								time ( &rawtime );\
//								timeinfo = localtime ( &rawtime );\
//								NSString* mainString = [NSString stringWithFormat:fmt, ##__VA_ARGS__];\
//								NSString* newBody = [mainString stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t\t"];\
//								const char* body = [newBody UTF8String];\
//								float seconds = timeinfo->tm_sec + tim.tv_usec / 1000000.0;\
//								/*printf("%02d:%02d:%06.3f l:%3d |<%s> %s (%s)\n", timeinfo->tm_hour, timeinfo->tm_min, seconds, __LINE__, [type UTF8String], body, __PRETTY_FUNCTION__);\*/ \
//                                printf("%02d:%02d:%06.3f l:%3d |<%s> %s\n", timeinfo->tm_hour, timeinfo->tm_min, seconds, __LINE__, [type UTF8String], body);\
//							}
//
//#else

#define ADCLog(type, fmt, ...) {\
								NSString* mainString = [NSString stringWithFormat:fmt, ##__VA_ARGS__];\
								NSString* newBody = [mainString stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t\t"];\
								NSLog(@"<%@> %@ (%s)", type, newBody, __PRETTY_FUNCTION__);\
}

//#endif

#define ADCLogF(fmt, ...)     if (adcloglevel & ADCLogFatal) { ADCLog(@"fatal", fmt, ##__VA_ARGS__); }
#define ADCLogE(fmt, ...)     if (adcloglevel & ADCLogError) { ADCLog(@"error", fmt, ##__VA_ARGS__); }
#define ADCLogW(fmt, ...)     if (adcloglevel & ADCLogWarn) { ADCLog(@"warn ", fmt, ##__VA_ARGS__); }
#define ADCLogD(fmt, ...)     if (adcloglevel & ADCLogDebug) { ADCLog(@"debug", fmt, ##__VA_ARGS__); }
#define ADCLogV(fmt, ...)     if (adcloglevel & ADCLogVerbose) { ADCLog(@"verbose", fmt, ##__VA_ARGS__); }

#endif
