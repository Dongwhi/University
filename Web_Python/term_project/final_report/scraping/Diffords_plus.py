import csv
from selenium import webdriver
from selenium.webdriver.common.by import By

url = "https://www.diffordsguide.com/" # difford's guide

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
browser = webdriver.Chrome(options=options)
browser.get(url)

browser.find_element(By.ID, "accept-cookies-button").click()
browser.find_element(By.XPATH, "/html/body/div[3]/div[2]/div[1]/div/div/a[2]").click()
browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")

# Brandy base search
browser.find_element(By.XPATH, "//*[@id='ingredient-select-bases']/option[3]").click()
browser.find_element(By.ID, "search-submit").click()

filename_brandy = "Difford's_brandy.csv"
f_brandy = open(filename_brandy, 'w', encoding="utf-8-sig", newline="")
writer_brandy = csv.writer(f_brandy)
title = "Name"
writer_brandy.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_brandy.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("brandy base search done")
f_brandy.close()

# Gin base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-bases']/option[4]").click()
browser.find_element(By.ID, "search-submit").click()

filename_gin = "Difford's_gin.csv"
f_gin = open(filename_gin, 'w', encoding="utf-8-sig", newline="")
writer_gin = csv.writer(f_gin)
title = "Name"
writer_gin.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_gin.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("gin base search done")
f_gin.close()

# Rum base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-bases']/option[5]").click()
browser.find_element(By.ID, "search-submit").click()

filename_rum = "Difford's_rum.csv"
f_rum = open(filename_rum, 'w', encoding="utf-8-sig", newline="")
writer_rum = csv.writer(f_rum)
title = "Name"
writer_rum.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_rum.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("rum base search done")
f_rum.close()

# Tequila base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-bases']/option[6]").click()
browser.find_element(By.ID, "search-submit").click()

filename_tequila = "Difford's_tequila.csv"
f_tequila = open(filename_tequila, 'w', encoding="utf-8-sig", newline="")
writer_tequila = csv.writer(f_tequila)
title = "Name"
writer_tequila.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_tequila.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("tequila base search done")
f_tequila.close()

# Vodka base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-bases']/option[7]").click()
browser.find_element(By.ID, "search-submit").click()

filename_vodka = "Difford's_vodka.csv"
f_vodka = open(filename_vodka, 'w', encoding="utf-8-sig", newline="")
writer_vodka = csv.writer(f_vodka)
title = "Name"
writer_vodka.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_vodka.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("vodka base search done")
f_vodka.close()

# Whisky base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-bases']/option[8]").click()
browser.find_element(By.ID, "search-submit").click()

filename_whisky = "Difford's_whisky.csv"
f_whisky = open(filename_whisky, 'w', encoding="utf-8-sig", newline="")
writer_whisky = csv.writer(f_whisky)
title = "Name"
writer_whisky.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_whisky.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("whisky base search done")
f_whisky.close()

# Dry white wine base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-wines']/option[3]").click()
browser.find_element(By.ID, "search-submit").click()

filename_whitewine = "Difford's_whitewine.csv"
f_whitewine = open(filename_whitewine, 'w', encoding="utf-8-sig", newline="")
writer_whitewine = csv.writer(f_whitewine)
title = "Name"
writer_whitewine.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_whitewine.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("dry white wine base search done")
f_whitewine.close()

# Red wine base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-wines']/option[4]").click()
browser.find_element(By.ID, "search-submit").click()

filename_redwine = "Difford's_redwine.csv"
f_redwine = open(filename_redwine, 'w', encoding="utf-8-sig", newline="")
writer_redwine = csv.writer(f_redwine)
title = "Name"
writer_redwine.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_redwine.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("red wine base search done")
f_redwine.close()

# Sherry base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-wines']/option[5]").click()
browser.find_element(By.ID, "search-submit").click()

filename_sherry = "Difford's_sherry.csv"
f_sherry = open(filename_sherry, 'w', encoding="utf-8-sig", newline="")
writer_sherry = csv.writer(f_sherry)
title = "Name"
writer_sherry.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_sherry.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("sherry base search done")
f_sherry.close()

# Beer base search
browser.find_element(By.XPATH, "//*[@id='search-form']/div/div[2]/div/div[3]/div/a").click()
browser.find_element(By.XPATH, "//*[@id='ingredient-select-mixers']/option[3]").click()
browser.find_element(By.ID, "search-submit").click()

filename_beer = "Difford's_beer.csv"
f_beer = open(filename_beer, 'w', encoding="utf-8-sig", newline="")
writer_beer = csv.writer(f_beer)
title = "Name"
writer_beer.writerow([title])

prev_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text

while True:
    cocktails = browser.find_element(By.XPATH, "//*[@id='search-form']/div").find_elements(By.TAG_NAME, "h3")
    for cocktail in cocktails:
        name = cocktail.__getattribute__("text")
        writer_beer.writerow([name])
    browser.find_element(By.ID, "next-page").click()
    curr_page = browser.find_element(By.XPATH, "//*[@id='custom-select-1']/button/span[1]").text
    if curr_page == prev_page:
        break
    prev_page = curr_page

print("beer base search done")
f_beer.close()