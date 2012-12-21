#!/usr/bin/env rdmd

import std.stdio, std.string, std.array;

void main() {
    ulong[string] dictionary;
    foreach (line; stdin.byLine()) {
        foreach (word; splitter(strip(line))) {
            if (word in dictionary) continue;
            ulong newID = dictionary.length;
            dictionary[word.idup] = newID;
            writeln(newID, '\t', word);
        }
    }
}
