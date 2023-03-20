import csv
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver import ActionChains

url = "https://iba-world.com/iba-official-cocktail-list/" # IBA

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
browser = webdriver.Chrome(options=options)
browser.get(url)

filename = "IBA.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Garnish", "Type"]
writer.writerow(title)

def class_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.CLASS_NAME, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        class_fully_loaded(n, brows, attr)

def xpath_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.XPATH, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        xpath_fully_loaded(n, brows, attr)

def scraping(brows):
    time.sleep(2)
    name = brows.find_element(By.CLASS_NAME, "et_pb_title_container").find_element(By.TAG_NAME, "h1").text.strip()
    list_p = brows.find_element(By.CLASS_NAME, "et_pb_module.et_pb_post_content.et_pb_post_content_0_tb_body.blog-post-content").find_elements(By.TAG_NAME, "p")
    list_h3 = brows.find_element(By.CLASS_NAME, "et_pb_module.et_pb_post_content.et_pb_post_content_0_tb_body.blog-post-content").find_elements(By.TAG_NAME, "h3")
    list_b = brows.find_element(By.CLASS_NAME, "et_pb_module.et_pb_post_content.et_pb_post_content_0_tb_body.blog-post-content").find_elements(By.TAG_NAME, "b")
    if len(list_h3)!=0:
        if len(list_b)!=0:
            if list_b[2].text.strip()=="GARNISH":
                if len(list_p)==3:
                    ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[1], list_p[2]
                elif len(list_p)==5:
                    ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[1], list_p[2]
                elif len(list_p)>=7:
                    ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[1], list_p[2]
                else:
                    ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[2], list_p[3]
            else:
                if len(list_p)==4:
                    ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[1], list_p[3]
                else:
                    ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[1], list_p[2]
        else:
            ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[1], list_p[2]
    else:
        if len(list_b)!=0:
            if len(list_p)==6:
                ingredients_elem, making_elem, garnish_elem = list_p[1], list_p[3], list_p[5]
            else:
                ingredients_elem, making_elem, garnish_elem = list_p[0], list_p[1], list_p[2]
        else:
            ingredients_elem, making_elem, garnish_elem = list_p[1], list_p[3], list_p[5]
    ingredients = ingredients_elem.text.strip()
    making = making_elem.text.strip()
    garnish = garnish_elem.text.strip()
    link = brows.current_url
    writer.writerow([name, ingredients, making, link, garnish, type_])

browser.find_element(By.CLASS_NAME, "avwp-av").find_element(By.CLASS_NAME, "yes").click()
time.sleep(2)
browser.find_element(By.ID, "cookie_action_close_header").click()
time.sleep(2)
sets = browser.find_elements(By.XPATH, "//a[contains(text(), 'VIEW ALL')]")
for i in range(len(sets)):
    if xpath_fully_loaded(len(sets), browser, "//a[contains(text(), 'VIEW ALL')]"):
        browser.find_elements(By.XPATH, "//a[contains(text(), 'VIEW ALL')]")[i].click()
        type_ = browser.find_element(By.CLASS_NAME, "et_pb_text_inner").text.strip()
        articles = browser.find_elements(By.CLASS_NAME, "et_pb_image_container")
        for j in range(len(articles)):
            if class_fully_loaded(len(articles), browser, "et_pb_image_container"):
                some_tag = browser.find_elements(By.CLASS_NAME, "et_pb_image_container")[j]
                action = ActionChains(browser)
                action.move_to_element(some_tag).perform()
                browser.find_elements(By.CLASS_NAME, "et_pb_image_container")[j].click()
                scraping(browser)
                browser.back()
            else:
                print("error: can't fully load articles")
                browser.close()
        browser.back()
    else:
        print("error: can't fully load sets")
        browser.close()

print("Done")
browser.close()
f.close()