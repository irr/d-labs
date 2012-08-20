import std.stdio, std.string;

// http://dlang.org/interfaceToC.html

extern (C) {
    int strcmp(char* string1, char* string2);
    size_t strlen(const char *s);
}

int mystrcmp(string s) { 
    return strcmp(cast(char*)s.ptr, cast(char*)s.ptr); 
} 

size_t mystrlen(string s) { 
    return strlen(cast(const char*)s.ptr); 
} 

void main() {
    writeln("D2Cstrcmp = ", mystrcmp("foo"));
    writeln("D2Cstrlen = ", mystrlen("foo"));
}
