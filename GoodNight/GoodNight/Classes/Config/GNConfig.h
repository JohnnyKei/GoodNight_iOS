//
//  GDConfig.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#ifndef GoodNight_GNConfig_h
#define GoodNight_GNConfig_h


#define GOOGLE_MAPS_KEY @"AIzaSyBilOw8Mrbis2sfoa0Ytj72ey1s078pxbo"
#define UBER_CLIENT_ID @"GbfmuB28FCNIPfbeMrz9Wqk1cQcPqz91"
#define UBER_SECRET_KEY @"Obgg3JQJdJG9Rx1Xujyks42XKUj-ZiNUtuU_Ex8u"
#define UBER_REDIRECT_URL @"https://goodnight.herokuapp.com/"
#define UBER_ACCESS_TOKEN @"UBER_ACCESS_TOKEN"
#define UBER_REFLESH_TOKEN @"UBER_REFLESH_TOKEN"

#define UBER_BASE_API @"https://api.uber.com"
#define UBER_BASE_SANDBOX_API @"ttps://sandbox-api.uber.com"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif


#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



#endif
