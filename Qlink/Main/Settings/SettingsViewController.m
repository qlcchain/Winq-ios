//
//  MoreViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "ChooseCurrencyViewController.h"
#import "ResetPWViewController.h"
#import "PasswordManagementViewController.h"
#import "WalletsManageViewController.h"
#import "JoinCommunityViewController.h"
#import "WebViewController.h"
#import "UserModel.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation SettingsViewController

NSString *title0 = @"Password Management";
NSString *title1 = @"Currency Unit";
NSString *title2 = @"My Wallet";
NSString *title3 = @"Service Agreement";
NSString *title4 = @"Help and Feedback";
NSString *title5 = @"Join the Community";
NSString *title6 = @"About WINQ";
NSString *title7 = @"Log out";

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyChang:) name:Currency_Change_Noti object:nil];
}

#pragma mark - Life Cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self addObserve];
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:SettingsCellReuse bundle:nil] forCellReuseIdentifier:SettingsCellReuse];
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    NSArray *titleArr = @[title0,title1,title2,title3,title4,title5,title6,title7];
    kWeakSelf(self);
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SettingsShowModel *model = [[SettingsShowModel alloc] init];
        model.title = obj;
        model.haveNextPage = YES;
        model.detail = [obj isEqualToString:title1]?[ConfigUtil getLocalUsingCurrency]:[obj isEqualToString:title6]?[NSString stringWithFormat:@"Version %@(%@)",APP_Version,APP_Build]:nil;
        [weakself.sourceArr addObject:model];
    }];
    [_mainTable reloadData];
}

- (void)refreshDataWithTitle:(NSString *)title detail:(NSString *)detail {
//    kWeakSelf(self);
    [_sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SettingsShowModel *model = obj;
        if ([model.title isEqualToString:title]) {
            model.detail = detail;
            *stop = YES;
        }
    }];
    [_mainTable reloadData];
}

- (void)logout {
    UserModel *userM = [UserModel fetchUserOfLogin];
    userM.isLogin = @(NO);
    [UserModel storeUser:userM];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:User_Logout_Noti object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SettingsCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingsShowModel *model = _sourceArr[indexPath.row];
    if ([model.title isEqualToString:title0]) {
        [self jumpToPWManagement];
    } else if ([model.title isEqualToString:title1]) {
        [self jumpToChooseCurrency];
    } else if ([model.title isEqualToString:title2]) {
        [self jumpToWalletsManage];
    } else if ([model.title isEqualToString:title3]) {
        NSString *url = @"https://winq.net/disclaimer.html";
        [self jumpToWeb:url title:title3];
    } else if ([model.title isEqualToString:title5]) {
        [self jumpToJoinCommunity];
    } else if ([model.title isEqualToString:title7]) {
        [self logout];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingsCellReuse];
    
    SettingsShowModel *model = _sourceArr[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToChooseCurrency {
    ChooseCurrencyViewController *vc = [[ChooseCurrencyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToPWManagement {
    PasswordManagementViewController *vc = [[PasswordManagementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToWalletsManage {
    WalletsManageViewController *vc = [[WalletsManageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToJoinCommunity {
    JoinCommunityViewController *vc = [[JoinCommunityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToWeb:(NSString *)url title:(NSString *)title {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = url;
    vc.inputTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Noti
- (void)currencyChang:(NSNotification *)noti {
    [self refreshDataWithTitle:title1 detail:[ConfigUtil getLocalUsingCurrency]];
}

@end
