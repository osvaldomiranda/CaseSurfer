//
//  photoGalery.h
//  casesurfer
//
//  Created by Osvaldo on 20-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol photoGaleryDelegate
- (void)selectImageWithAssetURL:(UIImage *)image  indexImage:(int) indexImage assetUrl:(NSURL *) assetUrl;
@end

@interface photoGalery : UIScrollView

@property (nonatomic, retain) id <photoGaleryDelegate> gridDelegate;

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




@end
