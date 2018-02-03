//
//  ViewController.m
//  LBYCollectionViewLayout
//
//  Created by 叶晓倩 on 2018/2/3.
//  Copyright © 2018年 bill. All rights reserved.
//

#import "ViewController.h"
#import "LBYCollectionViewLayout.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < 100 + i * 10 + 3; j++) {
            [array addObject:[NSString stringWithFormat:@"%i:%i", i, j]];
        }
        [_dataSource addObject:array];
    }
    
    LBYCollectionViewLayout *layout = [[LBYCollectionViewLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(60, 60);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.fixedSpacing = NO;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"lbycollectionviewcell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lbycollectionviewcell" forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:0x100];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        label.tag = 0x100;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:label];
    }
    
    label.text = _dataSource[indexPath.section][indexPath.row];
    
    return cell;
}

@end
