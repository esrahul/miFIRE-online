//
//  AsyncImageView.h
//  DeenstDesk
//
//  Created by Rahul kumar on 11/9/12.
//  Copyright (c) 2012 Rahul kumar. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface AsyncImageView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate> {

	NSURLConnection* connection;
   
	NSMutableData* data;
	
	NSString *urlString; 
	
	int imgDimention;
	
	UIActivityIndicatorView *spinny;
	
	UIImage *imageOne;
	
	float lastScale;
	
	float width;
	
	float height;
}

@property(nonatomic, assign)int imgDimention;

@property(nonatomic, retain)UIActivityIndicatorView *spinny;

@property(nonatomic, retain)NSString *urlString; 

@property(nonatomic, retain)UIImage *imageOne;

@property(nonatomic, assign)float width;

@property(nonatomic, assign)float height;



- (void)loadImageFromURL:(NSURL*)url;

@end
