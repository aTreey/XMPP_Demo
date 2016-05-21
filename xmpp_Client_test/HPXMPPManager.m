//
//  HPXMPPManager.m
//  xmpp_Client_test
//
//  Created by Apeng on 16/5/21.
//  Copyright © 2016年 Apeng. All rights reserved.
//

#import "HPXMPPManager.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPLogging.h"


@interface HPXMPPManager ()<XMPPStreamDelegate>
@property (nonatomic, copy)NSString *password;
@end

@implementation HPXMPPManager
static HPXMPPManager *_sharmanager;

+ (instancetype)sharedXMPPManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharmanager = [[self alloc] init];
        
        // 打印日志
        [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    });
    return _sharmanager;
}

- (XMPPStream *)xmppStream {
    
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        
        // 绑定主机名和端口号
        _xmppStream.hostName = @"127.0.0.1";
        _xmppStream.hostPort = 5222;
        
        // 原来的点语法中是一对一的代理
        // 实时监听动态时, 使用通知, NSTimer 定时器, 效率低,
        // 使用socket 来实现, 发过来我就能知道
        // delegate获取状态 多播代理, 添加好几个代理
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}

//login
- (void)loginWithJID:(XMPPJID *)jid password:(NSString *)password {
    
    
//    If the hostName or myJID are not set, this method will return NO and set the error parameter. 需要设置myJID
    // 设置用户账号
    [self.xmppStream setMyJID:jid];
    self.password = password;
    
    //登录之前需要联网
    [self.xmppStream connectWithTimeout:-1 error:0];
    
}

#pragma mark -- XMPPStream的代理方法
// 链接到服务器的时候调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSLog(@"链接完毕");
    
    // 链接完毕后授权登录
    [self.xmppStream authenticateWithPassword:self.password error:nil];
}

// 授权成功后调用
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    NSLog(@"__授权成功后调用_");
    
    XMPPPresence *presence = [XMPPPresence presence];
    
    
    // 更改出席状态: 只能在非聊天状态下更改
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"dnd"]];
    [presence addChild:[DDXMLElement elementWithName:@"status" stringValue:@"¥55¥¥¥"]];
    
    [self.xmppStream sendElement:presence];
}

@end
