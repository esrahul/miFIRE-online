//
//  AsyncImageView.m
//  DeenstDesk
//
//  Created by Rahul kumar on 11/9/12.
//  Copyright (c) 2012 Rahul kumar. All rights reserved.
//

#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"

#import "ImageManipulator.h"



static ImageCache *imageCache = nil;

@implementation AsyncImageView

@synthesize imgDimention;

@synthesize spinny;

@synthesize imageOne;

@synthesize width,height;

@synthesize urlString;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [connection cancel];
   // [connection release];
   // [data release];
   // [super dealloc];
}

-(void)loadImageFromURL:(NSURL*)url {
	//self.autoresizingMask=UIViewAutoresizingFlexibleHeight;
	if (!width) {
		width=130;
	}
	if (!height) {
		height=100;
	}
	self.backgroundColor=[UIColor clearColor];
    if (connection != nil) {
        [connection cancel];
       // [connection release];
        connection = nil;
    }
    if (data != nil) {
       // [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
   // [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
     if (cachedImage != nil) {
		 
		 if ([[self subviews] count] > 2) {
			 [[[self subviews] objectAtIndex:2] removeFromSuperview];
		 }
		 if ([[self subviews] count] > 1) {
			 [[[self subviews] objectAtIndex:1] removeFromSuperview];
		 }
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:cachedImage];
		 imageView.contentMode = UIViewContentModeScaleAspectFit;
         [self addSubview:imageView];
 		CGRect frame;
		frame.origin.x = 0;
		frame.origin.y = 0;
		 frame.size.width = width;
		 frame.size.height =height;
		imageView.frame = frame;
		imageView.backgroundColor = [UIColor clearColor];
          return;
    }

#define SPINNY_TAG 5555   
	//if (spinny!=nil) { [spinny release]; }
	spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	CGPoint pt=CGPointMake(width/2, height/2);
	spinny.center = pt;
	//spinny.frame=CGRectMake(width/2, height/2, 50, 50);
	spinny.hidesWhenStopped = YES;
	[spinny startAnimating];
	[self addSubview:spinny];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection 
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
   // [connection release];
    connection = nil;
    
    //UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];

    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
     UIImage *image = [UIImage imageWithData:data];
	imageOne=image;
 	// image = [ImageManipulator makeRoundCornerImage:image : 20 : 15];
     [imageCache insertImage:image withSize:[data length] forKey:urlString];
     UIImageView *imageView =  [[UIImageView alloc] initWithImage:image];
	imageView.contentMode = UIViewContentModeScaleToFill;
	
     [self addSubview:imageView];

	
	CGRect frames;
	frames.origin.x = 0;
	frames.origin.y = 0;
	frames.size.width = width;
	frames.size.height =height;
	imageView.frame = frames;
		
	imageView.backgroundColor = [UIColor clearColor];
	imageView.contentMode = UIViewContentModeScaleAspectFit;

	[imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
	[self setNeedsLayout];
    //[data release];
    data = nil;
}

@end
