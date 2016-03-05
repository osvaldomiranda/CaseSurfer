//
//  CSToolBar.h
//  casesurfer
//
//  Created by Osvaldo on 07-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CStoolbarDelegate

- (void)actionButtonWithIndex:(NSInteger)index;
- (UIView*)obtainViewToShowMenu;
- (id)obtainViewController;

@end


@interface CSToolBar : UIView

@property (nonatomic, retain ) UIViewController *viewFatherR;
@property (nonatomic, assign) id <CStoolbarDelegate> delegate;
@property (nonatomic, assign) BOOL modMenu;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, retain) UIView *cover;
@property (nonatomic, retain) NSString *notificationCount;



@property (nonatomic, retain)IBOutlet UIButton *button1;
@property (nonatomic, retain)IBOutlet UIButton *button2;
@property (nonatomic, retain)IBOutlet UIButton *button4;
@property (nonatomic, retain)IBOutlet UIButton *button5;
@property (nonatomic, retain)IBOutlet UIButton *buttonCountNotif;
@property (nonatomic, assign)int currentButton;


-(void) setView:(UIViewController *)viewFather;
-(void) setPosY:(int ) posY;
@end
