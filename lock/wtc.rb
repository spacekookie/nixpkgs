#!/usr/bin/env ruby

require 'net/http'
URL = "http://whatthecommit.com/"

256.times do
    message = Net::HTTP.get(URI.parse(URL)).match(/<p>(.*?)<\/p>/m)[1].strip
    puts message
    `echo #{message} >> messages`
end
