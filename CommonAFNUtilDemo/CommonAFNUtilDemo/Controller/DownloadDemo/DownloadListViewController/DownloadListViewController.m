//
//  DownloadListViewController.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/31.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "DownloadListViewController.h"
#import "DownloadTableViewCell.h"

@interface DownloadListViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, strong) NSArray *datas;

@end


@implementation DownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.datas = @[@"http://120.25.226.186:32812/resources/videos/minion_01.mp4",
                   @"http://box.9ku.com/download.aspx?from=9ku",
                   @"http://pic6.nipic.com/20100330/4592428_113348097000_2.jpg"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllFiles)];
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
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    cell.downloadUrl = [self.datas objectAtIndex:indexPath.row];
    
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
