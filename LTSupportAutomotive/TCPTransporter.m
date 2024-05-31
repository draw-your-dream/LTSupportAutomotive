//
//  TCPTransporter.m
//  LTSupportAutomotive
//
//  Created by 江志敏 on 2024/5/28.
//  Copyright © 2024 Dr. Lauer Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTSupportAutomotive.h"
#import "TCPTransporter.h"
#import "TCPReadStream.h"
#import "TCPWriteStream.h"


#define DEBUG_THIS_FILE

#ifdef DEBUG_THIS_FILE
    #define XLOG LOG
#else
    #define XLOG(...)
#endif

@implementation TCPTransporter{
    NSString * _host;
    NSInteger _port;
    GCDAsyncSocket *_asyncSocket;
    
    TransporterConnectionBlock _connectionBlock;
    dispatch_queue_t _dispatchQueue;
    TCPReadStream* _inputStream;
    TCPWriteStream* _outputStream;
}

#pragma mark -
#pragma mark Lifecycle

+(instancetype)transporterWithHost:(NSString *)host andPort:(NSInteger)port {
    return [[self alloc]  initWithHost:host andPort:port] ;
}

-(instancetype)initWithHost:(NSString *)host andPort:(NSInteger)port {
    if ( ! ( self = [super init] ) )
    {
        return nil;
    }
    
    _host = host;
    _port = port;
    _dispatchQueue = dispatch_queue_create( [NSStringFromClass(self.class) UTF8String], DISPATCH_QUEUE_SERIAL );
    
    
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate: self delegateQueue: _dispatchQueue];
    
    
    return self;
}

-(void)dealloc
{
    [self disconnect];
}

#pragma mark -
#pragma mark LTTransporter

- (void)connectWithBlock:(TransporterConnectionBlock)block {
    NSError *error = nil;
    if (![_asyncSocket connectToHost:_host onPort:_port error: &error]){
        XLOG(@"Error connecting: %@", error);
    }
    _connectionBlock = block;
    
    
}

- (void)disconnect { 
    [_inputStream close];
    [_outputStream close];
}

#pragma mark -
#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    XLOG(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    _inputStream = [[TCPReadStream alloc] init:sock];
    _outputStream = [[TCPWriteStream alloc] init:sock];
    _connectionBlock( _inputStream, _outputStream );
    _connectionBlock = nil;
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    XLOG(@"socketDidDisconnect:%p withError: %@", sock, err);
    if(err){
        _connectionBlock( nil, nil );
        _connectionBlock = nil;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    XLOG(@"socket:%p didReadData:withTag:%ld", sock, tag);
    [_inputStream updateValue:data];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    XLOG(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
    [_outputStream didWriteValue];
    NSData *responseTerminatorData = [@">" dataUsingEncoding:NSASCIIStringEncoding];
    [sock readDataToData:responseTerminatorData withTimeout:-1 tag:0];
}


@end
