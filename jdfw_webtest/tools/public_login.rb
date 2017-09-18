#公共方法类，用户提供登录等接口
require 'selenium-webdriver'
require 'rubygems'
require '/data/Ruby_for_szqjms/jdfw_webtest/conf/env_conf'
#登录相关
class Login_Jdfw
    def initialize dr1
        @driver = dr1  # 接受一个外部的driver实参来初始化登录实例
    end
    def login(current_passwd = $STR_PASSWD)
        @driver.navigate.to $LOGIN_URL

        #输入点击登录
        begin
            @driver.find_element(:name, 'param_username').send_keys($STR_USERNAME)
            @driver.find_element(:name, 'param_password').send_keys(current_passwd)
            @driver.find_element(:xpath, '//*[@id="loginform"]/div[3]/div[3]/a[1]').click
            @driver.manage.timeouts.implicit_wait = 10
        rescue  Selenium::WebDriver::Error::NoSuchElementError
            puts "Except: 无法定位元素"
        end
    end
    #封装修改密码方法
    def relogin cur_passwd
        login(cur_passwd)
    end
end


if __FILE__ == $0
    ins_login = Login_Jdfw.new(Selenium::WebDriver.for :chrome)
    ins_login.relogin("11111111")
end
