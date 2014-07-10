//
//  ImageCacheObject.m
//  DeenstDesk
//
//  Created by Rahul kumar on 11/9/12.
//  Copyright (c) 2012 Rahul kumar. All rights reserved.
//
#import "ImageCacheObject.h"
@implementation ImageCacheObject
@synthesize size;
@synthesize timeStamp;
@synthesize image;

-(id)initWithSize:(NSUInteger)sz Image:(UIImage*)anImage{
  
	if (self = [super init]) {
      
		size = sz;
        
		timeStamp =  [NSDate date];
        
		image = anImage;
    }
   
	return self;
}

-(void)resetTimeStamp {
  
	//[timeStamp release];
    
	timeStamp = [NSDate date];
}

-(void) dealloc {
   
 }

@end
