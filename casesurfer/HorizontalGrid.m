//
//  HorizontalGrid.m
//  casesurfer
//
//  Created by Osvaldo on 26-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "HorizontalGrid.h"
#import "IndexableImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation HorizontalGrid

@synthesize gridDelegate;
@synthesize row;

- (id)initGrid:(int)spacing gridHeight:(int)gridHeight{
    
    self = [super init];

    self.spacing = [NSNumber numberWithInt:spacing];
    self.gridHeight = [NSNumber numberWithInt:gridHeight];
    
    row = (int)[self.spacing integerValue];
    
    self.addedElements = 0;
    self.currentCol = 0;
    self.currentRow = 0;
    
    return self;
}

- (void) insertPicture:(UIImage *)image
          withAssetURL:(NSURL *)assetURL
              index:(int ) index
{
  /*  float scrollBarWidth = 1.8;
    if ([self.columns integerValue]>2) {
        scrollBarWidth = 10;
    }
    */
    int pictureSize = [self.gridHeight intValue];
    
    if ([self.currentCol integerValue] == [self.columns integerValue]) {
        self.currentCol = 0;
        self.currentRow = [NSNumber numberWithInt:(int)[self.currentRow integerValue]+1];
        row = [self.spacing intValue];
    }
    
    int col = ((int)[self.currentCol integerValue] * pictureSize) + ((int)[self.spacing integerValue] * ((int)[self.currentCol integerValue]+1));
    
    IndexableImageView *indexableImage = [[IndexableImageView alloc] initWithImage:image andAssetURL:assetURL andIndex: [NSNumber numberWithInt:index]];
    indexableImage.contentMode = UIViewContentModeScaleAspectFit;
    [indexableImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressCaptured:)];
    [indexableImage addGestureRecognizer:tapRecognizer];
    
    
    indexableImage.frame = CGRectMake(col + ([self.spacing integerValue]/2), row, pictureSize, pictureSize);
    int cols = (int)[self.currentCol integerValue] + 1;
    
    int expectedSize = (cols)*pictureSize + (int)[self.spacing integerValue];
    
    if(self.contentSize.width < expectedSize){
        self.contentSize =  CGSizeMake(expectedSize, self.contentSize.height);
    }
    
    [self addSubview:indexableImage];
    
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    self.currentCol = [NSNumber numberWithInt:(int)[self.currentCol integerValue]+1];
    self.addedElements = [NSNumber numberWithInt:(int)[self.addedElements integerValue]+1];
    
    
}

- (void)tapPressCaptured:(UITapGestureRecognizer *)gesture{
    IndexableImageView *tappedView = (IndexableImageView *)[gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary assetForURL:tappedView.assetURL
                   resultBlock:^(ALAsset *asset){
                       if (asset != nil){
                           ALAssetRepresentation *repr = [asset defaultRepresentation];
                           UIImage *img = [UIImage imageWithCGImage:[repr fullResolutionImage] scale:1.0f orientation:(UIImageOrientation)[repr orientation]];
                           
                           [tappedView setImage:img];
                           [gridDelegate selectImageWithAssetURL:img indexImage:[tappedView.index intValue] assetUrl:tappedView.assetURL];
                             
                       }
                   }failureBlock:^(NSError *error) {
                       NSLog(@"error: %@", error);
                   }
     ];
}




- (void) clearGrid{
    
    self.addedElements = 0;
    self.currentCol = 0;
    self.currentRow = 0;
    
    for ( UIView *view in self.subviews ) {
        [view removeFromSuperview];
    }
}


@end
