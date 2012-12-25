/*
 * This auto-generated skeleton file illustrates how to build a server. If you
 * intend to customize it, you should edit a copy with another file name to 
 * avoid overwriting it when running the generator again.
 */
module tutorial.Calculator_server;

import std.stdio;
import thrift.codegen.processor;
import thrift.protocol.binary;
import thrift.server.simple;
import thrift.server.transport.socket;
import thrift.transport.buffered;
import thrift.util.hashset;

import tutorial.Calculator;
import tutorial.tutorial_types;


class CalculatorHandler : Calculator {
  this() {
    // Your initialization goes here.
  }

  void ping() {
    // Your implementation goes here.
    writeln("ping called");
  }

  int add(int num1, int num2) {
    // Your implementation goes here.
    writeln("add called");
    return typeof(return).init;
  }

  int calculate(int logid, ref const(Work) w) {
    // Your implementation goes here.
    writeln("calculate called");
    return typeof(return).init;
  }

  void zip() {
    // Your implementation goes here.
    writeln("zip called");
  }

}

void main() {
  auto protocolFactory = new TBinaryProtocolFactory!();
  auto processor = new TServiceProcessor!Calculator(new CalculatorHandler);
  auto serverTransport = new TServerSocket(9090);
  auto transportFactory = new TBufferedTransportFactory;
  auto server = new TSimpleServer(
    processor, serverTransport, transportFactory, protocolFactory);
  server.serve();
}
