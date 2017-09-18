#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'rubygems'
require 'minitest/autorun'
require 'timeout'
require '/data/Ruby_for_szqjms/jdfw_webtest/tools/public_login
require '/data/Ruby_for_szqjms/jdfw_webtest/case/status_monitor/status_domains/status_domains_locator'
require '/data/Ruby_for_szqjms/jdfw_webtest/case/status_monitor/status_domains/operator_status_domains'

#----------------------------------------域名管理---------------------------------------#

class Test_Domain_Manage < MiniTest::Test
    include Status_domains
    include Ele_status_domains
    @@status_run = 0
    @@status_setup = true
    def setup
        @@status_run +=1
        if (@@status_setup == true)
            @@driver = Selenium::WebDriver.for :chrome
            #传入driver参数给登录类
            oj_login = Login_Jdfw.new(@@driver)
            oj_login.login
            move_a = @@driver.find_element(:xpath,Status_domains::Href_status_monitor)
            @@driver.action.move_to(move_a).perform
            @@driver.find_element(:link_text, '域名管理').click
            @@status_setup = false
        end
    end
    def teardown
        if (@@status_run == Test_Domain_Manage.runnable_methods.length)
            @@driver.quit
        end
    end

    def test_verify_param_for_domains        #点击全选的checkbox，验证域名input框中字符串是否正确
        @@driver.find_element(:id,'select_all_id').click()
        input_param_domain = get_input_value_for_domains(@@driver)
        domain_list = get_domains_table(@@driver)
        domain_list.sort!
        assert_equal(input_param_domain,domain_list.join(','))
    end
    def test_verify_param_for_domains_double_selected       #选择两个checkbox，验证域名input框中字符串是否正确
        @@driver.get ("http://" + "#{$LOGIN_HOST}" + ":28099/cgi-bin/status_domains.cgi")
        checkbox_for_double_selected(@@driver)
        arr_domains = get_domains_table(@@driver)[0,2]
        arr_domains.sort!
        assert_equal(get_input_value_for_domains(@@driver), arr_domains.join(','))
    end
    def test_veriry_text_for_somebtn        #校验 "提交...导出"等按钮文本是否正确
        puts get_domains_array(@@driver)
        assert_equal('提交', Ele_status_domains.button_form_submit(@@driver).text)
        assert_equal('删除', Ele_status_domains.button_form_delete(@@driver).text)
        assert_equal('清除', Ele_status_domains.button_form_clear(@@driver).text)
        assert_equal('查询', Ele_status_domains.button_form_query(@@driver).text)
        assert_equal('导入', Ele_status_domains.button_form_import(@@driver).text)
        assert_equal('导出', Ele_status_domains.button_form_export(@@driver).text)
        assert_equal('浏览', Ele_status_domains.input_param_import_domains(@@driver).text)
    end


    
end
