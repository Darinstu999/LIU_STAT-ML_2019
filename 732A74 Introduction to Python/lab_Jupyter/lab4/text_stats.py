#!/usr/bin/python
# This module returns several statistics of specific text file.

import sys
import os.path
from collections import Counter

def main():
    if len(sys.argv[1:]) >= 1:
        if os.path.isfile(sys.argv[1]):
            with open(sys.argv[1], "r", encoding="utf8") as file:
                temp_doc = get_text(file)

            print("letter_frequency")
            letter_frequency(temp_doc)

            print("number_of_words")
            number_of_words(temp_doc)

            print("number_of_unique_words")
            number_of_unique_words(temp_doc)

            print("common_words")
            common_words(temp_doc)
        else:
            print("No such file existed.")
            sys.exit(1)
    else:
        print("Missing argument.")
        sys.exit(1)

def output(line):
    print(line)
    if len(sys.argv[1:]) == 2:
        with open(sys.argv[2], "a", encoding="utf8") as output:
            output.write(line + "\n")

def get_text(file):
    text = file.read().lower()
    # replace all punctuations with ' '
    punctuations = '!.?,*'
    text = text.maketrans(punctuations,' ')
    return text.split()

def letter_frequency(doc):
    c = Counter(doc)
    title = "Frequency table for alphabetic letters:"
    output(title)
    for letter in c.most_common():
        content = f"{letter[0]} ({letter[1]} occurrences)"
        output(content)

def number_of_words(doc):
    c = Counter(doc)
    content = f"The total number of words is {sum(c.values())}"
    output(content)

def number_of_unique_words(doc):
    c = Counter(doc)
    content = f"The number of unique words is {len(c)}"
    output(content)

def common_words(doc):
    c = Counter(doc)
    five_most_common = dict(c.most_common(5))
    title = "The five most common words are: "
    output(title)
    for key, value in five_most_common.items():
        three_most_common = dict(c.most_common(3))
        content = f"{key} ({value} occurrences)"
        output(content)
        for key2, value2 in three_most_common.items():
            content2 = f"-- {key2}, {value2}"
            output(content2)

def number_words_gen_text(words): 
    dictionary = {}
    for i in range(len(words)):
        word1 = words[i]
        if(word1 in dictionary):
            dictionary[word1]['freq'] += 1
        else:
            dictionary[word1] ={} 
            dictionary[word1]['freq'] = 1

        if(i < len(words)-1) :
            word2 = words[i+1]
            if(word2 in dictionary[word1]):
                dictionary[word1][word2] += 1
            else:
                dictionary[word1][word2] =1
    return dictionary

def filter_strings(words):
    alphabets_upplow = set('abcdefghijklmnopqrstuvwxyz')
    line = words.lower()
    line = ''.join(filter(alphabets_upplow.__contains__, line))
    return line

if __name__ == '__main__':
    main()