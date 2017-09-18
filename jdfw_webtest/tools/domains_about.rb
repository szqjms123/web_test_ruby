#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'rubygems'

module Domains_file
    def self.get_a_random_domain(count)
        arr_domains = IO.readlines("/data/Ruby_for_szqjms/jdfw_webtest/test_data/domains.txt")
        puts arr_domains.sample(count)
    end
end

