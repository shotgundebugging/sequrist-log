Pure Rack application which logs HTTP requests to papertrailapp.com

```
<TIMESTAMP>
<IP>
URL

HTTP_HEADER: VALUE
...

</IP>
</TIMESTAMP>
```

# Usage
Configure ENV['PAPERTRAIL_SERVER'] && ENV['PAPERTRAIL_PORT']

```
gem install rack
rackup
```
