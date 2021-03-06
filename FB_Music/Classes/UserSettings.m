//
//  UserSettings.m
//  FB_Music
//
//  Created by kiennt on 10/4/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

#define ACCESS_TOKEN @"access_token"
#define IS_UPDATE_STATUS @"is_update_status"
#define EXPIRATION_DATE @"expiration_date"
#define IS_USE_ONE_POST @"is_use_one_post"


+ (NSString *) getAccessToken {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	return [pref objectForKey:ACCESS_TOKEN];
}

+ (void) setAccessToken:(NSString *)token {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	[pref setObject:token forKey:ACCESS_TOKEN];
	[pref synchronize];
}

+ (NSDate *) getExpirationDate {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	return [pref objectForKey:EXPIRATION_DATE];
}

+ (void) setExpirationDate:(NSDate *)date {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	[pref setObject:date forKey:EXPIRATION_DATE];
	[pref synchronize];
}

+ (BOOL) isUpdateStatus {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	NSNumber  *ret = (NSNumber *)[pref objectForKey:IS_UPDATE_STATUS];
	if (ret == nil)
		return NO;
	return [ret boolValue];
}

+ (void) setUpdateStatus:(BOOL)value {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	[pref setObject:[NSNumber numberWithBool:value] forKey:IS_UPDATE_STATUS];
	[pref synchronize];
}

+ (BOOL) isUseOnePost {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	NSNumber *ret = (NSNumber *)[pref objectForKey:IS_USE_ONE_POST];
	if (ret == nil)
		return NO;
	return [ret boolValue];
}

+ (void) setUseOnePost:(BOOL)value {
	NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
	[pref setObject:[NSNumber numberWithBool:value] forKey:IS_USE_ONE_POST];
	[pref synchronize];
}
@end

