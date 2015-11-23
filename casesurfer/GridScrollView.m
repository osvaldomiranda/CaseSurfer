#import "GridScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IndexableImageView.h"

@implementation GridScrollView

@synthesize gridDelegate;
@synthesize row;

- (id)initGrid:(int)columns spacing:(int)spacing gridWidth:(int)gridWidth{

    self = [super init];
    self.columns = [NSNumber numberWithInt:columns];
    self.spacing = [NSNumber numberWithInt:spacing];
    self.gridWidth = [NSNumber numberWithInt:gridWidth];
    
    row = (int)[self.spacing integerValue];
    
    self.addedElements = 0;
    self.currentCol = 0;
    self.currentRow = 0;
    
    return self;
}


- (void) insertPicture:(UIImage *)image
          withAssetURL:(NSURL *)assetURL
            indexImage:(IndexableImageView *)indexImage
{
    
    UIView *pictureView = [[UIView alloc] init];
    NSString *subTitle =  [indexImage.imageInfo valueForKeyPath:@"name"];
    
    float scrollBarWidth = 0;
    if ([self.columns integerValue]>2) {
        scrollBarWidth = 10;
    }
   
    int pictureSize = ([self.gridWidth integerValue]/[self.columns integerValue]) - ([self.spacing integerValue] * ([self.columns integerValue]) - scrollBarWidth);
    
    if ([self.currentCol integerValue] == [self.columns integerValue]) {
        self.currentCol = 0;
        self.currentRow = [NSNumber numberWithInt:(int)[self.currentRow integerValue]+1];
        
        row = (pictureSize * (int)[self.currentRow integerValue]) + (int)([self.spacing integerValue] * ([self.currentRow integerValue]+1));
        
        if (subTitle) {
            row = row + (35*[self.currentRow intValue]);

        }
    }
    

    
    int col = ((int)[self.currentCol integerValue] * pictureSize) + ((int)[self.spacing integerValue] * ((int)[self.currentCol integerValue]+1));
    
  //  IndexableImageView *indexableImage = [[IndexableImageView alloc] initWithImage:image andAssetURL:assetURL andIndex:0];
    
    IndexableImageView *indexableImage = [[IndexableImageView alloc] initWithUrl:assetURL andImageInfo:indexImage.imageInfo];
    [indexableImage setImage:image];
    
    indexableImage.contentMode = UIViewContentModeScaleAspectFit;
    [indexableImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressCaptured:)];
    [indexableImage addGestureRecognizer:tapRecognizer];
    indexableImage.frame = CGRectMake(0, 0, pictureSize, pictureSize);
    
    pictureView.frame = CGRectMake(col + ([self.spacing integerValue]/2), row, pictureSize, pictureSize);
    [pictureView setBackgroundColor:[UIColor whiteColor]];
    pictureView.layer.borderColor = [UIColor grayColor].CGColor;
    pictureView.layer.borderWidth = 0.5f;
    
    int rows = (int)[self.currentRow integerValue] + 1;
    int expectedSize = (rows)*pictureSize + (rows+2)*(int)[self.spacing integerValue];
    if(self.contentSize.height < expectedSize){
        self.contentSize =  CGSizeMake(self.contentSize.width, expectedSize);
        if (subTitle) {
            self.contentSize =  CGSizeMake(self.contentSize.width, expectedSize + (35*[self.currentRow intValue]));
        }
    }
    
    [pictureView addSubview:indexableImage];
    
    if (subTitle) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, pictureSize +2, pictureSize, 15)];
        [title setText: subTitle];
        [title setFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
        title.textAlignment =  NSTextAlignmentLeft;
        
        NSString *caseCount =  [indexImage.imageInfo valueForKeyPath:@"cases"];
        NSString *createdAt =  [indexImage.imageInfo valueForKeyPath:@"created"];
        if (createdAt==nil) {
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            createdAt = [formatter stringFromDate:now];
        }
        
        UILabel *subT = [[UILabel alloc] initWithFrame:CGRectMake(5, pictureSize +18, pictureSize, 15)];
        [subT setText: [NSString stringWithFormat:@" %@ | Cases %@", createdAt, caseCount]];
        [subT setFont:[UIFont fontWithName:@"Lato-Light" size:10]];
        subT.textAlignment =  NSTextAlignmentLeft;
        subT.textAlignment =  NSTextAlignmentLeft;
        
        [pictureView addSubview:title];
        [pictureView addSubview:subT];
        
        pictureView.frame = CGRectMake(col + ([self.spacing integerValue]/2), row, pictureSize, pictureSize+35);
        [pictureView.layer setMasksToBounds:YES];
        [pictureView.layer setCornerRadius:4.0f];
    }
    
    [self addSubview:pictureView];
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.currentCol = [NSNumber numberWithInt:(int)[self.currentCol integerValue]+1];
    self.addedElements = [NSNumber numberWithInt:(int)[self.addedElements integerValue]+1];
    if (subTitle) {
        self.contentSize =  CGSizeMake(self.contentSize.width,self.contentSize.height + 20);
    }
}

- (void)tapPressCaptured:(UITapGestureRecognizer *)gesture{
    IndexableImageView *tappedView = (IndexableImageView *)[gesture.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    
    if (tappedView.assetURL) {
        if (!tappedView.selected) {
            UIImage *selImg = [UIImage imageNamed:@"icon_check.png"];
            UIImageView *selectedImg = [[UIImageView alloc] initWithImage:selImg];
            selectedImg.frame = CGRectMake(tappedView.frame.size.width-20, tappedView.frame.size.height-20, 15, 15);
            [tappedView addSubview:selectedImg];
            tappedView.selected = TRUE;
        }
        else
        {
            tappedView.selected = FALSE;
            for (id view in [tappedView subviews]) {
                if ([view isKindOfClass:[UIImageView class]]){
                    [UIView animateWithDuration:0.5f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{[view setAlpha:0.0f];}
                                     completion:^(BOOL finished) {[view removeFromSuperview];}];
                }
            }
        }
        
        [gridDelegate selectImageWithAssetURL:tappedView.assetURL image:tappedView selected: (BOOL *)tappedView.selected];
    }
}

- (void) clearGrid{
    row = (int)[self.spacing integerValue];
    self.addedElements = 0;
    self.currentCol = 0;
    self.currentRow = 0;
    for ( UIView *view in self.subviews ) {
        [view removeFromSuperview];
    }
     self.contentSize =  CGSizeMake(self.contentSize.width, 0);
}

- (void) startEditMode{
    
    for ( UIView *view in self.subviews ) {
        UIImage *selImg = [UIImage imageNamed:@"icon_delete.png"];
        UIImageView *selectedImg = [[UIImageView alloc] initWithImage:selImg];
        selectedImg.frame = CGRectMake(view.frame.size.width-35, 5, 30, 30);
        [view addSubview:selectedImg];
    }
    

}

- (void) endEditMode {
    
    for ( UIView *viewP in self.subviews ) {
        int i = 0;
        for (id view in [viewP subviews]) {
            if ([view isKindOfClass:[UIImageView class]] && i>0){
                [UIView animateWithDuration:0.5f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{[view setAlpha:0.0f];}
                                 completion:^(BOOL finished) {[view removeFromSuperview];}];
            }
            i++;
        }
        
    }
    
    
}


@end
