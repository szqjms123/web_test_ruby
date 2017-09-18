# -*- coding: utf-8 -*-
import time
import sys
sys.path.append("..")
from selenium import webdriver
import unittest
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
from selenium.common.exceptions import NoSuchElementException
import Public_Method
from Public_Method import Login_JDFW
from ServiceSupport_Locators import Sersupport
import env_conf

class Test_Page_Somehref(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.driver = webdriver.Chrome()
        #传入driver参数给登录类
        cls.oj_login = Login_JDFW(cls.driver)
        cls.oj_login.login()

    def test_href_text(self):
        # webdriver触发鼠标悬停事件
        print(Sersupport.xpath_support_service)
        move_a = self.driver.find_element(By.XPATH,Sersupport.xpath_support_service)
        ActionChains(self.driver).move_to_element(move_a).perform()
        WebDriverWait(self.driver, 5).until(EC.visibility_of(self.driver.find_element(By.LINK_TEXT, '关于我们')))
        WebDriverWait(self.driver, 5).until(EC.visibility_of(self.driver.find_element(By.LINK_TEXT, '版本信息')))
        WebDriverWait(self.driver, 5).until(EC.visibility_of(self.driver.find_element(By.LINK_TEXT, '报文捕捉')))
        WebDriverWait(self.driver, 5).until(EC.visibility_of(self.driver.find_element(By.LINK_TEXT, '产品升级')))

    def test_abc(self):
        pass

    @classmethod
    def tearDownClass(cls):
        cls.driver.quit()














if __name__ == '__main__':
    unittest.main()