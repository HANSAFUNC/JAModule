//
//  JA_UCViewController.m
//  JKHeaderImageScale
//
//  Created by jackey_gjt on 17/2/22.
//  Copyright © 2017年 Jackey. All rights reserved.
//

#import "JA_UCViewController.h"
#import "UIScrollView+ScaleImage.h"
static NSString * const ID = @"kTestCell";
@interface JA_UCViewController ()

@end

@implementation JA_UCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.isNavgation = NO;
    [self.tableView ja_pullRefreshUC_Header:CGRectMake(0, -200, [UIScreen mainScreen].bounds.size.width,200)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"下拉放大";
            break;
        case 1:
            cell.textLabel.text = @"UC下拉";
            break;
        case 2:
            cell.textLabel.text = @"算法圆";
            break;
        case 3:
            cell.textLabel.text = @"by:JA_健滔";
            break;
            
        default:
            cell.textLabel.text = @"by:JA_健滔";
            break;
    }
    
    return cell;
}


@end
