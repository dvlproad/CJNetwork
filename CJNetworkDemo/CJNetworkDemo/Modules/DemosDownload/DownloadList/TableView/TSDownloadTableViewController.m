//
//  TSDownloadTableViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "TSDownloadTableViewController.h"
#import "TSDownloadTableViewCell.h"
#import <CQDemoKit/CQTSLocImagesUtil.h>

@interface TSDownloadTableViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, strong) NSArray<CQTSLocImageDataModel *> *downloadModles;

@end


@implementation TSDownloadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"断点续传", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllFiles)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"TSDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[TSDownloadTableViewCell class] forCellReuseIdentifier:@"cell"];

    //NSArray<NSString *> *imageExtensions = @[@"png", @"jpg", @"gif", @"webp", @"svg"];
    NSArray<NSString *> *videoExtensions = @[@"mp4", @"mov"];
    self.downloadModles = [CQTSLocImagesUtil fileModelsWithExtensions:videoExtensions count:10 randomOrder:NO changeImageNameToNetworkUrl:YES];
}

- (void)deleteAllFiles {
    [[HSDownloadManager sharedInstance] deleteAllFile];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.downloadModles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    CQTSLocImageDataModel *downloadModel = [self.downloadModles objectAtIndex:indexPath.row];
    cell.downloadView.downloadUrl = downloadModel.imageName;
    cell.downloadView.downloadUrlLabel.text = downloadModel.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath = %ld %ld", indexPath.section, indexPath.row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
