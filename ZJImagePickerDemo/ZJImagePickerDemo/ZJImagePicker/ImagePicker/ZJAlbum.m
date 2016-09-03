//
//  ZJAlbum.m
//  ZJImagePickerDemo
//
//  Created by 郑佳 on 15/1/25.
//  Copyright © 2015年 Triangle. All rights reserved.
//

#import "ZJAlbum.h"

#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

@implementation ZJAsset

- (UIImage *)thumbImage{
    //在ios9上，用thumbnail方法取得的缩略图显示出来不清晰，所以用aspectRatioThumbnail
    if (IOS9_OR_LATER) {
        return [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    } else {
        return [UIImage imageWithCGImage:[self.asset thumbnail]];
    }
    
}

- (UIImage *)originImage{
    UIImage *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    return image;
}

@end

@implementation ZJAlbum

- (ZJAsset *)assetWithIndex:(NSInteger)index{
    
    if (index >= _assets.count || index < 0) {
        return nil;
    }
    return _assets[index];
}
- (NSUInteger)indexWithAsset:(ZJAsset *)asset{

    return [_assets indexOfObject:asset];
}

@end
