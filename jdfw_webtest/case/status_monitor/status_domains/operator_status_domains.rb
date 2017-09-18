#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'rubygems'
require './status_domains_locator'
require '/data/Ruby_for_szqjms/jdfw_webtest/tools/domains_about'
include Status_domains

#获取域名数组(未排序)
def get_domains_table(dr,row=0, column=0)
    table = dr.find_element(:xpath, Status_domains::Table_domain_mgt)
    table_rows = table.find_elements(:tag_name, 'tr')
    table_rows.delete_at(0)
    list_x = []
    table_rows.each do |row|
        list_td = row.find_elements(:tag_name ,'td')
        list_x << list_td[1].text
    end
    return list_x
end
#将域名表格的内容放在一个二维数组中
def get_domains_array(dr)
    table = dr.find_element(:xpath, Status_domains::Table_domain_mgt)
    table_rows = table.find_elements(:tag_name, 'tr')
    table_rows.delete_at(0)
    list_x = []
    table_rows.each do |row|
        list_td = row.find_elements(:tag_name ,'td')
        list_td = list_td.collect {|x| x.text}
        list_x << list_td
    end
    return list_x
end
#提交三个随机域名及备注
def submit_several_domains
    


end
#获取域名数组长度
def get_domains_table_length(dr)
    get_domains_table(dr).length
end

#获取页面底部域名input元素的值
def get_input_value_for_domains(dr)
    dr.find_element(:name, 'param_domain_name').attribute('value')
end

#双选checkbox
def checkbox_for_double_selected(dr)
    if (get_domains_table_length(dr) > 2)
    then
        dr.find_element(:xpath, Status_domains::Input_checkbox_first).click
        dr.find_element(:xpath, Status_domains::Input_checkbox_second).click
    else
        raise '没有足够的域名行'
    end
end
