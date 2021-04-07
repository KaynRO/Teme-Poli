from caesar import *
import operator

# this is the list of bigrams, from most frequent to less frequent
bigrams = ["TH", "HE", 'IN', 'OR', 'HA', 'ET', 'AN',
           'EA', 'IS', 'OU', 'HI', 'ER', 'ST', 'RE', 'ND']

# this is the list of monograms, from most frequent to less frequent
monograms = ['E', 'T', 'A', 'O', 'I', 'N', 'S', 'R', 'H', 'D', 'L', 'U',
             'C', 'M', 'F', 'Y', 'W', 'G', 'P', 'B', 'V', 'K', 'J', 'X', 'Q', 'Z']

# this is the dictionary containing the substitution table (e.g. subst_table['A'] = 'B')
# TODO fill it in the create_subst_table function
subst_table = {}

# these are the dictionaries containing the frequency of the mono/bigrams in the text
# TODO fill them in the analize function
freq_table_bi = {}
freq_table_mono = {}

# sorts a dictionary d by the value


def sort_dictionary(d):
    sorted_dict = list(reversed(sorted(d.items(), key=operator.itemgetter(1))))
    return sorted_dict

# computes the frequencies of the monograms and bigrams in the text


def analize(text):
    global freq_table_bi

    # TODO 1.1 fill in the freq_table_mono dictionary
    for char in text:
        if char not in freq_table_mono:
            freq_table_mono[char] = 0
        else:
            freq_table_mono[char] += 1

    # TODO 1.2 fill in the freq_table_bi dictionary
    for idx1 in range(len(text) - 1):
            con = text[idx1] + text[idx1 + 1]
            if con not in freq_table_bi.keys():
                freq_table_bi[con] = 0
            else:
                freq_table_bi[con] += 1

    print(freq_table_mono)
    print(freq_table_bi)

def create_subst_table():
    global subst_table
    global freq_table_bi

    # TODO 2.1 sort the bigrams frequence table by the frequency
    freq_table_bi = sort_dictionary(freq_table_bi)

    # TODO 2.2 fill in the substitution table by associating the sorted frequence
    # dictionary with the given bigrams
    for idx in range(len(bigrams)):
        if freq_table_bi[idx][0][0] not in subst_table.keys() and freq_table_bi[idx][0][1] not in subst_table.keys():
            subst_table[freq_table_bi[idx][0][1]] = bigrams[idx][1]
            subst_table[freq_table_bi[idx][0][0]] = bigrams[idx][0]
        if subst_table[freq_table_bi[idx][0][0]] == bigrams[idx][0] and freq_table_bi[idx][0][1] not in subst_table.keys():
            subst_table[freq_table_bi[idx][0][1]] = bigrams[idx][1]
        if subst_table[freq_table_bi[idx][0][1]] == bigrams[idx][1] and freq_table_bi[idx][0][0] not in subst_table.keys():
            subst_table[freq_table_bi[idx][0][0]] = bigrams[idx][0] 

    print(subst_table)


# fills in the letters missing from the substitution table using the frequencies
# of the monograms


def complete_subst_table():
    global subst_table
    global freq_table_mono

    # TODO 3.1 sort the monograms frequence table by the frequency
    freq_table_mono = sort_dictionary(freq_table_mono)[:-1]

    # TODO 3.2 fill in the missing letters from the substitution table by
    # associating the sorted frequence dictionary with the given monograms
    for idx in range(len(monograms)):
        if freq_table_mono[idx][0] not in subst_table.keys():
            subst_table[freq_table_mono[idx][0]] = monograms[idx]

    print(subst_table)
# this is magic stuff used in main


def adjust():
    global subst_table
    subst_table['Y'] = 'B'
    subst_table['E'] = 'L'
    subst_table['L'] = 'M'
    subst_table['P'] = 'W'
    subst_table['F'] = 'C'
    subst_table['X'] = 'F'
    subst_table['J'] = 'G'
    subst_table['I'] = 'Y'


def decrypt_text(text):
    global subst_table
    plaintext = ''

    # TODO 4 decrypt and print the text using the substitution table
    for char in text:
        if char != '\n':
            plaintext += subst_table[char]
        else:
            plaintext += char

    print(plaintext)



def main():
    with open('msg_ex2.txt', 'r') as myfile:
        text = myfile.read()

    analize(text)
    create_subst_table()
    complete_subst_table()
    adjust()
    decrypt_text(text)


if __name__ == "__main__":
    main()
