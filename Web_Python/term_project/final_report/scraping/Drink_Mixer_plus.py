import csv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
browser = webdriver.Chrome(options=options)
wait = WebDriverWait(browser, 60)

def cocktails_fully_loaded(n_, n):
    if n_==n:
        return True
    else:
        print("n_ : {}, n : {}".format(n_, n))
        cocktails_fully_loaded(n_, n)

# type search
## creamy type
url = "http://www.drinksmixer.com/cat/4226/"
filename = "Drink_type_creamy.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
#    print("we are in {} page".format(str(prev_page)))
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
#        print("there's {} cocktails".format(len(cocktails)))
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
#        print("Done")
        break

## frozen type
url = "http://www.drinksmixer.com/cat/11/"
filename = "Drink_type_frozen.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## hot type
url = "http://www.drinksmixer.com/cat/12/"
filename = "Drink_type_hot.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## long type
url = "http://www.drinksmixer.com/cat/13/"
filename = "Drink_type_long.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## short type
url = "http://www.drinksmixer.com/cat/14/"
filename = "Drink_type_short.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## tropical type
url = "http://www.drinksmixer.com/cat/4227/"
filename = "Drink_type_tropical.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

# base search
## champagne base
url = "http://www.drinksmixer.com/cat/9/"
filename = "Drink_base_champagne.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## brandy base
url = "http://www.drinksmixer.com/cat/2523/"
filename = "Drink_base_brandy.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## cognac base
url = "http://www.drinksmixer.com/cat/2517/"
filename = "Drink_base_cognac.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## gin base
url = "http://www.drinksmixer.com/cat/2031/"
filename = "Drink_base_gin.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## liqueur base
url = "http://www.drinksmixer.com/cat/2310/"
filename = "Drink_base_liqueur.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## rum base
url = "http://www.drinksmixer.com/cat/2058/"
filename = "Drink_base_rum.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## tequila base
url = "http://www.drinksmixer.com/cat/2001/"
filename = "Drink_base_tequila.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## vodka base
url = "http://www.drinksmixer.com/cat/2138/"
filename = "Drink_base_vodka.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## whisky base
url = "http://www.drinksmixer.com/cat/2187/"
filename = "Drink_base_whisky.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

## wine base
url = "http://www.drinksmixer.com/cat/2285/"
filename = "Drink_base_wine.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name"]
writer.writerow(title)

browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))
while True:
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        for i in range(len(cocktails)):
            name = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].get_attribute("text").strip()
            writer.writerow([name])
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        f.close()
        break

print("Done")