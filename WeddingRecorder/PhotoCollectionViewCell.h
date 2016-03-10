//
//  PhotoCollectionViewCell.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/1.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
@interface PhotoCollectionViewCell : PFCollectionViewCell; //UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *photo;
@property (weak, nonatomic) IBOutlet UIView *photoBackgroundView;

@end
