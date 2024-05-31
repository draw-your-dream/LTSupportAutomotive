//
//  TCPStream.m
//  LTSupportAutomotive
//
//  Created by 江志敏 on 2024/5/28.
//  Copyright © 2024 Dr. Lauer Information Technology. All rights reserved.
//

#import "TCPReadStream.h"

@implementation TCPReadStream{
    __weak id<NSStreamDelegate> _delegate;
    
    NSStreamStatus _status;
    NSMutableData* _buffer;
    
    GCDAsyncSocket * _socket;
}

#pragma mark -
#pragma mark Lifecycle

- (instancetype)init:(GCDAsyncSocket *)socket {
    if ( ! ( self = [super init] ) )
    {
        return nil;
    }
    _socket = socket;
    return self;
}

#pragma mark -
#pragma mark Lifecycle

- (void) updateValue:(NSData *)value{
    [_buffer appendData:value];
    [self.delegate stream:self handleEvent:NSStreamEventHasBytesAvailable];
}


#pragma mark -
#pragma mark NSStream Overrides

-(void)setDelegate:(id<NSStreamDelegate>)delegate
{
    if ( _delegate == delegate )
    {
        return;
    }
    
    _delegate = delegate ?: self;
}

-(id<NSStreamDelegate>)delegate
{
    return _delegate;
}

-(void)open
{
    _status = NSStreamStatusOpening;
    _buffer = [NSMutableData data];
    _status = NSStreamStatusOpen;
    [self.delegate stream:self handleEvent:NSStreamEventOpenCompleted];
}

-(void)close
{
    _status = NSStreamStatusClosed;
    [self.delegate stream:self handleEvent:NSStreamEventEndEncountered];
}

-(void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString*)mode
{
    // nothing to do here
}

-(void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString*)mode
{
    // nothing to do here
}

-(id)propertyForKey:(NSString *)key
{
    return nil;
}

-(BOOL)setProperty:(id)property forKey:(NSString *)key
{
    // nothing to do here
    return NO;
}


#pragma mark -
#pragma mark NSInputStream Overrides

-(NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    if ( _status != NSStreamStatusOpen )
    {
        return -1;
    }
   
    NSUInteger maxBytesToRead = MIN( len, _buffer.length );
    memcpy( buffer, _buffer.bytes, maxBytesToRead );
    
    if ( len < _buffer.length )
    {
        NSData* remainingBuffer = [NSData dataWithBytes:_buffer.bytes + maxBytesToRead length:_buffer.length - maxBytesToRead];
        [_buffer setData:remainingBuffer];
    }
    else
    {
        _buffer = [NSMutableData data];
    }
    
    return maxBytesToRead;
}

-(BOOL)getBuffer:(uint8_t * _Nullable * _Nonnull)buffer length:(NSUInteger *)len
{
    return NO;
}

-(BOOL)hasBytesAvailable
{
    if ( _status != NSStreamStatusOpen )
    {
        return NO;
    }
    
    return _buffer.length > 0;
}

@end
