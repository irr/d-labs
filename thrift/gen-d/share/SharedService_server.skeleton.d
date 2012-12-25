/*
 * This auto-generated skeleton file illustrates how to build a server. If you
 * intend to customize it, you should edit a copy with another file name to 
 * avoid overwriting it when running the generator again.
 */
module share.SharedService_server;

import std.stdio;
import thrift.codegen.processor;
import thrift.protocol.binary;
import thrift.server.simple;
import thrift.server.transport.socket;
import thrift.transport.buffered;
import thrift.util.hashset;

import share.SharedService;
import share.shared_types;


class SharedServiceHandler : SharedService {
  this() {
    // Your initialization goes here.
  }

  SharedStruct getStruct(int key) {
    // Your implementation goes here.
    writeln("getStruct called");
    return typeof(return).init;
  }

}

void main() {
  auto protocolFactory = new TBinaryProtocolFactory!();
  auto processor = new TServiceProcessor!SharedService(new SharedServiceHandler);
  auto serverTransport = new TServerSocket(9090);
  auto transportFactory = new TBufferedTransportFactory;
  auto server = new TSimpleServer(
    processor, serverTransport, transportFactory, protocolFactory);
  server.serve();
}
