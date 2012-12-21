import std.stdio, std.socket, std.string, std.array, std.json, std.datetime, std.conv, std.regex, std.zlib;

version(unittest) { void main() {} } else { void main() { run(); } }

bool checkIP(string ip) {
    try {
        parseAddress(ip);
        return true;
    }
    catch (SocketException e)
        return false;
}

string toGMTRFC822() {
    SysTime time = Clock.currTime(UTC());
    string t = time.toSimpleString();
    return format("%s, %s %s %s %s GMT\r\n", capitalize(to!string(time.dayOfWeek())),
                  t[9..11], t[5..8], t[0..4], t[12..20]);
}

string toJSONString(string[string] data) {
    JSONValue json;
    json.type = JSON_TYPE.OBJECT;
    foreach (k, v; data) {
        json.object[k] = JSONValue();
        json.object[k].str = v;
        json.object[k].type = JSON_TYPE.STRING;
    }
    return toJSON(&json);
}

string process(string req, out bool zip) {
    string[string] res = ["status" : "400"];

    string line = std.string.split(req, "\n")[0];

    if (line.length > 0) {
        enum ctv = ctRegex!(`^GET \/\?(.*) HTTP.*`);
        auto mtv = match(line, ctv);
        if (mtv) {
            string[string] data;
            foreach (pair; std.string.split(mtv.captures[1], "&")) {
                auto p = std.string.split(pair, "=");
                data[p[0]] = (p.length > 1 ? p[1] : "");
            }
            if (data.length > 0) {
                res["status"] = "200";
                foreach (k, v; data) {
                    res[k] = v;
                }
                if ("gzip" in res) {
                    zip = true;
                }
            }
        }
    }

    return toJSONString(res);
}

void run() {
    Socket listener = new TcpSocket();
    assert(listener.isAlive);
    listener.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, 1);
    listener.bind(new InternetAddress(8888));
    listener.listen(100);

    Socket sock;
    long bytes;
    ubyte buff[1024];

    while(1) {
        sock = listener.accept();
        if ((bytes = sock.receive(buff)) > 0) {
            auto str = appender!string();
            str.put(buff[0 .. bytes]);
            bool zip;
            string response = process(str.data, zip);
            auto output = appender!string();
            output.put("HTTP/1.0 200 OK\r\n");
            output.put("Date: ");
            output.put(toGMTRFC822());
            output.put("Server: IRRD2\r\n");
            output.put("Content-Type: application/json; charset=UTF-8\r\n");
            if (zip) {
                output.put("Content-Encoding: gzip\r\n");
                output.put("Content-Length: ");
                auto zipper = new Compress(HeaderFormat.gzip);
                ubyte[] src = cast(ubyte[]) response;
                ubyte[] dst = cast(ubyte[]) zipper.compress(cast(void[]) src);
                zipper.flush();
                output.put(to!string(dst.length));
                output.put("\r\n\r\n");
                sock.sendTo(output.data);
                sock.sendTo(cast(const(void)[]) dst);
            } else {
                output.put("Content-Length: ");
                output.put(to!string(response.length));
                output.put("\r\n\r\n");
                output.put(response);
                sock.sendTo(output.data);
            }
            buff.clear();
        }
        sock.shutdown(SocketShutdown.BOTH);
        sock.close();
        buff.clear();
    }
}

unittest {
    string data = "GET /?name=ivan HTTP/1.0\r\n";
    string response = process(data);
    assert(response == "{\"status\":\"200\",\"name\":\"ivan\"}");
}

/*
 * ab -n 10000 -c 100 --add-header='Accept-Encoding: gzip\n' "http://localhost:8888/?name=ivan&gzip"
 * ab -n 10000 -c 100 "http://localhost:8888/?name=ivan"
 */

 /*
 [irocha@york nginx (master)]$ telnet localhost 8888
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
GET / HTTP/1.1
Host: localhost
Connection: close
Accept-Encoding: gzip

HTTP/1.1 200 OK
...
*/