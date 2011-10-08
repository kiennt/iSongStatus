//
//  UserSettings.h
//  FB_Music
//
//  Created by kiennt on 10/4/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserSettings : NSObject {}
+ (NSString *) getAccessToken;
+ (void) setAccessToken:(NSString *)token;

+ (NSDate *) getExpirationDate;
+ (void) setExpirationDate:(NSDate *)date;

+ (BOOL) isUpdateStatus;
+ (void) setUpdateStatus:(BOOL) value;

+ (BOOL) isUseOnePost;
+ (void) setUseOnePost:(BOOL) value;
@end
