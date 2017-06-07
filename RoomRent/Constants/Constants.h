//
//  Constants.h
//  RoomRent
//
//  Created by Prashant Sah on 4/5/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NAME_TEXTFIELD = 1,
    MOBILE_TEXTFIELD = 2,
    USERNAME_TEXTFIELD = 3,
    EMAIL_ADDRESS_TEXTFIELD = 4,
    PASSWORD_TEXTFIELD = 5,
    ROOMS_TEXTFIELD = 6,
    PRICE_TEXTFIELD = 7

} textFieldType;

static NSString *BASE_URL = @"http://192.168.0.143:81/api/v1/";

static NSString *OFFER = @"1";
static NSString *REQUEST = @"2";

static NSString *DEVICE_TYPE = @"1";
static NSString *DEVICE_TOKEN = @"faVINfpTooo:APA91bETPN5L4UjfJ6q3UiOxWT2dHrMMJpeOU0SyDJi4mVRHqDkMT4gjXD4-wYhXThyRcQVv2GXkbxShcQw2khnSRvJLhfHCRaZ2VADZegydkDbmM31iFX-2XrxHL6ggMZq_t8JpfrWv";

static NSString *USER_DATA_KEY = @"user_data_key";

// DEFAULT MESSAGES
static NSString *ERROR_OCCURED = @"0000";
static NSString *SUCCESS = @"0001";

// LOGIN MESSAGES
static NSString *LOGIN_SUCCESS = @"0011";
static NSString *LOGIN_FAILED = @"0012";

// REGISTRATION MESSAGES
static NSString *USER_REGISTERED = @"0013";
static NSString *VALIDATION_ERRORS = @"0014";
static NSString *EMAIL_VERIFIED = @"0015";

//LOGOUT MESSAGE
static NSString *USER_LOGGED_OUT = @"0020";

// PROFILE UPDATE MESSAGE
static NSString *PASSWORD_RESET_LINK_SENT = @"0023";
static NSString *PROFILE_UPDATED_SUCCESSFULLY = @"0026";
static NSString *UNABLE_TO_UPDATE_PROFILE = @"0027";

// POSTS MESSAGES
static NSString *NO_POSTS_FOUND = @"0071";
static NSString *POSTS_FOUND = @"0072";
static NSString *ITEM_POSTED_SUCCESSFULLY = @"0073";
static NSString *ITEM_UPDATED_SUCCESSFULLY = @"0075";
static NSString *ITEM_DELETED_SUCCESSFULLY =@"0077";

//FILE HANDLING
static NSString *IMAGE_UPLOADED_SUCCESSFULLY = @"0064";

