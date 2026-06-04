# generate_translations.py
from deep_translator import GoogleTranslator
import json, time, os

base_path = 'assets/translations/en.json'

with open(base_path, 'r', encoding='utf-8') as f:
    english = json.load(f)

# Major world languages by region
languages = {
    # Europe
    'fr': 'fr',      # French
    'de': 'de',      # German  
    'es': 'es',      # Spanish
    'it': 'it',      # Italian
    'pt': 'pt',      # Portuguese
    'ru': 'ru',      # Russian
    'nl': 'nl',      # Dutch
    'pl': 'pl',      # Polish
    
    # Middle East
    'ar': 'ar',      # Arabic
    'tr': 'tr',      # Turkish
    'fa': 'fa',      # Persian/Farsi
    
    # Asia
    'zh-CN': 'zh-CN', # Chinese Simplified
    'zh-TW': 'zh-TW', # Chinese Traditional
    'ja': 'ja',       # Japanese
    'ko': 'ko',       # Korean
    'id': 'id',       # Indonesian
    'th': 'th',       # Thai
    'vi': 'vi',       # Vietnamese
    
    # Africa
    'sw': 'sw',       # Swahili
    'af': 'af',       # Afrikaans
}

def translate_nested(data, target):
    if isinstance(data, str) and data.strip():
        try:
            result = GoogleTranslator(source='en', target=target).translate(data)
            time.sleep(0.3)  # rate limit
            return result
        except:
            return data
    elif isinstance(data, dict):
        return {k: translate_nested(v, target) for k, v in data.items()}
    return data

for code, lang in languages.items():
    print(f"Translating: {code}...")
    translated = translate_nested(english, lang)
    with open(f'assets/translations/{code}.json', 'w', encoding='utf-8') as f:
        json.dump(translated, f, ensure_ascii=False, indent=2)
    print(f"{code}.json done!")
