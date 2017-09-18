#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'rubygems'
module Status_domains
    #------------------------------------XPATH-----------------------------------#
    Href_status_monitor = '/html/body/div[2]/div/div[1]/a[1]'   #状态监控链接
    Table_domain_mgt = '/html/body/form/div[1]/div/table[2]'    #域名管理模块-> 域名管理表格
    Input_checkbox_first = '/html/body/form/div[1]/div/table[2]/tbody/tr[2]/td[1]/input'
    Input_checkbox_second = '/html/body/form/div[1]/div/table[2]/tbody/tr[3]/td[1]/input'

end

module Ele_status_domains
    #定义下方的 "域名--导入导出"等按钮
    def self.button_form_submit(dr)
        css_s = 'a[class="button"][href="javascript:submit_form(\'submit\')"]'
        dr.find_element(:css, css_s)
    end
    def self.button_form_delete(dr)
        css_s = 'a[class="button"][href="javascript:submit_form(\'delete\')"]'
        dr.find_element(:css, css_s)
    end
    def self.button_form_query(dr)
        css_s = 'a[class="button"][href="javascript:submit_form(\'query\')"]'
        dr.find_element(:css, css_s)
    end
    def self.button_form_clear(dr)
        css_s = 'a[class="button"][href="javascript:submit_form(\'clear\')"]'
        dr.find_element(:css, css_s)
    end
    def self.button_form_import(dr)
        css_s = 'a[class="button"][href="javascript:submit_form(\'import\')"]'
        dr.find_element(:css, css_s)
    end
    def self.button_form_export(dr)
        css_s = 'a[class="button"][href="javascript:submit_form(\'export\')"]'
        dr.find_element(:css, css_s)
    end
    def self.input_param_import_domains(dr)      #状态监控-> 域名管理: 浏览input
        css_s = 'a[class="button"][href="#"]'
        dr.find_element(:css, css_s)
    end





end
