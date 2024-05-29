//
//  TCPWriteStream.h
//  LTSupportAutomotive
//
//  Created by 江志敏 on 2024/5/28.
//  Copyright © 2024 Dr. Lauer Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LTSupportAutomotive/GCDAsyncSocket.h> 

NS_ASSUME_NONNULL_BEGIN

@interface TCPWriteStream :  NSOutputStream <NSStreamDelegate>

- (instancetype)init:(GCDAsyncSocket*)socket;

- (void) didWriteValue;

@end

NS_ASSUME_NONNULL_END
