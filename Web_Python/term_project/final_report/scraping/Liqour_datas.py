# _fully_loaded 함수에 time.sleep(2)추가
# _fully_loaded 쓰인 if문의 else에서 browser.close() 뺌

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
wait = WebDriverWait(browser, 10)
browser.get(url)

filename = "Liqour.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Base"]
writer.writerow(title)

def is_in_class(brows, class_name):
    try:
        wating = WebDriverWait(brows, 2).until(EC.presence_of_element_located((By.CLASS_NAME, class_name)))
    except:
        return False
    return True 

def is_in_id(brows, id):
    try:
        wating = WebDriverWait(brows, 2).until(EC.presence_of_element_located((By.ID, id)))
    except:
        return False
    return True 

def is_in_xpath(brows, xpath):
    try:
        wating = WebDriverWait(brows, 2).until(EC.presence_of_element_located((By.XPATH, xpath)))
    except:
        return False
    return True 

def id_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.ID, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        time.sleep(2)
        id_fully_loaded(n, brows, attr)

def tag_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.TAG_NAME, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        time.sleep(2)
        tag_fully_loaded(n, brows, attr)

def xpath_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.XPATH, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        time.sleep(2)
        xpath_fully_loaded(n, brows, attr)

def class_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.CLASS_NAME, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        time.sleep(2)
        class_fully_loaded(n, brows, attr)

def scraping(brows):
    name = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "heading__title"))).text.strip()
    ingredients = []
    if is_in_class(browser, "structured-ingredients__list-item"):
        ingredients_elem = brows.find_elements(By.CLASS_NAME, "structured-ingredients__list-item")
        for ingredient_elem in ingredients_elem:
            pieces = ingredient_elem.find_elements(By.TAG_NAME, "span")
            ingredient = ""
            for n in range(len(pieces)):
                ingredient = ingredient+ingredient_elem.find_elements(By.TAG_NAME, "span")[n].text.strip()+" "
            ingredients.append(ingredient.strip())
    else:
        ingredients_elem = brows.find_elements(By.CLASS_NAME, "simple-list__item.js-checkbox-trigger.ingredient.text-passage")
        for ingredient_elem in ingredients_elem:
            ingredient = ""
            ingredient = ingredient+ingredient_elem.text.strip()+" "
            ingredients.append(ingredient.strip())
    makings = brows.find_element(By.ID, "structured-project__steps_1-0").find_elements(By.TAG_NAME, "p")
    making = ""
    for m in range(len(makings)):
        making = making+brows.find_element(By.ID, "structured-project__steps_1-0").find_elements(By.TAG_NAME, "p")[m].text.strip()+"\n"
    making = making.strip()
    link = brows.current_url
    return [name, ingredients, making, link]

wait.until(EC.element_to_be_clickable((By.ID, "menu-button_1-0"))).click()
wait.until(EC.element_to_be_clickable((By.XPATH, "//*[@id='fullscreen-nav_1-0']/ul/li[1]/ul/li[1]/a"))).click()
print("we are in 'By Spirit' page")

time.sleep(2)
spirits = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.CLASS_NAME, "truncated-list__item")

for i in range(len(spirits)):
    wait.until(EC.presence_of_element_located((By.ID, "child-indices_1-0")))
    if tag_fully_loaded(len(spirits), browser.find_element(By.ID, "child-indices_1-0"), "a"):
        type_ = browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
        browser.find_element(By.ID, "child-indices_1-0").find_elements(By.TAG_NAME, "a")[i].click()
        print("we are in {} page".format(type_))
        time.sleep(2)
        articles = browser.find_elements(By.CLASS_NAME, "comp.card-list__item.mntl-block")
        for j in range(len(articles)):
            if class_fully_loaded(len(articles), browser, "comp.card-list__item.mntl-block"):
                browser.find_elements(By.CLASS_NAME, "comp.card-list__item.mntl-block")[j].find_element(By.TAG_NAME, "a").click() 
                if is_in_id(browser, "feedback-block_1-0"):
                    print("we are in one recipe page")
                    data = scraping(browser)
                    data.append(type_)
                    writer.writerow(data)
                    print("recipe checked")
                    browser.back()
                    print("back")
                else:
                    if is_in_xpath(browser, "//a[contains(text(), 'Get the recipe.')]"):
                        print("we are in gathered recipes page")
                        are_names_scrapped=False
                        time.sleep(2)
                        recipes = browser.find_elements(By.XPATH, "//a[contains(text(), 'Get the recipe.')]")
                        print("there's {} recipes".format(len(recipes)))
                        count = 1
                        for k in range(len(recipes)):
                            if xpath_fully_loaded(len(recipes), browser, "//a[contains(text(), 'Get the recipe.')]"):
                                link_type = browser.find_elements(By.XPATH, "//a[contains(text(), 'Get the recipe.')]")[k].get_attribute("data-type")
                                if link_type=="internalLink":
                                    browser.find_elements(By.XPATH, "//a[contains(text(), 'Get the recipe.')]")[k].click()
                                    data = scraping(browser)
                                    data.append("N/A")
                                    writer.writerow(data)
                                    print("recipe {} checked".format(count))
                                    browser.back()
                                    count += 1
                                else:
                                    if are_names_scrapped:
                                        pass
                                    else:
                                        print("here's external link, stop checking detailed recipe")
                                        print("checking just names")
                                        names = browser.find_elements(By.CLASS_NAME, "comp.mntl-sc-block.lifestyle-sc-block-heading.mntl-sc-block-heading")
                                        for l in range(len(names)):
                                            name = browser.find_elements(By.CLASS_NAME, "comp.mntl-sc-block.lifestyle-sc-block-heading.mntl-sc-block-heading")[l].text.strip()
                                            writer.writerow([name])
                                        print("names checked")
                                        are_names_scrapped=True
                            else:
                                print("error: can't fully load recipes")
                        browser.back()
                        print("back")
                    else:
                        print("we are in useless page")
                        browser.back()
                        print("back")
            else:
                print("error: can't fully load articles")
    else:
        print("error: can't fully load spirits")
    browser.back()

print("Done")
browser.close()
f.close()