//
//  MasterTableCell.m
//  QSync
//
//  Created by Jason Tratta on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MasterTableCell.h"


@implementation MasterTableCell


-(void)awakeFromNib 
{ 
	
	//NSLog(@"Cell Font:%@", [self font]);
	//NSLog(@"Cell Test!"); 
	
	CGFloat f = 15;
	NSFont *font = [NSFont fontWithName:@"LucidaGrande" size:f]; 
	[self setFont:font];
	
	 
}


@end
