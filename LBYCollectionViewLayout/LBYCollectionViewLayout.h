//
//  LBYCollectionViewLayout.h
//  Test
//
//  Created by 叶晓倩 on 2018/1/24.
//  Copyright © 2018年 xa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBYCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) BOOL fixedSpacing;        // default NO
@property (nonatomic) CGSize itemSize;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;  // default is UICollectionViewScrollDirectionVertical;

@end
