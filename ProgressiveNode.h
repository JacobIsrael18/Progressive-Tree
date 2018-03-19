/************************************
  ProgressiveNode.h

  Created by Jacob Israel on 3/14/18.
  Copyright  © 2018 - ∞  Jacob Israel . All rights reserved.
************************************/
#import <Foundation/Foundation.h>

@interface ProgressiveNode : NSObject
-(instancetype) initWithKey:(uint64_t) key;

-(uint64_t) key;

// Serialization
-(NSDictionary*) dictionaryRepresentation;
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary;
@end
