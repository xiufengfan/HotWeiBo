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
#import "AFNetworking.h"
#import "XFFAccountDao.h"
#import "UIImageView+WebCache.h"
#import "XFFStatus.h"
#import "XFFUser.h"
#import "MJExtension.h"
#import "XFFHomeStatusResult.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "XFFLoadMoreFooter.h"
@interface XFFHomeViewController ()
@property(nonatomic,strong)NSMutableArray *statuses;
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
    
//    [self loadStatus];
    
    [self setupRefresh];
}

-(void)setupRefresh
{
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView addSubview:control];
    
    [control beginRefreshing];
    [self refreshControlStateChange:control];
    
    self.tableView.tableFooterView = [XFFLoadMoreFooter footer];
    self.tableView.tableFooterView.hidden = YES;
}

-(void)refreshControlStateChange:(UIRefreshControl*)control{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFFAccountDao account].access_token;
    if(self.statuses.count){
            params[@"since_id"] = [[self.statuses firstObject] idstr];
    }
    
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        XFFHomeStatusResult *result = [XFFHomeStatusResult mj_objectWithKeyValues:responseObject];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.statuses.count)];
        [self.statuses insertObjects: result.statuses atIndexes:set];
        
        [self.tableView reloadData];
        
        [control endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络繁忙，请重试"];
        [control endRefreshing];
    }];
    
}


-(void)setupNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationbar_pop" highlightedImage:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationbar_friendsearch" highlightedImage:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
    
    XFFTitleButton *titleBtn  = [[XFFTitleButton alloc]init];
    [titleBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:(UIControlStateNormal)];
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.titleView = titleBtn;
}

-(void)loadStatus{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFFAccountDao account].access_token;
    
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        XFFHomeStatusResult *result = [XFFHomeStatusResult mj_objectWithKeyValues:responseObject];
        [self.statuses addObjectsFromArray:result.statuses];
        
        [result.statuses.mj_keyValues writeToFile:@"/Users/mac/Desktop/status.plist" atomically:YES];
        
//        NSArray *newStatus = [XFFStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//        
//        [self.statuses addObjectsFromArray:newStatus];
        
//        for (NSDictionary *dict in responseObject[@"statuses"]) {
//            XFFStatus *status = [XFFStatus mj_objectWithKeyValues:dict];
//            [self.statuses addObject:status];
//        }
//        
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

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

// 检测偏移量
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.statuses.count == 0) return;
    // 临界值 = 内容height + bottom - 屏幕高度
    CGFloat judgeY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height;
    if(scrollView.contentOffset.y >= judgeY){
        self.tableView.tableFooterView.hidden = NO;
    }
}

@end
