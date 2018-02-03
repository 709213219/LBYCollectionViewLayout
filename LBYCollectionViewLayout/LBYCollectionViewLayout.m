//
//  LBYCollectionViewLayout.m
//  Test
//
//  Created by 叶晓倩 on 2018/1/24.
//  Copyright © 2018年 xa. All rights reserved.
//

#import "LBYCollectionViewLayout.h"

static CGFloat itemSpacing  = 10;
static CGFloat lineSpacing  = 10;

@interface LBYCollectionViewLayout()
{
    int _row;
    int _line;
}

@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation LBYCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerReferenceSize = CGSizeZero;
        self.footerReferenceSize = CGSizeZero;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.attributes = [NSMutableArray new];
        self.fixedSpacing = NO;
    }
    return self;
}

// 每次collectionView reloadData都会调用
- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    
    CGFloat contentWidth = (width - self.sectionInset.left - self.sectionInset.right);
    CGFloat contentHeight = (height - self.sectionInset.top - self.sectionInset.bottom);
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (contentWidth >= (2 * itemWidth + self.minimumInteritemSpacing)) { // 列数大于两行
            int m = (contentWidth - itemWidth) / (itemWidth + self.minimumInteritemSpacing);
            _line = m + 1;
            itemSpacing = self.minimumInteritemSpacing;
        } else { // 列数为一行
            itemSpacing = 0;
        }
        
        if (contentHeight >= (2 * itemHeight + self.minimumLineSpacing)) { // 行数大于两行
            int m = (contentHeight - itemHeight) / (itemHeight + self.minimumLineSpacing);
            _row = m + 1;
            if (self.fixedSpacing) {
                lineSpacing = self.minimumLineSpacing;
            } else {
                lineSpacing = (contentHeight - _row * itemHeight) / m;
            }
        } else { // 行数为一行
            lineSpacing = 0;
        }
    } else {
        if (contentWidth >= (2 * itemWidth + self.minimumLineSpacing)) { // 列数大于两行
            int m = (contentWidth - itemWidth) / (itemWidth + self.minimumLineSpacing);
            _row = m + 1;
            if (self.fixedSpacing) {
                lineSpacing = self.minimumLineSpacing;
            } else {
                lineSpacing = (contentWidth - _row * itemWidth) / m;
            }
        } else { // 列数为一行
            lineSpacing = 0;
        }
        
        if (contentHeight >= (2 * itemHeight + self.minimumInteritemSpacing)) { // 行数大于两行
            int m = (contentHeight - itemHeight) / (itemHeight + self.minimumInteritemSpacing);
            _line = m + 1;
            itemSpacing = self.minimumInteritemSpacing;
        } else { // 行数为一行
            itemSpacing = 0;
        }
    }
}

// 返回collectionView内容的尺寸
- (CGSize)collectionViewContentSize {
    NSInteger number = _row * _line;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat width = 0;
        for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
            NSInteger iNumber = [self.collectionView numberOfItemsInSection:i];
            NSInteger n = iNumber / number * _line;
            NSInteger m = (iNumber % number / _line) ? _line : (iNumber % number % _line);
            NSInteger line = n + m;
            width += ((line * (_itemSize.width + itemSpacing)) - itemSpacing) + self.sectionInset.left + self.sectionInset.right;
        }
        
        width += (self.headerReferenceSize.width + self.footerReferenceSize.width);
        
        return CGSizeMake(width, self.collectionView.bounds.size.height);
    } else {
        CGFloat height = 0;
        for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
            NSInteger iNumber = [self.collectionView numberOfItemsInSection:i];
            NSInteger n = iNumber / number * _line;
            NSInteger m = (iNumber % number / _line) ? _line : (iNumber % number % _line);
            NSInteger line = n + m;
            height += ((line * (_itemSize.height + itemSpacing)) - itemSpacing) + self.sectionInset.left + self.sectionInset.right;
            
        }
        
        height += (self.headerReferenceSize.height + self.footerReferenceSize.height);
        
        return CGSizeMake(self.collectionView.bounds.size.width, height);
    }
}

// 返回对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame;
    frame.size = self.itemSize;
    
    long number = _row * _line;
    long n = indexPath.row % _line;
    long m = indexPath.row % number / _line;
    long p = indexPath.row / number;
    
    CGFloat x = 0;
    CGFloat y = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat offsetX = 0;
        for (NSInteger i = 0; i < indexPath.section; i++) {
            NSInteger iNumber = [self.collectionView numberOfItemsInSection:i];
            NSInteger iN = iNumber / number * _line;
            NSInteger iM = (iNumber % number / _line) ? _line : (iNumber % number % _line);
            NSInteger iLine = iN + iM;
            offsetX += ((iLine * (_itemSize.width + itemSpacing) - itemSpacing) + self.sectionInset.left + self.sectionInset.right);
        }
        
        x = (n + p * _line) * (self.itemSize.width + itemSpacing) + self.sectionInset.left + offsetX + self.headerReferenceSize.width;
        y = m * self.itemSize.height + m * lineSpacing + self.sectionInset.top;
    } else {
        CGFloat offsetY = 0;
        for (NSInteger i = 0; i < indexPath.section; i++) {
            NSInteger iNumber = [self.collectionView numberOfItemsInSection:i];
            NSInteger iN = iNumber / number * _line;
            NSInteger iM = (iNumber % number / _line) ? _line : (iNumber % number % _line);
            NSInteger iLine = iN + iM;
            offsetY += ((iLine * (_itemSize.height + itemSpacing) - itemSpacing) + self.sectionInset.top + self.sectionInset.bottom);
        }
        
        x = m * self.itemSize.width + m * lineSpacing + self.sectionInset.left;
        y = (n + p * _line) * (self.itemSize.height + itemSpacing) + self.sectionInset.top + offsetY + self.headerReferenceSize.height;
    }
    
    frame.origin = CGPointMake(x, y);
    
    attribute.frame = frame;
    return attribute;
}

// 返回所有元素的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    self.attributes = tmpAttributes;
    return self.attributes;
}

// 该方法用来决定是否需要更新布局，如果CollectionView需要重新布局返回YES，否则返回NO，默认返回值为NO。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

@end
