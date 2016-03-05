//
//  CSToolBar.m
//  casesurfer
//
//  Created by Osvaldo on 07-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CSToolBar.h"
#import "Definitions.h"
#import "rollGridViewController.h"

@implementation CSToolBar

@synthesize viewFatherR;
@synthesize delegate;
@synthesize modMenu;
@synthesize screenHeight;
@synthesize cover;
@synthesize notificationCount;
@synthesize button1,button2,button4,button5,buttonCountNotif;
@synthesize currentButton;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        modMenu=FALSE;
        currentButton=1;
        screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
        
        
        cover = [[UIView alloc] init];
        cover.alpha = 0;
        cover.backgroundColor = [UIColor blackColor];
        cover.frame = CGRectMake(0, 0, 400, screenHeight);
        cover.userInteractionEnabled = TRUE;
        cover.multipleTouchEnabled = FALSE;
        //The setup code (in viewDidLoad in your view controller)
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [cover addGestureRecognizer:singleFingerTap];
        
        
        
        
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 addTarget:self
                    action:@selector(actionButton1:)
          forControlEvents:UIControlEventTouchDown];
        button1.backgroundColor = [UIColor whiteColor ];
        UIImage *imageB1 = [UIImage imageNamed:@"home_active_blue.png"];
        [button1 setImage:imageB1 forState:UIControlStateNormal];
        
        
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 addTarget:self
                    action:@selector(actionButton2:)
          forControlEvents:UIControlEventTouchDown];
        button2.backgroundColor = [UIColor whiteColor ];
        UIImage *imageB2 = [UIImage imageNamed:@"folder_inactive.png"];
        [button2 setImage:imageB2 forState:UIControlStateNormal];
        
        
        
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button3 addTarget:self
                    action:@selector(actionButton3:)
          forControlEvents:UIControlEventTouchDown];
        button3.backgroundColor = greenColor;
        UIImage *imageB3 = [UIImage imageNamed:@"pluss.png"];
        [button3 setImage:imageB3 forState:UIControlStateNormal];
        
        
        
        button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button4 addTarget:self
                    action:@selector(actionButton4:)
          forControlEvents:UIControlEventTouchDown];
        button4.backgroundColor = [UIColor whiteColor];
        UIImage *imageB4 = [UIImage imageNamed:@"group_inactive.png"];
        [button4 setImage:imageB4 forState:UIControlStateNormal];
        
        button5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button5 addTarget:self
                    action:@selector(actionButton5:)
          forControlEvents:UIControlEventTouchDown];
        button5.backgroundColor = [UIColor whiteColor ];
        
        UIImage *imageB5 = [UIImage imageNamed:@"user_inactive.png"];
        [button5 setImage:imageB5 forState:UIControlStateNormal];
       
        
        if ([self screen]== 320) {
            button1.frame = CGRectMake(0  , 0, 64, 50);
            button2.frame = CGRectMake(64 , 0, 64, 50);
            button3.frame = CGRectMake(128, 0, 64, 50);
            button4.frame = CGRectMake(192, 0, 64, 50);
            button5.frame = CGRectMake(256, 0, 64, 50);
        }
        else {
            button1.frame = CGRectMake(0  , 0, 80, 50);
            button2.frame = CGRectMake(75 , 0, 80, 50);
            button3.frame = CGRectMake(155, 0, 80, 50);
            button4.frame = CGRectMake(235, 0, 80, 50);
            button5.frame = CGRectMake(300, 0, 80, 50);
        }

        
        
        [self addSubview:button1];
        [self addSubview:button2];
        [self addSubview:button3];
        [self addSubview:button4];
        [self addSubview:button5];
        
        
    }
    return self;
}

-(int) screen {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    
    return screenWidth;
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
 //    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
 
    
}

-(void) setBackgroundButtons:(int) button {
    UIImage *imageB1 = [UIImage imageNamed:@"home_inactive.png"];
    [button1 setImage:imageB1 forState:UIControlStateNormal];
    
    UIImage *imageB2 = [UIImage imageNamed:@"folder_inactive.png"];
    [button2 setImage:imageB2 forState:UIControlStateNormal];
    
    UIImage *imageB4 = [UIImage imageNamed:@"group_inactive.png"];
    [button4 setImage:imageB4 forState:UIControlStateNormal];
    
    UIImage *imageB5 = [UIImage imageNamed:@"user_inactive.png"];
    [button5 setImage:imageB5 forState:UIControlStateNormal];
    
    UIColor *selColor = [UIColor whiteColor];
    
    switch (button) {
        case 1:{
            button1.backgroundColor = selColor;
            button2.backgroundColor = [UIColor whiteColor ];
            button4.backgroundColor = [UIColor whiteColor ];
            button5.backgroundColor = [UIColor whiteColor ];
            
            UIImage *imageB1 = [UIImage imageNamed:@"home_active_blue.png"];
            [button1 setImage:imageB1 forState:UIControlStateNormal];
            currentButton = button;
            break;
        }
        case 2:{
            button1.backgroundColor = [UIColor whiteColor ];
            button2.backgroundColor = selColor;
            button4.backgroundColor = [UIColor whiteColor ];
            button5.backgroundColor = [UIColor whiteColor ];
            UIImage *imageB2 = [UIImage imageNamed:@"folder_active_blue.png"];
            [button2 setImage:imageB2 forState:UIControlStateNormal];
            currentButton = button;
            break;
        }
        case 4:{
            button1.backgroundColor = [UIColor whiteColor ];
            button2.backgroundColor = [UIColor whiteColor ];
            button4.backgroundColor = selColor;
            button5.backgroundColor = [UIColor whiteColor ];
            currentButton = button;
            UIImage *imageB4 = [UIImage imageNamed:@"group_active_blue.png"];
            [button4 setImage:imageB4 forState:UIControlStateNormal];
            break;
        }
        case 5:{
            button1.backgroundColor = [UIColor whiteColor ];
            button2.backgroundColor = [UIColor whiteColor ];
            button4.backgroundColor = [UIColor whiteColor ];
            button5.backgroundColor = selColor;
            
            UIImage *imageB5 = [UIImage imageNamed:@"user_active_blue.png"];
            [button5 setImage:imageB5 forState:UIControlStateNormal];
            break;
        }
        default:{
            button1.backgroundColor = [UIColor whiteColor ];
            button2.backgroundColor = [UIColor whiteColor ];
            button4.backgroundColor = [UIColor whiteColor ];
            button5.backgroundColor = [UIColor whiteColor ];
            break;
        }
    }
}

-(IBAction)actionButton1:(id)sender{
    [self setBackgroundButtons:1];
    [delegate actionButtonWithIndex:0];
}

-(IBAction)actionButton2:(id)sender{
    [self setBackgroundButtons:2];
    [delegate actionButtonWithIndex:1];
}

-(IBAction)actionButton3:(id)sender{
    [self setBackgroundButtons:3];

    UIViewController *vController = [[delegate obtainViewController] navigationController];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    rollGridViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"rollGrid"];
    [cController setCollectionId:[sender title]];
    vController.hidesBottomBarWhenPushed =  YES;
    [vController.navigationController pushViewController:cController animated:YES];
    vController.hidesBottomBarWhenPushed =  NO;

}

-(IBAction)actionButton4:(id)sender{
    [self setBackgroundButtons:4];
    [delegate actionButtonWithIndex:2];
}

-(IBAction)actionButton5:(id)sender{
    [self setBackgroundButtons:5];
    [delegate actionButtonWithIndex:3];
 
}

-(void) setView:(UIViewController *)viewFather{
    viewFatherR = viewFather;
}

-(void) setPosY:(int ) posY{
    [self setFrame:CGRectMake(0, posY, 400, 50)];
}

@end
