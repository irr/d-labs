#!/usr/bin/env rdmd

import std.json;
import std.conv;
import std.traits;

JSONValue toJsonValue(T)(T a) {
    JSONValue val;
    static if(is(T == typeof(null))) {
        val.type = JSON_TYPE.NULL;
    } else static if(is(T == JSONValue)) {
            val = a;
        } else static if(isIntegral!(T)) {
            val.type = JSON_TYPE.INTEGER;
            val.integer = to!long(a);
        } else static if(isFloatingPoint!(T)) {
            val.type = JSON_TYPE.FLOAT;
            val.floating = to!real(a);
        } else static if(is(T == bool)) {
            if(a == true)
                val.type = JSON_TYPE.TRUE;
            if(a == false)
                val.type = JSON_TYPE.FALSE;
        } else static if(isSomeString!(T)) {
            val.type = JSON_TYPE.STRING;
            val.str = to!string(a);
        } else static if(isAssociativeArray!(T)) {
            val.type = JSON_TYPE.OBJECT;
            foreach(k, v; a) {
                val.object[to!string(k)] = toJsonValue(v);
            }
        } else static if(isArray!(T)) {
            val.type = JSON_TYPE.ARRAY;
            val.array.length = a.length;
            foreach(i, v; a) {
                val.array[i] = toJsonValue(v);
            }
        } else static if(is(T == struct)) { // also can do all members of a struct...
            val.type = JSON_TYPE.OBJECT;

            foreach(i, member; a.tupleof) {
                string name = a.tupleof[i].stringof[2..$];
                static if(a.tupleof[i].stringof[2] != '_')
                    val.object[name] = toJsonValue!(typeof(member), R)(member,
                                                                       formatToStringAs, api);
            }
        } else { /* our catch all is to just do strings */
            val.type = JSON_TYPE.STRING;
            val.str = to!string(a);
        }

    return val;
}

string toJson(T)(T a) {
    auto v = toJsonValue(a);
    return toJSON(&v);
}

/* usage example */
import std.stdio;
void main() {
    writeln(toJson(["message": "Hello, world!"]));
}

