//
//  IndexableImageView.m
//  Cranberry
//
//  Created by Nicolas Pinilla on 2/11/15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "IndexableImageView.h"


@implementation IndexableImageView

- (id)initWithImage:(UIImage *)image andAssetURL:(NSURL *)assetURL andIndex:(NSNumber *) index{
    self = [super init];
    self.image = image;
    self.assetURL = assetURL;
    self.index = index;
    self.selected = FALSE;
    return self;
}

- (id)initWithUrl:(NSURL *)urlImage andImageInfo:(NSMutableDictionary *)imageInfo{
    self = [super init];
    self.assetURL = urlImage;
    self.imageInfo = imageInfo;
    self.selected = FALSE;
    return self;
}

@end
