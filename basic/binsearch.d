import std.stdio, std.array;

bool binarySearch(T)(T[] input, T value) {
    while (!input.empty) {
        auto i = input.length / 2;
        auto mid = input[i];
        if (mid > value) {
            input = input[0..i];
        }
        else if (mid < value) {
            input = input[i + 1 .. $];
        }
        else {
            return true;
        }
    }
    return false;
}

bool binarySearch2(T)(T[] input, T value) {
    if (input.empty) return false;
    auto i = input.length / 2;
    auto mid = input[i];
    if (mid > value) return binarySearch2!(T)(input[0..i], value);
    if (mid < value) return binarySearch2!(T)(input[i..$], value);
    return true;
}

void dump(T)(T[] a) {
    foreach (i, e; a)
        writeln("[", i, "]=", e);
}

void main() {
    int[] n = [1, 3, 4, 5, 8, 9];
    dump!(int)(n);
    foreach (i; [5, 7])
        writeln(i, "=", binarySearch!(int)(n, i));
}

unittest {
    assert(binarySearch!(int)([1, 3, 4, 5, 8, 9], 9));
    assert(binarySearch2!(int)([1, 3, 4, 5, 8, 9], 9));
}
