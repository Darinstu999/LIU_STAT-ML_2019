#!/usr/bin/python

import sys
from collections import Counter
import random

from text_stats import *


def main():
    with open(sys.argv[1], "r", encoding="utf8") as file:
        #temp_doc = text_stats.get_text(file)
        temp_doc = file.read()
    word_data = temp_doc.split()
    out = gen(word_data)
    return out

def gen(doc):
    cur_word = sys.argv[2]
    msg = [cur_word]
    max_number = int(sys.argv[3])
    number_of_words = 1

    clean_content = [filter_strings(item) for item in doc]
    words_dict = number_words_gen_text(clean_content)

    if cur_word in words_dict:
        while number_of_words < max_number:
            dict_msgs = words_dict[cur_word]
            dict_msgs = dict((k, dict_msgs[k]) for k in dict_msgs.keys() if k != 'freq')
            dict_msgs =  [(k, dict_msgs[k]) for k in sorted(dict_msgs, key=dict_msgs.get, reverse=True)]
            if len(dict_msgs)>0:
                chosen = [key for key in dict(dict_msgs).keys()]
                val_msg = [val for val in dict(dict_msgs).values()]
                val_msg = list(map(int, val_msg))
                total = int(sum(dict(dict_msgs).values()))
                probability = [value / total for value in val_msg]
                rand_choice = random.choices(chosen, weights=probability)
                msg.append(rand_choice[0])
            number_of_words += 1
        print(msg)
    return msg

if __name__ == '__main__':
    main()
