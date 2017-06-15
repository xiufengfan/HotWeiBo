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
#import "XFFAccountDao.h"
#import "UIImageView+WebCache.h"
#import "XFFStatus.h"
#import "XFFUser.h"
#import "MJExtension.h"
#import "XFFHomeStatusResult.h"
#import "MJRefresh.h"
#import "XFFLoadMoreFooter.h"
#import "XFFNavHUD.h"
#import "XFFTableViewCell.h"
#import "XFFStatusFrame.h"
#import "XFFStatusService.h"
#import "XFFStatusRequest.h"
#import "XFFAccountService.h"
#import "XFFAccountRequest.h"
@interface XFFHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *statusFrames;
@property(nonatomic,weak)UITableView *tableView;
@end

@implementation XFFHomeViewController

-(NSMutableArray*)statusFrames
{
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
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
    tableView.backgroundColor = [UIColor grayColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)setupUserInfo
{
    XFFAccount *account = [XFFAccountDao account];
    
    XFFAccountRequest *params = [[XFFAccountRequest alloc]init];
    XFFLog(@"%@",account.access_token);
    params.access_token = account.access_token;
    params.uid = account.uid;
    
    [XFFAccountService accountWithParams:params success:^(XFFUser *result) {
        
        XFFTitleButton *titleBtn = (XFFTitleButton*)self.navigationItem.titleView;
        [titleBtn setTitle:result.name forState:(UIControlStateNormal)];
        
        if([account.name isEqualToString:result.name]) return ;
        account.name = result.name;
        account.profile_image_url = result.profile_image_url;
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
    self.tabBarController.tabBarItem.badgeValue = nil;
    
    XFFStatusFrame *statusFrame = [self.statusFrames firstObject];
    XFFStatus *status = statusFrame.status;
    
    XFFStatusRequest *params = [[XFFStatusRequest alloc]init];
    params.access_token = [XFFAccountDao account].access_token;
//    XFFLog(@"%@",[XFFAccountDao account].access_token);
    if(status){
        params.since_id = @([[status idstr] longLongValue]);
    }
    params.count = @(20);
   
    [XFFStatusService statusWithParams:params success:^(XFFHomeStatusResult *result) {
        NSArray *frameModels = [self frameModelsWithStatus:result.statuses];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,frameModels.count)];
        [self.statusFrames insertObjects: frameModels atIndexes:set];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self showNewStatusCount:result.statuses.count];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重试"];
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  根据模型数组转换frame模型数组
 *
 *  @param statuses 模型数组
 *
 *  @return frame模型数组
 */
- (NSArray *)frameModelsWithStatus:(NSArray *)statuses
{
    // 通过数据模型创建frame模型
    NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:statuses.count];
    for (XFFStatus *status in statuses) {
        XFFStatusFrame *frame = [[XFFStatusFrame alloc] init];
        frame.status = status;
        [frameModels addObject:frame];
    }
    return [frameModels copy];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XFFTableViewCell *cell = [XFFTableViewCell cellWithTableView:tableView];
    XFFStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    cell.statusFrame = statusFrame;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XFFStatusFrame * frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
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
    if(self.statusFrames.count == 0 || self.tableView.tableFooterView.hidden == NO) return;
    
    // 临界值 = 内容height + bottom - 屏幕高度
    CGFloat judgeY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if(scrollView.contentOffset.y >= judgeY){
        self.tableView.tableFooterView.hidden = NO;
        
        [self loadMoreStatus];
    }
}

-(void)loadMoreStatus
{
    XFFStatusFrame *statusFrame = [self.statusFrames lastObject];
    XFFStatus *status = statusFrame.status;
    
    XFFStatusRequest *params = [[XFFStatusRequest alloc]init];
    params.access_token = [XFFAccountDao account].access_token;
    if(status){
        params.max_id = @([[status idstr] longLongValue] - 1);
    }
    params.count = @(20);
    [XFFStatusService statusWithParams:params success:^(XFFHomeStatusResult *result) {
        NSArray *frameModels = [self frameModelsWithStatus:result.statuses];
        [self.statusFrames addObjectsFromArray:frameModels];
        [self.tableView reloadData];
        // [self showNewStatusCount:result.statuses.count];
        //  self.tableView.tableFooterView.hidden = YES;
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        //  self.tableView.tableFooterView.hidden = YES;
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
