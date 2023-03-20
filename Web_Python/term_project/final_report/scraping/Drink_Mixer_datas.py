import csv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])
user_agent= "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36"
options.add_argument('user-agent=' + user_agent)
browser = webdriver.Chrome(options=options)
wait = WebDriverWait(browser, 60)

def tag_fully_loaded(n, brows, attr):
    cnt = len(brows.find_elements(By.TAG_NAME, attr))
    if cnt==n:
        return True
    else:
        print("n :", n, "cnt :", cnt)
        tag_fully_loaded(n, brows, attr)

def cocktails_fully_loaded(n_, n):
    if n_==n:
        return True
    else:
        print("n_ : {}, n : {}".format(n_, n))
        cocktails_fully_loaded(n_, n)

def scraping(brows):
    name = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fn.recipe_title"))).__getattribute__("text").strip()
    ingredients = []
    ingredients_element = brows.find_element(By.CLASS_NAME, "ingredients").find_elements(By.CLASS_NAME, "ingredient")
    for ingredient_element in ingredients_element:
        volume = ingredient_element.find_element(By.CLASS_NAME, "amount").__getattribute__("text").strip()
        ing_name = ingredient_element.find_element(By.CLASS_NAME, "name").__getattribute__("text").strip()
        ingredients.append(str(volume+" "+ing_name))
    making = brows.find_element(By.CLASS_NAME, "min").find_element(By.CLASS_NAME, "RecipeDirections.instructions").__getattribute__("text").strip()
    link = brows.current_url
    glass = brows.find_elements(By.CLASS_NAME, "recipeStats")[1].find_element(By.TAG_NAME, "img").get_attribute("title")
    writer.writerow([name, ingredients, making, link, glass, type_, base])

wait.until(EC.element_to_be_clickable((By.XPATH, "/html/body/div/div[1]/div[2]/p[2]/a[1]"))).click()

# cocktails(type)
type_ = None
base = None
url = "http://www.drinksmixer.com/cat/1/"
browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))

while True:
    print("we are in {} page".format(str(prev_page)))
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        print("there's {} cocktails".format(len(cocktails)))
        for i in range(len(cocktails)):
            wait.until(EC.presence_of_element_located((By.CLASS_NAME, "clr")))
            if tag_fully_loaded(len(cocktails), browser.find_element(By.CLASS_NAME, "clr"), "a"):
                browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
                browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].click()
                scraping(browser)
                browser.back()
                print("cocktail {} checked".format(i+1))
            else:
                print("error: can't fully load cocktails")
                browser.close()
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        break

# shots(type)
type_ = "Shooter"
base = None
url = "http://www.drinksmixer.com/cat/3/"
browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))

filename = "Drink_Mixer_shooter.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Glass", "Type", "Base"]
writer.writerow(title)

while True:
    print("we are in {} page".format(str(prev_page)))
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        print("there's {} cocktails".format(len(cocktails)))
        for i in range(len(cocktails)):
            wait.until(EC.presence_of_element_located((By.CLASS_NAME, "clr")))
            if tag_fully_loaded(len(cocktails), browser.find_element(By.CLASS_NAME, "clr"), "a"):
                browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
                browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].click()
                scraping(browser)
                browser.back()
                print("cocktail {} checked".format(i+1))
            else:
                print("error: can't fully load cocktails")
                browser.close()
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        break
f.close()

# punches(type)
type_ = "Punch"
base = None
url = "http://www.drinksmixer.com/cat/2/"
browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))

filename = "Drink_Mixer_punch.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Glass", "Type", "Base"]
writer.writerow(title)

while True:
    print("we are in {} page".format(str(prev_page)))
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        print("there's {} cocktails".format(len(cocktails)))
        for i in range(len(cocktails)):
            wait.until(EC.presence_of_element_located((By.CLASS_NAME, "clr")))
            if tag_fully_loaded(len(cocktails), browser.find_element(By.CLASS_NAME, "clr"), "a"):
                browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
                browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].click()
                scraping(browser)
                browser.back()
                print("cocktail {} checked".format(i+1))
            else:
                print("error: can't fully load cocktails")
                browser.close()
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        break
f.close()

# nonalcoholic(type)
type_ = "Nonalcoholic"
base = None
url = "http://www.drinksmixer.com/cat/8/"
browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))

filename = "Drink_Mixer_nonalcoholic.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Glass", "Type", "Base"]
writer.writerow(title)

while True:
    print("we are in {} page".format(str(prev_page)))
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        print("there's {} cocktails".format(len(cocktails)))
        for i in range(len(cocktails)):
            wait.until(EC.presence_of_element_located((By.CLASS_NAME, "clr")))
            if tag_fully_loaded(len(cocktails), browser.find_element(By.CLASS_NAME, "clr"), "a"):
                browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
                browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].click()
                scraping(browser)
                browser.back()
                print("cocktail {} checked".format(i+1))
            else:
                print("error: can't fully load cocktails")
                browser.close()
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        break
f.close()

# beer&ale(base)
type_ = None
base = "Beer&Ale"
url = "http://www.drinksmixer.com/cat/4/"
browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))

filename = "Drink_Mixer_beerale.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Glass", "Type", "Base"]
writer.writerow(title)

while True:
    print("we are in {} page".format(str(prev_page)))
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        print("there's {} cocktails".format(len(cocktails)))
        for i in range(len(cocktails)):
            wait.until(EC.presence_of_element_located((By.CLASS_NAME, "clr")))
            if tag_fully_loaded(len(cocktails), browser.find_element(By.CLASS_NAME, "clr"), "a"):
                browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
                browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].click()
                scraping(browser)
                browser.back()
                print("cocktail {} checked".format(i+1))
            else:
                print("error: can't fully load cocktails")
                browser.close()
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        break
f.close()

# coffee&tee(base)
type_ = None
base = "Coffee&Tee"
url = "http://www.drinksmixer.com/cat/7/"
browser.get(url)
prev_page, curr_page = map(int, wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fl4"))).__getattribute__("text").strip().split("/"))

filename = "Drink_Mixer_coffetee.csv"
f = open(filename, 'w', encoding="utf-8-sig", newline="")
writer = csv.writer(f)
title = ["Name", "Ingredients", "Making", "Link", "Glass", "Type", "Base"]
writer.writerow(title)

while True:
    print("we are in {} page".format(str(prev_page)))
    must_cocktails = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "fr4"))).__getattribute__("text").strip().split(" ")[0].split("-")
    cocktails_ = int(must_cocktails[1])-int(must_cocktails[0])+1
    cocktails = browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")
    if cocktails_fully_loaded(cocktails_, len(cocktails)):
        print("there's {} cocktails".format(len(cocktails)))
        for i in range(len(cocktails)):
            wait.until(EC.presence_of_element_located((By.CLASS_NAME, "clr")))
            if tag_fully_loaded(len(cocktails), browser.find_element(By.CLASS_NAME, "clr"), "a"):
                browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
                browser.find_element(By.CLASS_NAME, "clr").find_elements(By.TAG_NAME, "a")[i].click()
                scraping(browser)
                browser.back()
                print("cocktail {} checked".format(i+1))
            else:
                print("error: can't fully load cocktails")
                browser.close()
    else:
        print("not collect cocktails num")
        browser.close()
    browser.close
    if prev_page!=curr_page:
        prev_page += 1
        browser.get(url+str(prev_page)+"/")
    else:
        break
f.close()