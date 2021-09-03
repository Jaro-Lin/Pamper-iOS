//
//  thirdHeader.h
//  magicShop
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 YYB. All rights reserved.
//

#ifndef thirdHeader_h
#define thirdHeader_h


//微信

#define KWeiXinAppID @"wx2eb0de8f8aa5ef8b"
#define KWeiXinAppSecret @"550f35c0fd3c8fbd411262a6f4b27609"
//#define KWeiXinAppID @"wx85c00bd8719e895c"
//#define KWeiXinAppSecret @"fd265f71354643aa55d376c24d7da36c"

//QQ
//#define KQQAppID @"1106420525"
//#define KQQAppSecret @"E2ivF5s0hgPQsuVX"
#define KQQAppID @"1110679344"
#define KQQAppSecret @"BdZ0qSbMgNjuOQma"

//友盟
#define KYouMenKey  @""


//分页条数
#define KLimitCount @"20"

//图片服务器
#define KImageServer [[NSUserDefaults standardUserDefaults]objectForKey:@"KNnddkjPetImageSrever"]
//官方客服微信号
#define KWechatServer [[NSUserDefaults standardUserDefaults]objectForKey:@"KPetSystemWechatCount"]

#endif /* thirdHeader_h */
