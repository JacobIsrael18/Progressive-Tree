/******************************************
  ProgressiveTree.m
  
  Created by Jacob Israel on 3/13/18.
  Copyright © 2018 Jacob Israel. All rights reserved.
******************************************/
#import "ProgressiveTree.h"
#import "ProgressiveLeafNode.h"
#import "ProgressiveInternalNode.h"

@implementation ProgressiveTree{
    @protected
    ProgressiveNode* topMostChild; //   ProgressiveInternalNode  or  ProgressiveLeafNode or nil
}

/*================================
 @function
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
 @function       findObjectWithValue:
 ===================================*/
-(NSObject*) findObjectWithValue:(uint64_t) value{
    if([self theTopMostChildIsANode]){
        return [(ProgressiveInternalNode*)topMostChild findObjectWithValue: value];
    }
    else if(topMostChild != nil && [topMostChild value] == value){    // topMostChild is s Leaf
        // It has the correct value
        return [(ProgressiveLeafNode*)topMostChild object];
    }
    return nil;
}

/*================================
 @function  addObject:  withValue:
 ===================================*/
-(void) addObject:(NSObject*) object withValue:(uint64_t) value{
    ProgressiveLeafNode* newLeafNode = [[ProgressiveLeafNode alloc]initWithObject: object andValue:value];
    
    if(topMostChild == nil){
        topMostChild = newLeafNode;
        return;
    }
    
    uint64_t topMostChildValue = [topMostChild value];
    
    if([self theTopMostChildIsANode]){
        ProgressiveInternalNode* topMostChildNode = (ProgressiveInternalNode*) topMostChild;
        uint64_t childIndexBit = [topMostChildNode indexBit];
        uint64_t checkBit = HIGH_BIT;
        
        //  See if we need an intermediate node (to be the new topMostChildNode)
        while ((value & checkBit) == (topMostChildValue & checkBit) && checkBit > childIndexBit) {
            checkBit >>= 1;
        }
        
        if(checkBit <= childIndexBit){
            /* We do NOT need an intermediate node
             so just have the child Node do the work. */
            [topMostChildNode addObject: object withValue: value];
            return;
        }
        else{   // We DO need an intermediate node
            ProgressiveInternalNode* intermediateNode = [[ProgressiveInternalNode alloc]initWithChild: newLeafNode andChild: topMostChild];
            topMostChild = intermediateNode;
        }
        return;
    }
    
    if(value == topMostChildValue){
        // REPLACEMENT
        topMostChild = [[ProgressiveLeafNode alloc]initWithObject: object andValue: value];
    }
    else{
        // topMostChild is a Leaf. Add a new node
        ProgressiveInternalNode* newNode = [[ProgressiveInternalNode alloc]initWithChild: topMostChild andChild: newLeafNode];
        topMostChild = newNode;
    }
}

/*================================
 @function  removeObjectWithValue:
 ===================================*/
-(void) removeObjectWithValue:(uint64_t)value{
    if([self theTopMostChildIsANode]){
        // First try to remove one of the child's leafs
        ProgressiveInternalNode* topMostNode = (ProgressiveInternalNode*) topMostChild;
        
        if([topMostNode childZeroIsLeafWithValue: value]){
            topMostChild = [topMostNode getChildOne];
        }
        else if([topMostNode childOneIsLeafWithValue: value]){
             topMostChild = [topMostNode getChildZero];
        }
        else{
            // The child does not have a Leaf with this value.
            // So, pass the call onto the child
            [topMostNode removeObjectWithValue: value];
        }
    } //   __topMostChild is a Leaf__
    else if([topMostChild value] == value){
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
 @function 
 ===================================*/
-(ProgressiveNode*) topNode{
    return topMostChild;
}

/*================================
 @function
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
 @function
 ===================================*/
-(NSDictionary*) dictionaryRepresentation{
    if(topMostChild == nil){
        return nil;
    }
    return [topMostChild dictionaryRepresentation];
}

/*================================
 @function
 ===================================*/
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary{
    self = [super init];
    if(dictionary[@"myObject"] == nil){
        topMostChild = [[ProgressiveInternalNode alloc]initFromDictionaryRepresentation: dictionary];
    }
    else{
        topMostChild = [[ProgressiveLeafNode alloc]initFromDictionaryRepresentation: dictionary];
    }
    return self;
}
@end
