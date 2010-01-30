//
//  MainWindow.m
//  QSync
//
//  Created by Jason Tratta on 12/13/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import "MainWindow.h"


@implementation MainWindow

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)windowStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)deferCreation
{
    self = [super
			initWithContentRect:contentRect
			styleMask: (NSTitledWindowMask | NSMiniaturizableWindowMask)
			
			backing:bufferingType
			defer:deferCreation];
    if (self)
    {
        
        [self setBackgroundColor:[NSColor whiteColor]];
		[self setShowsResizeIndicator:FALSE];
    }
    return self;
}



@end
