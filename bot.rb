if RUBY_VERSION < '1.9'
  require 'rubygems'
end
require 'sinatra'
require 'json'

def sandbox(&code)
  proc {
    $SAFE = 2
    eval &code
  }.call
  
end

get '/' do
  "Here is raa0121's sinatra app"
end

post '/' do
  content_type :text
  json = JSON.parse(request.body.string)
  json["events"].map do |e|
    if e["message"]
      m = e["message"]["text"]
      if /^!\s?(.*)/ =~ m
        x = Thread.start do
          $SAFE = 2
          eval "#{$1}"
        end
          "#{x.value}"
          #sandbox{$1}
      end
    end
  end
end
