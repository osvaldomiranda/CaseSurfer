#import <UIKit/UIKit.h>
#import "IndexableImageView.h"


@protocol GridScrollViewDelegate

- (void)selectImageWithAssetURL:(NSURL *)assetURL image:(IndexableImageView *)image;

@end

@interface GridScrollView : UIScrollView

@property (nonatomic, retain) id <GridScrollViewDelegate> gridDelegate;

@property (nonatomic, retain) NSNumber *columns;
@property (nonatomic, retain) NSNumber *spacing;
@property (nonatomic, retain) NSNumber *gridWidth;
@property (nonatomic, retain) NSNumber *addedElements;
@property (nonatomic, retain) NSNumber *currentCol;
@property (nonatomic, retain) NSNumber *currentRow;
@property (nonatomic, assign) int row;

- (id)initGrid:(int)columns
   spacing:(int)spacing
 gridWidth:(int)gridWidth;

- (void) insertPicture:(UIImage *)image
          withAssetURL:(NSURL *)assetURL
            indexImage:(IndexableImageView *) indexImage;

@end
