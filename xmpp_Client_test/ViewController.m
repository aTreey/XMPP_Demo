//
//  ViewController.m
//  xmpp_Client_test
//
//  Created by Apeng on 16/5/21.
//  Copyright © 2016年 Apeng. All rights reserved.
//

#import "ViewController.h"
#import "HPXMPPManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *friendID;
@property (weak, nonatomic) IBOutlet UITextField *message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // login
    [[HPXMPPManager sharedXMPPManager] loginWithJID:[XMPPJID jidWithUser:@"zhang2" domain:@"itheima.cn" resource:nil] password:@"2"];
    
}


- (IBAction)sendMessageBtnDidClick:(id)sender {
    
    // 创建消息对象
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:self.friendID.text domain:@"itheima.cn" resource:nil]];
    
    // 设置消息体
    // body属性是只读, 使用addBody 方法
    [message addBody:self.message.text];
    
    // XMPP 发送
    [[HPXMPPManager sharedXMPPManager].xmppStream sendElement:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
