//
//  Constants.h
//  RoomRent
//
//  Created by Prashant Sah on 4/5/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
    NAME_TEXTFIELD = 1,
    MOBILE_TEXTFIELD = 2,
    USERNAME_TEXTFIELD = 3,
    EMAIL_ADDRESS_TEXTFIELD = 4,
    PASSWORD_TEXTFIELD = 5
};

static NSString *PUSP_BASE_URL = @"http://192.168.0.143:81/api/v1/";
static NSString *PUSP_FILE_URL = @"http://192.168.0.143:81/api/v1/getfile/";
static NSString *BASE_URL = @"http://192.168.0.157:81/api/";
//static NSString *API_TOKEN = @"OD44GCYFpHYHcwYFTG1QsQBGPOLcHjk8OMOMPkd3Ew3RTaLX0ox2ES3UASxE";

//static NSString *API_TOKEN = @"OD44GCYFpHYHcwYFTG1QsQBGPOLcHjk8OMOMPkd3Ew3RTaLX0ox2ES3UASxE";

static NSString *USER_API_TOKEN;
static NSString *DEVICE_TYPE = @"1";
static NSString *DEVICE_TOKEN = @"kdsfjd";

static NSString *LOGIN_SUCCESS = @"0011";

static NSString *USER_REGISTERED = @"0013";
static NSString *USER_LOGGED_OUT = @"0020";
