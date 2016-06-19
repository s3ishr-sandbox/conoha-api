#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'net/https'
require 'yaml'
require 'json'
require 'pp'

# ~/.conoha.yml
#   API_USERNAME: gncuXXXXXXXX
#   API_PASSWORD: YOUR_PASSWORD
#   TENANT_ID:    YOUR_TENANT_ID
#   REGION:       (tyo1|sin1|sjc1)

path   = File.join(ENV['HOME'], '.conoha.yml')
config = YAML.load_file(path)

credential = {
  auth: {
    passwordCredentials: {
      username: config['API_USERNAME'],
      password: config['API_PASSWORD']
    },
    tenantId: config['TENANT_ID']
  }
}

uri = URI.parse("https://identity.#{config['REGION']}.conoha.io/v2.0/tokens")
req = Net::HTTP::Post.new uri
res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
  req.body = JSON[credential]
  req['Accept'] = 'application/json'
  http.request req
end

pp JSON[res.body]
