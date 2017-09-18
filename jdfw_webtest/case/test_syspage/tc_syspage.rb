#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'rubygems'
require 'minitest/autorun'
require 'timeout'
require '/data/Ruby_for_szqjms/jdfw_webtest/tools/public_login
require '/data/Ruby_for_szqjms/jdfw_webtest/case/test_syspage/operator_syspage'
  
class Test_Page_Link < MiniTest::Test       #测试main page的几个链接是否正常
    def setup
        @driver = Selenium::WebDriver.for :chrome
        #传入driver参数给登录类
        oj_login = Login_Jdfw.new(@driver)
        oj_login.login 
    end

    def test_syspage_tab    #测试主页有无"状态监控"--"服务支持"等Tab签
        wait = Selenium::WebDriver::Wait.new(:timeout => 5)
        wait.until { @driver.find_element(:link_text, '状态监控').displayed? }
        wait.until { @driver.find_element(:link_text, '攻击防御').displayed? }
        wait.until { @driver.find_element(:link_text, '日志分析').displayed? }
        wait.until { @driver.find_element(:link_text, '系统配置').displayed? }
        wait.until { @driver.find_element(:link_text, '服务支持').displayed? }
    end

    def test_sys_page       #测试主页的几个文字链接
        #初始化syspage操作类
        sys_page = Syspage.new(@driver)
        cor_mainpage_link = sys_page.get_cor_mainpage_link
        mod_passwd_link = sys_page.get_mod_passwd_link
        logout_link = sys_page.get_logout_link
        footer_div = sys_page.get_footer_page_bottom
        #断言<a> </a>元素文本 
        assert_equal("© 中新网络信息安全股份有限公司 版权所有 2003-2017", footer_div.text)
        assert_equal("公司首页", cor_mainpage_link.text)
        assert_equal( "修改密码", mod_passwd_link.text)
        assert_equal("退出登录", logout_link.text)
        #公司首页链接是否正确
        current_handle = @driver.window_handle  #获取新窗口的句柄
        cor_mainpage_link.click   #点击 公司主页 链接
        all_handles =  @driver.window_handles
        all_handles.each do |handle|
            if handle != current_handle
                @driver.switch_to.window(handle)
                assert_equal( "http://www.cnzxsoft.com/", @driver.current_url)

                @driver.switch_to.window(current_handle)   #返回主窗口
            end
        end
        #断言出现修改密码表格
        mod_passwd_link.click()
        assert_equal("http://#{$LOGIN_HOST}:28099/zh-cn/setting_changepass.htm", @driver.current_url)
        mod_passwd1 = @driver.find_element(:css, 'a[href="javascript:click_changepass()"][class="button"]')
        wait = Selenium::WebDriver::Wait.new(:timeout => 5)
        wait.until { mod_passwd1.displayed? }                 #等待10s，查看是否有mod_passwd1元素
    end
    def teardown
        @driver.quit
    end
end

class Test_Pwdchange_Errorinput < MiniTest::Test        #主页修改密码input框输入异常值
    def setup
        @driver = Selenium::WebDriver.for :chrome
        #传入driver参数给登录类
        oj_login = Login_Jdfw.new(@driver)
        oj_login.login
    end

    def test_passwd_errorinput      #测试错误的密码输入
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until { @driver.find_element(:link_text, '状态监控').displayed? }
        # 初始化syspage操作类
        sys_page = Syspage.new(@driver)
        mod_passwd_link = sys_page.get_mod_passwd_link

        #测试修改密码table的功能
        mod_passwd_link.click()
        @driver.manage.timeouts.implicit_wait = 5
        param_cur_passwd = sys_page.get_param_passwd()
        param_change_passwd = sys_page.get_param_passwdchange()
        param_change_comfirm = sys_page.get_param_passwdcomfirm()
        button_passwdchange = sys_page.get_button_passwdchange()
        param_cur_passwd.send_keys("123")
        param_change_passwd.send_keys("17_a#")
        param_change_comfirm.send_keys("zx_123")
        button_passwdchange.click()
        sleep(2)
        #切换到alter警告框
        assert_equal("两次输入密码不匹配，请重新输入", @driver.switch_to.alert.text)
        @driver.switch_to.alert.accept()
        @driver.get("http://"+$LOGIN_HOST+":28099/zh-cn/setting_changepass.htm")
        begin
            param_cur_passwd = sys_page.get_param_passwd()
            param_change_passwd = sys_page.get_param_passwdchange()
            param_change_comfirm = sys_page.get_param_passwdcomfirm()
            button_passwdchange = sys_page.get_button_passwdchange()
            param_cur_passwd.clear()
            param_cur_passwd.send_keys("123")
            param_change_passwd.clear()
            param_change_passwd.send_keys("123")
            param_change_comfirm.clear()
            param_change_comfirm.send_keys("123")
            button_passwdchange.click()
            #切换到alter警告框
            sleep(2)
            assert_equal("新旧密码相同，请重新输入", @driver.switch_to.alert.text)
            @driver.switch_to.alert.accept()
        rescue Exception => e
            print("弹出alter时错误:", e)
        end

        #测试原密码输入错误的情况
        @driver.navigate.to("http://"+$LOGIN_HOST+":28099/zh-cn/setting_changepass.htm")
        param_cur_passwd = sys_page.get_param_passwd()
        param_change_passwd = sys_page.get_param_passwdchange()
        param_change_comfirm = sys_page.get_param_passwdcomfirm()
        button_passwdchange = sys_page.get_button_passwdchange()
        param_cur_passwd.clear()
        param_cur_passwd.send_keys("zx_123#")
        param_change_passwd.clear()
        param_change_passwd.send_keys("1234")
        param_change_comfirm.clear()
        param_change_comfirm.send_keys("1234")
        button_passwdchange.click()
        @driver.manage.timeouts.implicit_wait = 5
        begin
            error_td_info = sys_page.get_error_td_info()
            assert(error_td_info.text.include? "用户密码修改失败!")
        rescue Selenium::WebDriver::Error::NoSuchElementError => e
            print("元素未见 ", e)
        end
    end
    def teardown
        @driver.quit
    end
end

class Test_Page_Pwdchange < MiniTest::Test      #测试主页修改密码功能
    @@status_var = false
    @@status_setup = true
    @@status_run = 0
    def setup
        @@status_run+=1
        if @@status_setup
            @@driver = Selenium::WebDriver.for :chrome
            #传入driver参数给登录类
            @@oj_login = Login_Jdfw.new(@@driver)
            @@oj_login.login
            @@status_setup = false
        end
    end
    def teardown
        if (@@status_run == Test_Page_Pwdchange.runnable_methods.length)
            @@driver.quit
        end
    end

    def test_mod_passwd     #测试主页密码修改功能
        wait = Selenium::WebDriver::Wait.new(:timeout => 3)
        wait.until {@@driver.find_element(:link_text,"状态监控")}
        sys_page = Syspage.new(@@driver)
        mod_passwd_link = sys_page.get_mod_passwd_link()

        #测试修改密码table的功能
        mod_passwd_link.click()
        @@driver.manage.timeouts.implicit_wait = 5
        begin
            param_cur_passwd = sys_page.get_param_passwd()
            param_change_passwd = sys_page.get_param_passwdchange()
            param_change_comfirm = sys_page.get_param_passwdcomfirm()
            button_passwdchange = sys_page.get_button_passwdchange()
            param_cur_passwd.send_keys("123")
            param_change_passwd.send_keys("Zxsoft_123")
            param_change_comfirm.send_keys("Zxsoft_123")
            button_passwdchange.click()
            sleep(2)
            assert_equal("用户密码已经修改成功！请使用新密码重新登录！",  @@driver.switch_to.alert.text, "修改密码异常")
            @@driver.switch_to.alert.accept()
            @@driver.manage.timeouts.implicit_wait = 5

            self.assert_equal($LOGIN_URL, @@driver.current_url)
            @@status_var = true
        rescue Exception => e
            print("修改密码失败", e.inspect)
        end

    #将密码重新置为默认密码
        if (@@status_var == true)
            @@oj_login.relogin('Zxsoft_123')
            sys_page = Syspage.new(@@driver)
            mod_passwd_link = sys_page.get_mod_passwd_link()
            mod_passwd_link.click()
            @@driver.manage.timeouts.implicit_wait = 5
            begin
                param_cur_passwd = sys_page.get_param_passwd()
                param_change_passwd = sys_page.get_param_passwdchange()
                param_change_comfirm = sys_page.get_param_passwdcomfirm()
                button_passwdchange = sys_page.get_button_passwdchange()
                param_cur_passwd.send_keys("Zxsoft_123")
                param_change_passwd.send_keys("123")
                param_change_comfirm.send_keys("123")
                button_passwdchange.click()
                sleep(2)
                assert_equal( "用户密码已经修改成功！请使用新密码重新登录！",@@driver.switch_to.alert.text, "修改密码异常")
            rescue Exception => e
                print("reset密码失败:", e)
            end
        end
    end
end

class Test_Page_Logout < MiniTest::Test     #测试系统登出功能
    def setup
        @@driver = Selenium::WebDriver.for :chrome
        #传入driver参数给登录类
        oj_login = Login_Jdfw.new(@@driver)
        oj_login.login
    end
    def teardown
        @@driver.quit
    end
    def test_logout     #测试系统登出功能
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until {@@driver.find_element(:link_text, "状态监控")}
        sys_page = Syspage.new(@@driver)
        begin
            href_logout = sys_page.get_logout_link()
            href_logout.click()
        rescue Selenium::WebDriver::Error::NoSuchElementExceptionError => e
            print("未定位到元素:", e)
        wait1 = Selenium::WebDriver::Wait.new(:time => 10)
        wait1.until {@@driver.find_element(:css, 'div[id="login-zh-cn"][class="logincontainer"]')}
        end
    end
end
