//
//  ImagesShowView.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/8.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "ImagesShowView.h"
#import "CollectionShowCell.h"
#import "THThumbnail.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define CELL @"cell"

@interface ImagesShowView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

//缓存数据的通用数据
@property (nonatomic, strong) NSMutableArray *showArr;
@property (nonatomic, strong) UIView *backView;
@end

@implementation ImagesShowView
- (NSMutableArray *)showArr {
    if (!_showArr) {
        _showArr = [NSMutableArray array];
    }
    return _showArr;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
        
        flowLayout.itemSize = CGSizeMake(100, 100);//全局配置item的大小，后便可以通过代理分别配置
        
        
        flowLayout.minimumLineSpacing = 2;//决定每行与行之间的间距
        flowLayout.minimumInteritemSpacing = 20;//决定列与列之间的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200) collectionViewLayout:flowLayout];
        _collectionView.allowsMultipleSelection = YES;//是否允许多选，在开启多选模式，也就意味着可以一个模块都不选，如果设置为NO，那就意味着如果选中了一个，那么这个将不能被取消
        _collectionView.alwaysBounceVertical = YES;//纵向滑动到一端的时候是否有弹簧效果
        _collectionView.alwaysBounceHorizontal = NO;//横向华东到一端的时候是否有弹簧效果
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[CollectionShowCell class] forCellWithReuseIdentifier:CELL];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

- (void)createSubViews {
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.showArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionShowCell *cell;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];

    if (indexPath.row < self.showArr.count) {
       THThumbnail *thum = self.showArr[indexPath.row];
        UIImage *image = thum.image;
        [cell reloadImage:image];
    }
    //code
    return cell;
}
//定义item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(kScreenW, 200);
}

//被选中时候的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSLog(@"%ld", row);
    NSMutableArray *arr = self.showArr[indexPath.section];
    [arr addObject:@"5"];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]]];
}

- (void)reloadImages:(NSArray *)arr {
    [self.showArr addObjectsFromArray:arr];
    [self createSubViews];
}

@end