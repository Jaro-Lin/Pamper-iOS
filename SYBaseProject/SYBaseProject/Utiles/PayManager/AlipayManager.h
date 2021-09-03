//
//  AlipayManager.h
//  DuoBao
//
//  Created by tanson on 2018/2/1.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayManager : NSObject

+(instancetype) shareManager;

-(BOOL) handleOpenURL:(NSURL*)url;

-(void) payWithSign:(NSString*)sign
             Scheme:(NSString*)scheme
        payCallback:(void (^)(int errCode,NSString *eMsg))payCallback;

@end
