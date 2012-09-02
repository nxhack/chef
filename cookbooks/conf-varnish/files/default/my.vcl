# set default backend if no server cluster specified
backend default {
  .host = "127.0.0.1"; 
  .port = "8080"; 
}

# access control list for "purge": open to only localhost and other local nodes
acl purge {
  "127.0.0.1";
}

sub vcl_recv {
# for mod_rpaf logging src IP address
  if (req.restarts == 0) {
    if (req.http.x-forwarded-for) {
      set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
    } else {
      set req.http.X-Forwarded-For = client.ip;
    }
  }

# removes all cookies named __utm? (utma, utmb...) - REMOVE! Google Analytics tracking Cookies
  if (req.http.Cookie) {
    set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *__utm.=[^;]+;? *", "\1");
   
    if (req.http.Cookie == "") {
      remove req.http.Cookie;
    }
  }

# If they are going to the mobile site, force the iphone user agent
  if (req.http.host ~ "^m.egrep.jp") {
    set req.http.user-agent = "iPhone";
  }

# Check the regular site for a few things...
  if (req.url ~ "^\/blog\/") {
# Force the http.host to be the mobile version of the site to ensure the cache lookup hits the mobile version of the site
    if(req.http.user-agent ~ "(iPhone|iPod|Android|CUPCAKE|bada|blackberry\ 9800|blackberry9500|blackberry9520|blackberry9530|blackberry 9550|dream|incognito|s8000|webOS|webmate|Opera\ Mini)") {
      set req.http.host = "m.egrep.jp";
    }
# Drop any cookies sent to Wordpress.
    if (!(req.url ~ "wp-(login|admin)")) {
      unset req.http.cookie;
    }
  }

# for Trick of DirectoryIndex OLD Static contents
  if (req.request == "GET" && req.url ~ "^\/nxhack\/") {
    if (req.url ~ "/$") {
      set req.url = req.url + "index.html";
      return (lookup);
    }
  }

# always cache these items:
  if (req.request == "GET" && req.url ~ "\.(js)") {
    return (lookup);
  }
    
# images
  if (req.request == "GET" && req.url ~ "\.(gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf)$") {
    return (lookup);
  }

# various other content pages
  if (req.request == "GET" && req.url ~ "\.(css|html)$") {
    return (lookup);
  }

# multimedia 
  if (req.request == "GET" && req.url ~ "\.(svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)$") {
    return (lookup);
  }

# xml
  if (req.request == "GET" && req.url ~ "\.(xml)$") {
    return (lookup);
  }

# Serve objects up to 2 minutes past their expiry if the backend
# is slow to respond.
  set req.grace = 120s;

# This uses the ACL action called "purge". Basically if a request to
# PURGE the cache comes from anywhere other than localhost, ignore it.
  if (req.request == "PURGE") {
    if (!client.ip ~ purge) {
      error 405 "Not allowed.";
    }
    return (lookup);
  }

# Pass any requests that Varnish does not understand straight to the backend.
  if (req.request != "GET" &&
      req.request != "HEAD" &&
      req.request != "PUT" &&
      req.request != "POST" &&
      req.request != "TRACE" &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
    /* Non-RFC2616 or CONNECT which is weird. */
    return (pipe);
  }

# Pass anything other than GET and HEAD directly.
  if (req.request != "GET" && req.request != "HEAD") {
    /* We only deal with GET and HEAD by default */
    return (pass);
  }

# Pass requests from logged-in users directly.
  if (req.http.Authorization || req.http.Cookie) {
    /* Not cacheable by default */
    return (pass);
  }

  /* Do not cache if request contains an Expect header */
  if (req.http.Expect) {
    return (pipe);
  }

# Pass any requests with the "If-None-Match" header directly.
  if (req.http.If-None-Match) {
    return (pass);
  }

# Force lookup if the request is a no-cache request from the client.
  if (req.http.Cache-Control ~ "no-cache") {
    ban_url(req.url);
  }
  
# normalize Accept-Encoding to reduce vary
  if (req.http.Accept-Encoding) {
    if (req.http.User-Agent ~ "MSIE 6") {
      unset req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      unset req.http.Accept-Encoding;
    }
  }

  return (lookup);
}

sub vcl_pipe {
# Note that only the first request to the backend will have
# X-Forwarded-For set.  If you use X-Forwarded-For and want to
# have it set for all requests, make sure to have:
# set req.http.connection = "close";

# This is otherwise not necessary if you do not do any request rewriting.
 
  set req.http.connection = "close"; 

  return (pipe);
}

# Called if the cache has a copy of the page.
sub vcl_hit {
  if (req.request == "PURGE") {
    ban_url(req.url);
    error 200 "Purged";
  }
 
  if (!(obj.ttl > 0s)) {
    return (pass);
  }

  return (deliver);
}

# Called if the cache does not have a copy of the page.
sub vcl_miss {
  if (req.request == "PURGE") {
    error 200 "Not in cache";
  }

  return (fetch);
}

# Called after a document has been successfully retrieved from the backend.
sub vcl_fetch {

# set minimum timeouts to auto-discard stored objects
#  set beresp.prefetch = -30s;
  set beresp.grace = 120s;

  if (beresp.ttl < 48h) {
    set beresp.ttl = 48h;
  }
 
# Drop any cookies Wordpress tries to send back to the client.
  if (req.url ~ "^\/blog\/") {
    if (!(req.url ~ "wp-(login|admin)")) {
      unset beresp.http.set-cookie;
    }
  }

# strip the cookie before the image is inserted into cache.
  if (req.url ~ "\.(png|gif|jpg|swf|css|js|ico|tiff|jpeg|bmp|tif)$") {
    unset beresp.http.set-cookie;
  }

  if (!(beresp.ttl > 0s)) {
    return (hit_for_pass);
  }

  if (beresp.http.Set-Cookie) {
    return (hit_for_pass);
  }

  if (req.http.Authorization && !beresp.http.Cache-Control ~ "public") {
    return (hit_for_pass);
  }  

  if (beresp.ttl > 0s) {
    /* Set how long Varnish will keep it */
#    set beresp.ttl = 1w;

# for OLD Statick Contents
    if (req.url ~ "^\/nxhack\/") {
      /* for static text/html */
      if (req.url ~ "\.html$") {
	/* Set how long Varnish will keep it */
	set beresp.ttl = 30d;

	/* Set the clients TTL on this object */
	set beresp.http.cache-control = "max-age=2592000";
      }
    }

    /* marker for vcl_deliver to reset Age: */
    set beresp.http.magicmarker = "1";
  }

  return (deliver);
}

sub vcl_deliver {
  if (resp.http.magicmarker) {
    /* Remove the magic marker */
    unset resp.http.magicmarker;

    /* By definition we have a fresh object */
    set resp.http.Age = "0";
  }

# Disable BRAIN-DAMAGED Internet Explorer 8 MIME Sniffing
  set resp.http.X-Content-Type-Options = "nosniff";

#  unset resp.http.Age;
#  unset resp.http.Server;
  unset resp.http.Via;
  unset resp.http.X-Varnish;
  unset resp.http.X-Vary-Options;

  return (deliver);
}

