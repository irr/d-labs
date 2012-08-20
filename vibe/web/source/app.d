import vibe.d;
import vibe.db.redis.redis;

void handleRequest(HttpServerRequest req,
                   HttpServerResponse res)
{
	setLogLevel(LogLevel.Info);

	runTask({
		auto redis = new RedisClient();
		redis.connect();
		redis.setBit("test", 15, true);
		logInfo("Result: %s", redis.getBit("test", 15));
	});

	res.writeBody("Hello, World!", "text/plain");
}

static this()
{
	auto settings = new HttpServerSettings;
	settings.port = 8888;

	listenHttp(settings, &handleRequest);
}