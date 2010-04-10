//
//  MasterTable.m
//  QSync
//
//  Created by Jason Tratta on 3/30/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import "MasterTable.h"


@implementation MasterTable


-(void)awakeFromNib

{ 
	 
	CGFloat f = 20;
	[self setRowHeight:f];
	[self setAllowsColumnSelection:FALSE];
	
	//Center Cells 
	
	NSSize size = NSMakeSize(3.0, 6.0);
	[self setIntercellSpacing:size];
	
	 
}

@end
