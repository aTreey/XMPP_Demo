//
//  HPContactViewController.m
//  xmpp_Client_test
//
//  Created by Apeng on 16/5/21.
//  Copyright © 2016年 Apeng. All rights reserved.
//

#import "HPContactViewController.h"


@interface HPContactViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *contactDataList;
@end

@implementation HPContactViewController

// 懒加载
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!_fetchedResultsController) {
        // 查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // 实体
        // XMPPUserCoreDataStorageObject: 是实体对象
        // XMPPRosterCoreDataStorage : 数据存储器
        fetchRequest.entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"inManagedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        // 谓词
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subscription = %@", @"both"];
        
        // 排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
        fetchRequest.sortDescriptors = @[sort];
        
        // 创建查询控制器
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"contanctCache"];
        
        // 设置代理
        _fetchedResultsController.delegate = self;
        
    }
    return _fetchedResultsController;
}

#pragma mark --NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    self.contactDataList = self.fetchedResultsController.fetchedObjects;
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1,  根据添加取数据
    // 开始查询数据  performFetch:运行取数据
    [self.fetchedResultsController performFetch:nil];
    
    // 接收查询到的数据
    self.contactDataList = self.fetchedResultsController.fetchedObjects;
    
    // 刷新数据源
    [self.tableView reloadData];
}




// 2, 展示数据
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.contactDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCellID" forIndexPath:indexPath];
    // 获取数据 是实体对象
    XMPPUserCoreDataStorageObject *object = self.contactDataList[indexPath.row];
    
    // 赋值
    UILabel *name = [cell viewWithTag:1002];
    name.text = object.jidStr;
    
    UILabel *nickName = [cell viewWithTag:1003];
    nickName.text = object.nickname;
    
    return cell;
}

#pragma mark - TalbeViewdelegate
// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}




// 懒加载
- (NSArray *)contactDataList {
    
    if (!_contactDataList) {
        _contactDataList = [NSArray array];
    }
    return _contactDataList;
}

@end
