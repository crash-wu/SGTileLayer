//
//  MainViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/23.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "MainViewController.h"
#import "TdtMapViewController.h"
#import "BDMapViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    if(indexPath.row ==0){
        cell.textLabel.text = @"天地图";
    }else{
        cell.textLabel.text = @"百度地图";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row ==0){
        [self.navigationController pushViewController:[[TdtMapViewController alloc]init] animated:true];
    }else{
        
        [self.navigationController pushViewController:[[BDMapViewController alloc] init] animated:true];
    }
}


@end
