import csv
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

url = "https://www.barnonedrinks.com/drinks/by_category/" # barnonedrinks

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
browser = webdriver.Chrome(options=options)
browser.get(url)

wait = WebDriverWait(browser, 10)

filename = "Bar_None.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Type"]
writer.writerow(title)

def xpath_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.XPATH, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        xpath_fully_loaded(n, brows, attr)

def tag_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.TAG_NAME, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        tag_fully_loaded(n, brows, attr)

def scraping(brows):
    name = brows.find_element(By.CLASS_NAME, "has-lines").__getattribute__("text")
    ingredients_element = brows.find_element(By.CLASS_NAME, "bningredients").find_elements(By.TAG_NAME, "li")
    ingredients = []
    for ingredient_element in ingredients_element:
        ingredient = ingredient_element.__getattribute__("text")
        ingredients.append(ingredient)
    making = brows.find_element(By.CLASS_NAME, "bnd-c-text-sect").__getattribute__("text")
    link = brows.current_url
    writer.writerow([name, ingredients, making, link, type_is])

types = browser.find_element(By.CLASS_NAME, "bnd-c-nav").find_elements(By.TAG_NAME, "a")
for i in range(len(types)):
    if tag_fully_loaded(len(types), browser.find_element(By.CLASS_NAME, "bnd-c-nav"), "a"):
        type_is = browser.find_element(By.CLASS_NAME, "bnd-c-nav").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
        browser.find_element(By.CLASS_NAME, "bnd-c-nav").find_elements(By.TAG_NAME, "a")[i].click()
        time.sleep(2)
        alphabets = browser.find_elements(By.CLASS_NAME, "bnd-c-nav")[1].find_elements(By.TAG_NAME, "a")
        for j in range(len(alphabets)):
            if tag_fully_loaded(len(alphabets), browser.find_elements(By.CLASS_NAME, "bnd-c-nav")[1], "a"):
                browser.find_elements(By.CLASS_NAME, "bnd-c-nav")[1].find_elements(By.TAG_NAME, "a")[j].click()
                time.sleep(2)
                cocktails = browser.find_element(By.CLASS_NAME, "bnd-c-text").find_elements(By.TAG_NAME, "b")
                for k in range(len(cocktails)):
                    wait.until(EC.presence_of_element_located((By.CLASS_NAME, "bnd-c-text")))
                    if tag_fully_loaded(len(cocktails), browser.find_element(By.CLASS_NAME, "bnd-c-text"), "b"):
                        browser.find_element(By.CLASS_NAME, "bnd-c-text").find_elements(By.TAG_NAME, "b")[k].click()
                        scraping(browser)
                        browser.back()
                    else:
                        print("error: can't fully load cocktails")
                        browser.close()
                browser.back()
            else:
                print("error: can't fully load alphabets")
                browser.close()
    else:
        print("error: can't fully load types")
        browser.close()
    browser.back()

print("Done")
browser.close()
f.close()