/************************************
 ProgressiveNode.m
 
 Created by Jacob Israel on 3/14/18.
 Copyright  © 2018 - ∞  Jacob Israel . All rights reserved.
 ************************************/
#import "ProgressiveNode.h"

@implementation ProgressiveNode{
@protected 
    uint64_t myKey;
}

#pragma mark -
/*================================
 @function
 ===================================*/
-(instancetype) initWithKey:(uint64_t) key{
    self = [super init];
    myKey = key;
    return self;
}

#pragma mark -
/*================================
 @function    value
 ===================================*/
-(uint64_t) key{return myKey;}

/*================================
 @function
 For subclasses (Internal use only)
 ===================================*/
-(void) setMyKey:(uint64_t)newKey{ myKey = newKey; }


#pragma mark - Serialization
/*================================
 @function    dictionaryRepresentation
 ===================================*/
-(NSDictionary*) dictionaryRepresentation{
    NSLog(@"Implement in subclass");
    return nil;
}

/*================================
 @function    initFromDictionaryRepresentation:
 ===================================*/
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary{
    NSLog(@"Implement in subclass");
    return nil;
}
@end
