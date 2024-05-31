//
//  TCPStream.h
//  LTSupportAutomotive
//
//  Created by 江志敏 on 2024/5/28.
//  Copyright © 2024 Dr. Lauer Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LTSupportAutomotive/GCDAsyncSocket.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCPReadStream : NSInputStream <NSStreamDelegate>

- (instancetype)init:(GCDAsyncSocket *)socket;

- (void) updateValue:(NSData *)value;

@end

NS_ASSUME_NONNULL_END
