//
//  HorizontalGrid.h
//  casesurfer
//
//  Created by Osvaldo on 26-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol horizontalGridDelegate

- (void)selectHImageWithAssetURL:(UIImage *)image  indexImage:(int) indexImage assetUrl:(NSURL *) assetUrl;

@end

@interface HorizontalGrid : UIScrollView

@property (nonatomic, retain) id <horizontalGridDelegate> gridDelegate;

@property (nonatomic, retain) NSNumber *columns;
@property (nonatomic, retain) NSNumber *spacing;
@property (nonatomic, retain) NSNumber *gridHeight;
@property (nonatomic, retain) NSNumber *addedElements;
@property (nonatomic, retain) NSNumber *currentCol;
@property (nonatomic, retain) NSNumber *currentRow;
@property (nonatomic, assign) int row;

- (id)initGrid:(int)spacing gridHeight:(int)gridHeight;

- (void) insertPicture:(UIImage *)image
          withAssetURL:(NSURL *)assetURL
                 index:(int ) index;

- (void) clearGrid;

- (void) replaceImage:(UIImage *) image
                index:(int)index;

- (void) startEditMode;

- (void) endEditMode;


@end
