/******************************************
  ProgressiveTree.m
  
  Created by Jacob Israel on 3/13/18.
  Copyright  © 2018 - ∞  Jacob Israel . All rights reserved.
******************************************/
#import "ProgressiveTree.h"
#import "ProgressiveInternalNode.h"

@implementation ProgressiveTree{
    @protected
    ProgressiveNode* topMostChild; //   ProgressiveInternalNode  or  ProgressiveLeafNode or nil
}

/*================================
 @function init
 ===================================*/
-(instancetype) init{
    self = [super init];
    if(self == nil){
        return  nil;
    }
    topMostChild = nil;

    return self;
}

/*================================
 @function       findObjectWithKey:
 ===================================*/
-(NSObject*) findObjectWithKey:(uint64_t) key{
    if([self theTopMostChildIsANode]){
        return [(ProgressiveInternalNode*)topMostChild findObjectWithKey: key];
    }
    else if(topMostChild != nil && [topMostChild key] == key){    // topMostChild is s Leaf
        // It has the correct value
        return [(ProgressiveLeafNode*)topMostChild object];
    }
    return nil;
}

/*================================
 @function  addObject:  WithKey:
 ===================================*/
-(void) addObject:(NSObject*) object withKey:(uint64_t) key{
    
    if(object == nil){
        // addObject: nil  withKey:  
        // means remove that Object
        [self removeObjectWithKey: key];
        return;
    }
    
    ProgressiveLeafNode* newLeafNode = [[ProgressiveLeafNode alloc]initWithObject: object andKey:key];
    
    if(topMostChild == nil){
        topMostChild = newLeafNode;
        return;
    }
    
    uint64_t topMostChildKey = [topMostChild key];
    
    if([self theTopMostChildIsANode]){
        ProgressiveInternalNode* topMostChildNode = (ProgressiveInternalNode*) topMostChild;
        uint64_t childIndexBit = [topMostChildNode indexBit];
        uint64_t checkBit = HIGH_BIT;
        
        //  See if we need an intermediate node (to be the new topMostChildNode)
        while ((key & checkBit) == (topMostChildKey & checkBit) && checkBit > childIndexBit) {
            checkBit >>= 1;
        }
        
        if(checkBit <= childIndexBit){
            /* We do NOT need an intermediate node
             so just have the child Node do the work. */
            [topMostChildNode addObject: object withKey: key];
            return;
        }
        else{   // We DO need an intermediate node
            ProgressiveInternalNode* intermediateNode = [[ProgressiveInternalNode alloc]initWithChild: newLeafNode andChild: topMostChild];
            topMostChild = intermediateNode;
        }
        return;
    }
    
    if(key == topMostChildKey){
        // REPLACEMENT
        topMostChild = [[ProgressiveLeafNode alloc]initWithObject: object andKey: key];
    }
    else{
        // topMostChild is a Leaf. Add a new node
        ProgressiveInternalNode* newNode = [[ProgressiveInternalNode alloc]initWithChild: topMostChild andChild: newLeafNode];
        topMostChild = newNode;
    }
}

/*================================
 @function  removeObjectWithKey:
 ===================================*/
-(void) removeObjectWithKey:(uint64_t) key{
    if([self theTopMostChildIsANode]){
        // First try to remove one of the child's leafs
        ProgressiveInternalNode* topMostNode = (ProgressiveInternalNode*) topMostChild;
        
        if([topMostNode childZeroIsLeafWithKey: key]){
            topMostChild = [topMostNode getChildOne];
        }
        else if([topMostNode childOneIsLeafWithKey: key]){
             topMostChild = [topMostNode getChildZero];
        }
        else{
            // The child does not have a Leaf with this value.
            // So, pass the call onto the child
            [topMostNode removeObjectWithKey: key];
        }
    } //   __topMostChild is a Leaf__
    else if([topMostChild key] == key){
        topMostChild = nil;
    }
}

/*================================
 @function   theTopMostChildIsANode
 ===================================*/
-(BOOL)  theTopMostChildIsANode{
    return [topMostChild isKindOfClass: [ProgressiveInternalNode class]];
}

/*================================
 @function  isEmpty
 ===================================*/
-(BOOL) isEmpty{
    return topMostChild == nil;
}

/*================================
 @function  topNode
 ===================================*/
-(ProgressiveNode*) topNode{
    return topMostChild;
}

/*================================
 @function   getTreeDepth
 ===================================*/
-(uint16_t) getTreeDepth{
    if(topMostChild == nil){
        return 0;
    }
    if([self theTopMostChildIsANode] == NO){
        return  1;
    }
    
    return    [(ProgressiveInternalNode*)topMostChild getDepth] + 1;
}

/*================================
 @function       allLeafNodes
 ===================================*/
-(NSArray<ProgressiveLeafNode*>*) allLeafNodes{
    if(topMostChild == nil){
        return nil;
    }
    if([self theTopMostChildIsANode]){
        return [(ProgressiveInternalNode*)topMostChild allLeafNodes];
    }
    return @[(ProgressiveLeafNode*) topMostChild];
}

#pragma mark -  Serialization
/*================================
 @function      dictionaryRepresentation
 ===================================*/
-(NSDictionary*) dictionaryRepresentation{
    if(topMostChild == nil){
        return nil;
    }
    return [topMostChild dictionaryRepresentation];
}

/*================================
 @function     initFromDictionaryRepresentation:
 ===================================*/
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary{
    self = [super init];
    
    if(self == nil || dictionary == nil){
        return  nil;
    }
    
    if(dictionary[MY_OBJECT_KEY] == nil){
        topMostChild = [[ProgressiveInternalNode alloc]initFromDictionaryRepresentation: dictionary];
    }
    else{
        topMostChild = [[ProgressiveLeafNode alloc]initFromDictionaryRepresentation: dictionary];
    }
    return self;
}
@end
