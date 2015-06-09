//
//  IndexableImageView.h
//  Cranberry
//
//  Created by Nicolas Pinilla on 2/11/15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IndexableImageView : UIImageView

@property (nonatomic, retain) NSURL *assetURL;
@property (nonatomic, retain) NSMutableDictionary *imageInfo;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) NSNumber *index;
@property (nonatomic, retain) UIImage *fullImage;


- (id)initWithImage:(UIImage *)image andAssetURL:(NSURL *)assetURL andIndex:(NSNumber *) index;

- (id)initWithUrl:(NSURL *)urlImage andImageInfo:(NSMutableDictionary *)imageInfo;

@end
