import csv
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

url = "https://www.liquor.com/" # Liqour

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
browser = webdriver.Chrome(options=options)
browser.get(url)

wait = WebDriverWait(browser, 10)

title = "Name"

def tag_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.TAG_NAME, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        tag_fully_loaded(n, brows, attr)

# type search
wait.until(EC.element_to_be_clickable((By.ID, "menu-button_1-0"))).click()
wait.until(EC.element_to_be_clickable((By.XPATH, "//*[@id='fullscreen-nav_1-0']/ul/li[1]/ul/li[2]/a"))).click()
time.sleep(2)
types = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.CLASS_NAME, "truncated-list__item")

for i in range(len(types)):
    wait.until(EC.presence_of_element_located((By.ID, "child-indices_1-0")))
    if tag_fully_loaded(len(types), browser.find_element(By.ID, "child-indices_1-0"), "a"):
        type_ = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
        type_ = type_.replace('/', ' ')
        filename = "Liqour_type_{}.csv".format(type_)
        f_type = open(filename, 'w', encoding="utf-8-sig", newline="")
        writer = csv.writer(f_type)
        writer.writerow([title])
        browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[i].click()
        time.sleep(2)
        cocktails = browser.find_elements(By.CLASS_NAME, "comp.card-list__item.mntl-block")
        for cocktail in cocktails:
            name = cocktail.find_element(By.CLASS_NAME, "card__underline").text.strip()
            writer.writerow([name])
        f_type.close()
        browser.back()
    else:
        print("error: can't fully load types")
        browser.close()
browser.back()

# style search
# type and method are mixed in this web category. I will separate them when data analisys
wait.until(EC.element_to_be_clickable((By.ID, "menu-button_1-0"))).click()
wait.until(EC.element_to_be_clickable((By.XPATH, "//*[@id='fullscreen-nav_1-0']/ul/li[1]/ul/li[3]/a"))).click()
time.sleep(2)
styles = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.CLASS_NAME, "truncated-list__item")

for j in range(len(styles)):
    wait.until(EC.presence_of_element_located((By.ID, "child-indices_1-0")))
    if tag_fully_loaded(len(styles), browser.find_element(By.ID, "child-indices_1-0"), "a"):
        style_ = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[j].get_attribute("text").strip()
        style_ = style_.replace('/', ' ')
        filename = "Liqour_style_{}.csv".format(style_)
        f_style = open(filename, 'w', encoding="utf-8-sig", newline="")
        writer = csv.writer(f_style)
        writer.writerow([title])
        browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[j].click()
        time.sleep(2)
        cocktails = browser.find_elements(By.CLASS_NAME, "comp.card-list__item.mntl-block")
        for cocktail in cocktails:
            name = cocktail.find_element(By.CLASS_NAME, "card__underline").text.strip()
            writer.writerow([name])
        f_style.close()
        browser.back()
    else:
        print("error: can't fully load styles")
        browser.close()
browser.back()

# flavor search
wait.until(EC.element_to_be_clickable((By.ID, "menu-button_1-0"))).click()
wait.until(EC.element_to_be_clickable((By.XPATH, "//*[@id='fullscreen-nav_1-0']/ul/li[1]/ul/li[5]/a"))).click()
time.sleep(2)
flavor = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.CLASS_NAME, "truncated-list__item")

for k in range(len(flavor)):
    wait.until(EC.presence_of_element_located((By.ID, "child-indices_1-0")))
    if tag_fully_loaded(len(flavor), browser.find_element(By.ID, "child-indices_1-0"), "a"):
        flavor_ = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[k].get_attribute("text").strip()
        flavor_ = flavor_.replace('/', ' ')
        filename = "Liqour_flavor_{}.csv".format(flavor_)
        f_flavor = open(filename, 'w', encoding="utf-8-sig", newline="")
        writer = csv.writer(f_flavor)
        writer.writerow([title])
        browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[k].click()
        time.sleep(2)
        cocktails = browser.find_elements(By.CLASS_NAME, "comp.card-list__item.mntl-block")
        for cocktail in cocktails:
            name = cocktail.find_element(By.CLASS_NAME, "card__underline").text.strip()
            writer.writerow([name])
        f_flavor.close()
        browser.back()
    else:
        print("error: can't fully load flavor")
        browser.close()
browser.back()