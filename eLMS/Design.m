//
//  Design.m
//  doleApplicationSupport
//
//  Created by Rahul kumar on 12/5/12.
//  Copyright (c) 2012 Vmoksha. All rights reserved.
//

#import "Design.h"
#import  <QuartzCore/QuartzCore.h>

UIView *actView;
UIView *netAlertView;
UIActivityIndicatorView *act;


@implementation Design

+(void)createActivityIndicatorStart:(id)parentController {
	
	UIViewController *vController = (UIViewController*)parentController;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	vController.view.userInteractionEnabled = FALSE;
	vController.navigationController.toolbar.userInteractionEnabled = FALSE;
	vController.navigationController.navigationBar.userInteractionEnabled = FALSE;
	
	actView = [[UIView alloc] initWithFrame:CGRectMake(320/2-30, 460/2-30, 60.0, 60.0)];
	actView.backgroundColor = [UIColor blackColor];
	actView.alpha = 0.8f;
	actView.layer.cornerRadius = 10.0f;
	
	act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	act.frame = CGRectMake(60/2-15, 60/2-15, 30.0, 30.0);
	[act startAnimating];
	
	[actView addSubview:act];
	[vController.view addSubview:actView];
}

+(void)createActivityIndicatorFinish:(id)parentController {
	
	UIViewController *vController = (UIViewController*)parentController;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	vController.view.userInteractionEnabled = TRUE;
	vController.navigationController.toolbar.userInteractionEnabled = TRUE;
	vController.navigationController.navigationBar.userInteractionEnabled = TRUE;
	
	[act stopAnimating];
	actView.hidden = TRUE;
	[actView removeFromSuperview];
}
+(void)createAlertView:(NSString*)title :(NSString*)bodyText :(id)sender {
	UIAlertView *alt = [[UIAlertView alloc] initWithTitle:title message:bodyText delegate:sender cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alt show];
	//[alt release];
}

+(void)createNetworkAlert:(id)parentController{

    UIViewController *vController = (UIViewController*)parentController;
   // vController.view.userInteractionEnabled = FALSE;
	//vController.navigationController.toolbar.userInteractionEnabled = FALSE;
	//vController.navigationController.navigationBar.userInteractionEnabled = FALSE;
    netAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	netAlertView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageVw=[[UIImageView alloc]init];
    [imageVw setFrame:CGRectMake(320/2-124, 460/2-74, 248.0, 148.0)];
    [imageVw setImage:[UIImage imageNamed:@"Error-Window.png"]];
    [netAlertView addSubview:imageVw];//302 74
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(netAlertView.bounds.size.width/2-75, netAlertView.bounds.size.height/2+5, 151, 37)];
   // btn.center=netAlertView.center;
    [btn setBackgroundImage:[UIImage imageNamed:@"OK-Button.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(okClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label=[[UILabel alloc]init];
    [label setFrame:CGRectMake(netAlertView.bounds.size.width/2-100, netAlertView.bounds.size.height/2-40, 200, 30)];
    [label setText:@"Data Connection Lost"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [netAlertView addSubview:btn];
    [netAlertView addSubview:label];
    [vController.view addSubview:netAlertView];
    
}

+(void)okClicked:(UIButton*)button{
    NSLog(@"rtre");
    [netAlertView removeFromSuperview];
}

@end
