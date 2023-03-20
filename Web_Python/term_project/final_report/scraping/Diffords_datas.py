# _fully_loaded 함수에 time.sleep(2)추가해줌
# flavor 부분 약간 수정
# curr_page 코드에 wait 추가
import csv
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# url = "https://www.diffordsguide.com/" # difford's guide

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
browser = webdriver.Chrome(options=options)
wait = WebDriverWait(browser, 60)
# browser.get(url)

# browser.find_element(By.ID, "accept-cookies-button").click()
# browser.find_element(By.XPATH, "/html/body/div[3]/div[2]/div[1]/div/div/a[2]").click()
# browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
# browser.find_element(By.ID, "search-submit").click()

filename = "Difford's_Guide.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Glass", "Garnish", "Type", "Flavor"]
writer.writerow(title)

def xpath_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.XPATH, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        time.sleep(2)
        xpath_fully_loaded(n, brows, attr)

def tag_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.TAG_NAME, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        time.sleep(2)
        tag_fully_loaded(n, brows, attr)

def scraping(brows):
    name = brows.find_element(By.TAG_NAME, "h1").__getattribute__("text").strip()
    article = brows.find_element(By.TAG_NAME, "article")
    glass = article.find_element(By.TAG_NAME, "a").__getattribute__("text").strip()
    garnish = article.find_elements(By.TAG_NAME, "p")[0].__getattribute__("text").strip()
    making = article.find_elements(By.TAG_NAME, "p")[1].__getattribute__("text").strip()
    ingredients = []
    ingredients_element = article.find_element(By.TAG_NAME, "tbody").find_elements(By.TAG_NAME, "tr")[:-1]
    for ingredient_element in ingredients_element:
        ingredient = ingredient_element.find_elements(By.TAG_NAME, "td")
        volume = ingredient[0].__getattribute__("text").strip()
        ing_name = ingredient[1].__getattribute__("text").strip()
        ingredients.append(str(volume+" "+ing_name))
    link = brows.current_url
    alcohol_contain = article.find_element(By.TAG_NAME, "ul").find_element(By.TAG_NAME, "li").__getattribute__("text").strip()
    if alcohol_contain=="0 standard drinks":
        type_ = "Nonalcoholic"
#        writer.writerow([name, ingredients, making, link, glass, garnish, "Nonalcoholic"])
    else:
#        writer.writerow([name, ingredients, making, link, glass, garnish])
        type_ = None
    flavor_elems = brows.find_elements(By.CLASS_NAME, "svg-range")
    if len(flavor_elems)!=0:
        try:
            flavor_1 = "Gentle 0 - Boozy 10: "+flavor_elems[0].find_element(By.TAG_NAME, "img").get_attribute("alt").strip()
            flavor_2 = "Sweet 0 - Dry/Sour 10: "+flavor_elems[1].find_element(By.TAG_NAME, "img").get_attribute("alt").strip()
            flavor = [flavor_1, flavor_2]
        except:
            flavor = None
    else:
        flavor = None
    writer.writerow([name, ingredients, making, link, glass, garnish, type_, flavor])

url = "https://www.diffordsguide.com/cocktails/search?include%5Bdg%5D=1&limit=20&sort=rating&offset=4460"
browser.get(url)
time.sleep(2)

browser.find_element(By.ID, "accept-cookies-button").click()
prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

# print(len(browser.find_elements(By.ID, "subscribe-modal")))
# 1개
# print(len(browser.find_elements(By.ID, "reveal-overlay")))
# 0개

first_cocktail = browser.find_element(By.ID, "search-form").find_elements(By.TAG_NAME, "a")[1]
wait.until(EC.element_to_be_clickable(first_cocktail)).click()
wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'No thanks, continue to diffordsguide.com')]"))).click()
browser.back()

while True:
    cocktails = browser.find_element(By.ID, "search-form").find_elements(By.TAG_NAME, "a")
    for i in range(1, len(cocktails)):
        if tag_fully_loaded(len(cocktails), browser.find_element(By.ID, "search-form"), "a"):
            browser.find_element(By.ID, "search-form").find_elements(By.TAG_NAME, "a")[i].click()
            scraping(browser)
            browser.back()
        else:
            print("error: can't fully load cocktails")
            browser.close()
    browser.find_element(By.ID, "next-page").click()
    curr_page = wait.until(EC.presence_of_element_located((By.XPATH, "//*[@id='custom-select-1']/button/span[1]"))).text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("Done")
browser.close()
f.close()