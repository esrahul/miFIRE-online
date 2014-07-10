//
//  ImageCache.h
//  DeenstDesk
//
//  Created by Rahul kumar on 11/9/12.
//  Copyright (c) 2012 Rahul kumar. All rights reserved.
//



#import <Foundation/Foundation.h>

@class ImageCacheObject;

@interface ImageCache : NSObject {
  
	NSUInteger totalSize;  // total number of bytes
    
	NSUInteger maxSize;    // maximum capacity
    
	NSMutableDictionary *myDictionary;
	
	ImageCacheObject *object;
}

@property (nonatomic, readonly) NSUInteger totalSize;

-(id)initWithMaxSize:(NSUInteger) max;

-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key;

-(UIImage*)imageForKey:(NSString*)key;

@end
