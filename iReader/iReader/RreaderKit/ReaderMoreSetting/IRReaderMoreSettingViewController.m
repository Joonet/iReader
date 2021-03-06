//
//  IRReaderMoreSettingViewController.m
//  iReader
//
//  Created by zzyong on 2018/9/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderMoreSettingViewController.h"
#import "IRSettingModel.h"
#import "IRSettingSectionModel.h"
#import "IRTextSettingCell.h"
#import "IRPagingTypeSelectViewController.h"

@interface IRReaderMoreSettingViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRSettingModel *> *settingInfos;

@end

@implementation IRReaderMoreSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInit];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.settingInfos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    IRSettingSectionModel *sectionModel = [self.settingInfos safeObjectAtIndex:section];
    return sectionModel.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRSettingSectionModel *sectionModel = [self.settingInfos safeObjectAtIndex:indexPath.section];
    IRSettingModel *settingModel = [sectionModel.items safeObjectAtIndex:indexPath.row];
    if (settingModel.cellType == IRSettingCellTypeText) {
        IRTextSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRTextSettingCell" forIndexPath:indexPath];
        cell.settingModel = settingModel;
        return cell;
    } else {
        return  [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        return header;
    } else {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRSettingSectionModel *sectionModel = [self.settingInfos safeObjectAtIndex:indexPath.section];
    IRSettingModel *settingModel = [sectionModel.items safeObjectAtIndex:indexPath.row];
    if (settingModel.clickedHandler) {
        settingModel.clickedHandler();
    }
}

#pragma mark - DataSource

- (void)setupSettingInfos
{
    __weak typeof(self) weakSelf = self;
    
    IRSettingSectionModel *commonSection = [[IRSettingSectionModel alloc] init];
    IRSettingModel *pagingType = [[IRSettingModel alloc] init];
    pagingType.title = @"翻页方式";
    if (IR_READER_CONFIG.transitionStyle == IRPageTransitionStyleScroll) {
        pagingType.rightText = @"简约 >";
    } else {
        pagingType.rightText = @"仿真 >";
    }
    
    pagingType.cellType = IRSettingCellTypeText;
    pagingType.clickedHandler = ^{
        [weakSelf onPagingTypeCellClicked];
    };
    
    commonSection.items = @[pagingType];
    
    self.settingInfos = @[commonSection];
    
    [self.collectionView reloadData];
}

- (void)onPagingTypeCellClicked
{
    IRPagingTypeSelectViewController *vc = [[IRPagingTypeSelectViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.selectHandler = ^(IRPageTransitionStyle type) {
        [weakSelf handleTransitionStyleChangedWithType:type];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)commonInit
{
    self.title = @"更多设置";
    [self setupSettingInfos];
    [self setupLeftBackBarButton];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.backgroundColor      = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[IRTextSettingCell class] forCellWithReuseIdentifier:@"IRTextSettingCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"defaultCell"];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"header"];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:@"footer"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)handleTransitionStyleChangedWithType:(IRPageTransitionStyle)transitionStyle
{
    IR_READER_CONFIG.transitionStyle = transitionStyle;
    [self setupSettingInfos];
    
    if ([self.delegate respondsToSelector:@selector(readerMoreSettingViewControllerDidChangedTransitionStyle:)]) {
        [self.delegate readerMoreSettingViewControllerDidChangedTransitionStyle:transitionStyle];
    }
}

@end
