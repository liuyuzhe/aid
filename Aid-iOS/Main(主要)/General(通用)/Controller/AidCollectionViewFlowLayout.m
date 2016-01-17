//
//  AidCollectionViewFlowLayout.m
//  Aid-iOS
//
//  Created by 刘育哲 on 15/12/30.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "AidCollectionViewFlowLayout.h"

@implementation AidCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.minimumInteritemSpacing = 0; // 设定全局的Cell间距
    self.minimumLineSpacing = 0; // 设定全局的行间距
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); // 设置组内边距
    if (self.collectionView.bounds.size.height) {
        self.itemSize = self.collectionView.bounds.size; // item大小
    }
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向滑动
}

@end
