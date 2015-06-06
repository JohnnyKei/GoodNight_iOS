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
#define UBER_CLIENT_ID @"kv2PsG1lgfcJ9IWNCFuzrglOAIZ00Qdx"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif


#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



#endif
