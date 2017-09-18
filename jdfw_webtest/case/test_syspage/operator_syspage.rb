#封装Syspage的一系列操作类
require 'rubygems'
require 'selenium-webdriver'

class BasePage
#测试对象的基类
    def initialize dr1
        @driver = dr1
    end
end
class Syspage < BasePage
#系统页相关元素的类
    def get_cor_mainpage_link
        return @driver.find_element(:link_text, "公司首页")
    end
    def get_mod_passwd_link
        return @driver.find_element(:link_text, "修改密码")
    end
    def get_logout_link
        return @driver.find_element(:link_text, "退出登录")
    end
    def get_param_passwd
        return @driver.find_element(:name, "param_password")
    end
    def get_param_passwdchange
        return @driver.find_element(:name, "param_changepass")
    end
    def get_param_passwdcomfirm
        return @driver.find_element(:name, "param_changepass2")
    end

    def get_button_passwdchange
        return @driver.find_element(:css, 'a[href="javascript:click_changepass()"][class="button"]')
    end
    def get_button_passwdreset
        return @driver.find_element(:css, 'a[href="javascript:document.mainform.reset()"]')
    end
    def get_error_td_info
        return @driver.find_element(:id, "td_info")
    end
    def get_footer_page_bottom
        return @driver.find_element(:xpath, '/html/body/div[4]')
    end
end
