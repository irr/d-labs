import std.stdio;
import deimos.event2.event;

// cd /data/D
// git clone https://github.com/D-Programming-Deimos/libevent.git
// dmd -I/data/D/libevent -L-levent -O event.d

void main()
{
    auto base = event_base_new();
     
    auto tv = new timeval;
    tv.tv_sec = cast(int) 3;
    tv.tv_usec = cast(int) 0;

    event_base_once(base, -1, EV_TIMEOUT, &foo, null, tv);
    event_base_loop(base, 0);
}


extern(C) void foo(int fd, short type, void* arg)
{
    writefln("Boo.");
}