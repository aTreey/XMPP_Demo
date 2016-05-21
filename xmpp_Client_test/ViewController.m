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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // login
    [[HPXMPPManager sharedXMPPManager] loginWithJID:[XMPPJID jidWithUser:@"zhang2" domain:@"itheima.cn" resource:nil] password:@"2"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
