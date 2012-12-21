import tinyredis.redis;

// https://github.com/adilbaig/Tiny-Redis
// dmd -I~/git/Tiny-Redis redis.d libtinyredis_x64.a
// dmd redis.d ~/git/Tiny-Redis/tinyredis/*

void main()
{
    auto redis = new Redis();
    auto response = redis.send("LASTSAVE");
    assert(response.type == ResponseType.Integer);
    
    assert(redis.send!(bool)("SET", "name", "adil"));
    
    response = redis.send("GET name");
    assert(response.type == ResponseType.Bulk);
    assert(response.value == "adil");
    
    assert(redis.send!(string)("GET name") == "adil");
    
    response = redis.send("GET nonexistentkey");
    assert(response.type == ResponseType.Nil);
    
    redis.send("DEL myset");
    redis.send("SADD", "myset", 1);
    redis.send("SADD", "myset", 1.2);
    redis.send("SADD", "myset", true);
    redis.send("SADD", "myset", "adil");
    redis.send("SADD", "myset", 350001939);
    redis.send("SADD",["myset","$4"]);
    auto r = redis.send("SMEMBERS myset");
    assert(r.type == ResponseType.MultiBulk);
    assert(r.values.length == 6);
    
    //Check pipeline
    redis.send("DEL ctr");
    auto responses = redis.pipeline(["SET ctr 1", "INCR ctr", "INCR ctr", "INCR ctr", "INCR ctr"]);
    
    assert(responses.length == 5);
    assert(responses[0].type == ResponseType.Status);
    assert(responses[1].intval == 2);
    assert(responses[2].intval == 3);
    assert(responses[3].intval == 4);
    assert(responses[4].intval == 5);
    
    //Check transaction
    redis.send("DEL ctr");
    responses = redis.transaction(["SET ctr 1", "INCR ctr", "INCR ctr"], true);
    assert(responses.length == 5);
    assert(responses[0].type == ResponseType.Status);
    assert(responses[1].type == ResponseType.Status);
    assert(responses[2].type == ResponseType.Status);
    assert(responses[3].type == ResponseType.Status);
    assert(responses[4].type == ResponseType.MultiBulk);
    assert(responses[4].values[0].type == ResponseType.Status);
    assert(responses[4].values[1].intval == 2);
    assert(responses[4].values[2].intval == 3);
    
    redis.send("DEL ctr");
    responses = redis.transaction(["SET ctr 1", "INCR ctr", "INCR ctr"]);
    assert(responses.length == 3);
    assert(responses[0].type == ResponseType.Status);
    assert(responses[1].intval == 2);
    assert(responses[2].intval == 3);
}