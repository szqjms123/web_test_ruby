#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'rubygems'
=begin
puts $LOGIN_URL
dr = Selenium::WebDriver.for :chrome
dr.navigate.to $LOGIN_URL
dr.quit
=end
css_s = 'a[class="button"][href="javascript:submit_form(\'submit\')"]'
puts(css_s)

