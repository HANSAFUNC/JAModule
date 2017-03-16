//
//  GuideViewController.m
//  JKHeaderImageScale
//
//  Created by jackey_gjt on 17/2/22.
//  Copyright © 2017年 Jackey. All rights reserved.
//

#import "GuideViewController.h"
#import "JAHeaderViewController.h"
#import "JA_UCViewController.h"
#import "ClipCornerController.h"
static NSString * const ID = @"kTestCell";
@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
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
            cell.textLabel.text = @"贝尔赛斯-圆(50.092)/3000次";
            break;
        case 3:
            cell.textLabel.text = @"DrawRect-圆(Draw裁剪用时：49.859 秒)/3000次";
            break;
        case 4:
            cell.textLabel.text = @"算法裁剪-圆(算法裁剪用时：71.106 秒)/3000次";
            break;
            
        default:
            cell.textLabel.text = @"by:JA_健滔";
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.navigationController
             pushViewController:[JAHeaderViewController new] animated:YES];
            break;
        case 1:
            [self presentViewController:[JA_UCViewController new] animated:YES completion:nil];
            break;
        case 2:
            [self.navigationController pushViewController:[[ClipCornerController alloc] initWithClipCornerType:ClipCornerTypeBezier] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[[ClipCornerController alloc] initWithClipCornerType:ClipCornerTypeDraw]animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[[ClipCornerController alloc] initWithClipCornerType:ClipCornerTypeCustom] animated:YES];
            break;
        default:
            break;
    }
}
@end
