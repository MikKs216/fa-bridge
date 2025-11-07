#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import re
from html.parser import HTMLParser
from pathlib import Path

class HTMLDocExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.description = []
        self.in_description = False
        self.current_text = []
        
    def handle_starttag(self, tag, attrs):
        # Look for the main content area
        if tag == 'p':
            self.current_text = []
            self.in_description = True
            
    def handle_endtag(self, tag):
        if tag == 'p' and self.in_description:
            text = ''.join(self.current_text).strip()
            if text and not text.startswith('<'):
                self.description.append(text)
            self.current_text = []
            self.in_description = False
            
    def handle_data(self, data):
        if self.in_description:
            self.current_text.append(data.strip())

def extract_description_from_html(html_content):
    """Extract first description paragraph from HTML"""
    # Use regex to find first paragraph in idcontent
    match = re.search(r'<div id="idcontent">.*?<p>(.*?)</p>', html_content, re.DOTALL)
    if match:
        text = match.group(1)
        # Remove HTML tags
        text = re.sub(r'<[^>]+>', '', text)
        text = text.strip()
        return text
    return None

def main():
    html_dir = Path('fahlp/HTML')
    
    # Map of function names to HTML file names
    mappings = {}
    
    for html_file in html_dir.glob('*.htm'):
        try:
            with open(html_file, 'r', encoding='utf-8') as f:
                content = f.read()
                desc = extract_description_from_html(content)
                if desc:
                    # Function name is typically the stem of the file
                    func_name = html_file.stem.lower()
                    # Capitalize first letter for PascalCase function names
                    func_name = ''.join(word.capitalize() for word in func_name.split('_'))
                    mappings[func_name] = desc
                    print(f"{func_name}: {desc[:80]}...")
        except Exception as e:
            print(f"Error reading {html_file}: {e}")

if __name__ == '__main__':
    main()















