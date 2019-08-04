require 'date'
require 'rack'
require 'remote_syslog_logger'

class Sequrist::Logger
  def call(env)
    @request = ::Rack::Request.new(env)
    @logger = RemoteSyslogLogger.new(ENV['PAPERTRAIL_SERVER'], ENV['PAPERTRAIL_PORT'])
    @time = Time.now

    @file = File.open(filename, "a")
      log2 "<#{timestamp}>"
      log2 "<#{@request.ip}>"
      log2 @request.url
      log2 "\n"

      @request.each_header do |k, v|
        if k.start_with?('HTTP_')
          log2 "#{k}: #{v}"
        end
      end

      log2 "\n"
      log2 @request.body.gets
      log2 "</#{@request.ip}>"
      log2 "</#{timestamp}>"
    @file.close

    respond!
  end

  def timestamp
    @time.iso8601
  end

  def filename
    "log/#{@time.strftime("%Y-%m-%d-%H-%M-%L")}-#{@request.ip}"
  end

  def log2(text)
    log2file(text)
    log2papertrail(text)
  end

  def log2file(text)
    @file.puts(text)
  end

  def log2papertrail(text)
    @logger.info(text)
  end

  def respond!
    response_body = '<html></html>'

    [
      200,
      {
        'Content-Type' => 'text/html',
        'Content-Length' => response_body.length.to_s
      },
        [response_body]
    ]
  end
end
