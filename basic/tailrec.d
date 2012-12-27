// dmd -O -run tailrec.d
// dmd -w -wi -O tailrec.d && time ./tailrec; rm -rf tailrec tailrec.o

import std.stdio;

auto factorial(T)(T n) {
    auto factorial1(T)(T n, T acc) {
        if (n == 0) return acc;
        return factorial1(n - 1, acc * n);
    }
    return factorial1!(T)(n, 1);
}

auto sum(T)(T n) {
    auto sum1(T)(T n, T t) {
        if (n == 0) return t;
        return sum1(n - 1, t + n);
    }
    return sum1!(T)(n, 0);
}

void main() {
    writeln("65!=", factorial!(ulong)(65));
    writeln("sum(10.000.000.000)=", sum!(ulong)(10000000000));
}
