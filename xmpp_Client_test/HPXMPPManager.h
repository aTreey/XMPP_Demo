//
//  HPXMPPManager.h
//  xmpp_Client_test
//
//  Created by Apeng on 16/5/21.
//  Copyright © 2016年 Apeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPXMPPManager : NSObject

// 使用单例模式
+ (instancetype)sharedXMPPManager;

// login
- (void)loginWithJID:(XMPPJID *)jid password:(NSString *)password;

// XMPPStream
@property (nonatomic, strong)XMPPStream *xmppStream;

@end
