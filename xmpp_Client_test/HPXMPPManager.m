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


@interface HPXMPPManager ()<XMPPStreamDelegate, XMPPReconnectDelegate, XMPPAutoPingDelegate>
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)XMPPReconnect *xmppReconnect;
@property (nonatomic, copy)XMPPAutoPing *xmppAutoping;
@end

/***自动连接模块实现步骤***/
/*
 1, 导入头文件
 2, 创建对象
 3, 设置代理
 4, 需要激活模块
*/

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

// 自动重连
- (XMPPReconnect *)xmppReconnect {
    
    if (!_xmppReconnect) {
        _xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        
        // 自动重连时间
        _xmppReconnect.reconnectTimerInterval = 5.0;
        
        // 添加多播代理
        [_xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppReconnect;
}


// 心跳检测模块
- (XMPPAutoPing *)xmppAutoping {
    
    if (!_xmppAutoping) {
        
        _xmppAutoping = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        
        // 设置ping 的时间
        _xmppAutoping.pingInterval = 3.0;
        
        //pingTimeout 超时
        _xmppAutoping.pingTimeout = 5;
        
        // 设置代理
        [_xmppAutoping addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppAutoping;
}

//login
- (void)loginWithJID:(XMPPJID *)jid password:(NSString *)password {
    
    
//    If the hostName or myJID are not set, this method will return NO and set the error parameter. 需要设置myJID
    // 设置用户账号
    [self.xmppStream setMyJID:jid];
    self.password = password;
    
    //登录之前需要联网
    [self.xmppStream connectWithTimeout:-1 error:0];
    
    // 激活模块,在登录的时候就激活
    [self activateFuncation];
    
}

// 使用stream 来激活自动重连
- (void)activateFuncation {
    
    [self.xmppReconnect activate:self.xmppStream];
    [self.xmppAutoping activate:self.xmppStream];
}

#pragma mark -- XMPPReconnect 代理方法


#pragma mark -- XMPPStream  代理方法
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

// 接收消息后
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    NSLog(@"++接收消息后++");
}

//发送消息后调用
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    
    
    NSLog(@"====发送后====");
}


#pragma mark -- autoPing 代理方法
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender {
    NSLog(@"%s", __func__);
}
- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender {
    NSLog(@"%s", __func__);
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender {
    NSLog(@"%s", __func__);
}

@end
