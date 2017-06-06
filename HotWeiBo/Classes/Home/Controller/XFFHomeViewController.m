//
//  XFFHomeViewController.m
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFHomeViewController.h"
#import "XFFTitleButton.h"
#import "XFFPopMenu.h"
#import "XFFPopMenuController.h"
#import "XFFNetworking.h"
#import "XFFAccountDao.h"
#import "UIImageView+WebCache.h"
#import "XFFStatus.h"
#import "XFFUser.h"
#import "MJExtension.h"
#import "XFFHomeStatusResult.h"
#import "MJRefresh.h"
#import "XFFLoadMoreFooter.h"
#import "XFFNavHUD.h"


@interface XFFHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *statuses;
@property(nonatomic,weak)UITableView *tableView;
@end

@implementation XFFHomeViewController

-(NSMutableArray*)statuses
{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    
    [self setupTableView];
    
    [self setupRefresh];
    
    // 加载用户信息
    [self setupUserInfo];
}

-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)setupUserInfo
{
    XFFAccount *account = [XFFAccountDao account];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    XFFLog(@"%@",account.access_token);
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [XFFNetworking GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(id responseObject) {
        XFFUser *user = [XFFUser mj_objectWithKeyValues:responseObject];
        
        XFFTitleButton *titleBtn = (XFFTitleButton*)self.navigationItem.titleView;
        [titleBtn setTitle:user.name forState:(UIControlStateNormal)];
        
        if([account.name isEqualToString:user.name]) return ;
        account.name = user.name;
        account.profile_image_url = user.profile_image_url;
        [XFFAccountDao  save:account];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重试"];
    }];
}

-(void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatus)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
}

-(void)loadNewStatus
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFFAccountDao account].access_token;
    if(self.statuses.count){
            params[@"since_id"] = [[self.statuses firstObject] idstr];
    }
    
    [XFFNetworking GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(id responseObject) {
        XFFHomeStatusResult *result = [XFFHomeStatusResult mj_objectWithKeyValues:responseObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.statuses.count)];
        [self.statuses insertObjects: result.statuses atIndexes:set];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self showNewStatusCount:result.statuses.count];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重试"];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)showNewStatusCount:(NSUInteger)count
{
    NSString *title = @"没有新的微博";
    if (count) {
        title = [NSString stringWithFormat:@"更新了%zd条微博",count];
    }
#pragma mark 传入的控制器必须有导航条
    [XFFNavHUD showMessage:title view:self.view];
}

-(void)setupNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationbar_pop" highlightedImage:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationbar_friendsearch" highlightedImage:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
    
    XFFTitleButton *titleBtn  = [[XFFTitleButton alloc]init];
    NSString *name = [XFFAccountDao account].name;
    [titleBtn setTitle:name?name:@"首页" forState:(UIControlStateNormal)];
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:(UIControlStateNormal)];
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.titleView = titleBtn;
}

//-(void)loadStatus{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = [XFFAccountDao account].access_token;
//    
//    [XFFNetworking GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(id responseObject) {
//        XFFHomeStatusResult *result = [XFFHomeStatusResult mj_objectWithKeyValues:responseObject];
//        [self.statuses addObjectsFromArray:result.statuses];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"网络繁忙，请重试"];
//    }];
//}

-(void)titleClick:(XFFTitleButton*)titleBtn
{
    XFFPopMenuController *vc = [[XFFPopMenuController alloc]init];
    vc.view.autoresizingMask = FALSE;
    vc.view.width = 200;
    vc.view.height = 180;
    [XFFPopMenu popMenuFromView:self.navigationItem.titleView contentVc:vc dismiss:^{
        XFFTitleButton *titleBtn = (XFFTitleButton*)self.navigationItem.titleView;
        titleBtn.selected = !titleBtn.isSelected;
    }];
    
    titleBtn.selected = !titleBtn.isSelected;
}

-(void)pop{
    XFFLog(@"pop");
}


-(void)friendsearch{
    XFFLog(@"friendsearch");
    XFFTitleButton *titleBtn = (XFFTitleButton*)self.navigationItem.titleView;
    [titleBtn setTitle:@"哈哈哈哈" forState:(UIControlStateNormal)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"statusesId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }
    
    XFFStatus *status = self.statuses[indexPath.row];
    
    cell.textLabel.text = status.text;
    
    cell.detailTextLabel.text = status.created_at;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 检测偏移量
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.statuses.count == 0 || self.tableView.tableFooterView.hidden == NO) return;
    
    // 临界值 = 内容height + bottom - 屏幕高度
    CGFloat judgeY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if(scrollView.contentOffset.y >= judgeY){
        self.tableView.tableFooterView.hidden = NO;
        
        [self loadMoreStatus];
    }
}

-(void)loadMoreStatus
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFFAccountDao account].access_token;
    if(self.statuses.count){
        params[@"max_id"] = @([[[self.statuses lastObject] idstr] longLongValue] - 1);
    }
    
    [XFFNetworking GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(id responseObject) {
        XFFHomeStatusResult *result = [XFFHomeStatusResult mj_objectWithKeyValues:responseObject];
        [self.statuses addObjectsFromArray:result.statuses];
        [self.tableView reloadData];
//        [self showNewStatusCount:result.statuses.count];
//        self.tableView.tableFooterView.hidden = YES;
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
//        self.tableView.tableFooterView.hidden = YES;
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
