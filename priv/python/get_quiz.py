
from playwright.sync_api import sync_playwright
import re
import fire
from urllib.parse import urlparse

def write_html_to_file(html_content, output_file_path):
    with open(output_file_path, 'w', encoding='utf-8') as file:
        file.write(html_content)

def word_in_rootname(url, target_word):
    parsed_url = urlparse(url)
    root_name = parsed_url.netloc.split('.')[0]
    return target_word.lower() in root_name.lower()


def emulate_iphone(p, show_browser=False):
    iphone_13 = p.devices["iPhone 14"]
    # iphone_13 = p.devices["iPad (gen 5)"]
    browser = p.webkit.launch(headless=(not show_browser))
    context = browser.new_context(
        **iphone_13,
    )
    return context

def emulate_chromium(p,show_browser=False):
    browser = p.chromium.launch(headless=(not show_browser))
    return browser

def take_screenshots_of_children(url, parent_selector="ol.wpProQuiz_list", child_selector="li.wpProQuiz_listItem", output_folder="screenshots"):
    print(f"{url} \n")
    with sync_playwright() as p:
        context = emulate_iphone(p,show_browser=False)
        # context = emulate_chromium(p)

        page = context.new_page()
        print("going to load page now")
        page.goto(url, wait_until="domcontentloaded")

        # click on start quiz only on insightsonindia.com
        if word_in_rootname(url,"insightsonindia"):
            page.get_by_role("button", name="Start quiz").click()
        ######## Approach 2 ########
        # Get the number of questions.
        # grab screenshot of specific html element
        # ol li:nth-child(2)

        num_questions = int(page.locator('div.wpProQuiz_reviewQuestion > ol > li:last-child').inner_text());
        print(f"Detected {num_questions} Questions on the page. \n ")
        page_title = page.locator("h1").inner_text()

        # remove the bottom bar on iphone 14 to utilise full screen in screenshots
        element_locator =     page.locator(".ct-shortcuts-bar-items")
        element_locator.evaluate('element => element.remove()')

        # page_title = page.locator("h1.page-title").inner_text()
        for n in range(0,num_questions):
            scr_path = f"{output_folder}/{page_title}/quiz_{n + 1:03d}.png"
            print( f"""
                ------
                {n}\t ### { scr_path }
                ------
                """)
            q_div = page.locator(f"{parent_selector} {child_selector} ").nth(n)
            print(q_div.inner_text())
            q_div.screenshot(path=scr_path)
        ################################

        context.close()
        return {"folder_path": f"{output_folder}/{page_title}"}

if __name__ == "__main__":
    fire.Fire(take_screenshots_of_children)
