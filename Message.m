//
//  ClientMessage.m
//  QSSync
//
//  Created by jtratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)initWithCoder:(NSCoder *)coder {
    if ( self = [super init] ) {
        tag = [coder decodeIntForKey:@"tag"];
        dataContent = [[coder decodeObjectForKey:@"dataContent"] retain];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:tag forKey:@"tag"];
    [coder encodeObject:dataContent forKey:@"dataContent"];
}

-(void)dealloc {
    [dataContent release];
    [super dealloc];
}

-(int)tag {
    return tag;
}

-(void)setTag:(int)value {
    tag = value;
}

-(NSData *)dataContent {
    return [[dataContent retain] autorelease];
}

-(void)setDataContent:(NSData *)value {
    if (dataContent != value) {
        [dataContent release];
        dataContent = [value copy];
    }
}

@end
