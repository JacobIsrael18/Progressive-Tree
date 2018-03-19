/************************************
 ProgressiveLeafNode.m 
 
 Created by Jacob Israel. on 3/14/18.
 Copyright  © 2018 - ∞  Jacob Israel . All rights reserved.
 ************************************/
#import "ProgressiveLeafNode.h"

const NSString* MY_OBJECT_KEY =  @"myObject";
const NSString* MY_VALUE_KEY = @"myValue";

@interface ProgressiveLeafNode(ProtectedMethods)
-(void) setMyKey:(uint64_t) newKey;
@end

@implementation ProgressiveLeafNode{
@protected
    NSObject* myObject;
}

#pragma mark -
/*================================
 @function    initWithObject: andValue:
 ===================================*/
-(instancetype) initWithObject:(NSObject*) object andKey:(uint64_t) key{
    self = [super initWithKey: key];
    myObject = object;
    return self;
}

#pragma mark -
/*================================
 @function   object
 ===================================*/
-(NSObject*) object{
    return myObject;
}

#pragma mark -  Serialization
/*================================
 @function   dictionaryRepresentation
 ===================================*/
-(NSDictionary*) dictionaryRepresentation{
    NSMutableDictionary* output = [NSMutableDictionary new];
    output[MY_OBJECT_KEY] = myObject;
    output[MY_VALUE_KEY] = [NSNumber numberWithUnsignedLongLong: [self key]];
    return  output;
}

/*================================
 @function   initFromDictionaryRepresentation:
 ===================================*/
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary{
    self = [super init];
    NSNumber* number = dictionary[MY_VALUE_KEY];
    [self setMyKey: [number unsignedLongLongValue]];
      myObject = dictionary[MY_OBJECT_KEY];  
    return self;
}
@end
