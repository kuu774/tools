# -*- coding: utf-8 -*- 
import sys
import re
from Bio import SeqIO

'''
A.................Adenine
C.................Cytosine
G.................Guanine
T (or U)..........Thymine (or Uracil)
R.................A or G
Y.................C or T
S.................G or C
W.................A or T
K.................G or T
M.................A or C
B.................C or G or T
D.................A or G or T
H.................A or C or T
V.................A or C or G
N.................any base
'''

def nucCount(file):
    tot_len=0

    count={'A':0, 'C':0, 'G':0, 'T':0, 'N':0,
           'R':0, 'Y':0, 'S':0, 'W':0, 'K':0, 'M':0, 'B':0, 'D':0, 'H':0, 'V':0}

    bases=['A', 'C', 'G', 'T', 'N',
           'R', 'Y', 'S', 'W', 'K', 'M', 'B', 'D', 'H', 'V']

    for seq_record in SeqIO.parse(file, "fasta"):
        seq=seq_record.seq.upper()
        tot_len+=len(seq)
        for nuc in bases:
            count[nuc]+=seq.count(nuc)

    print("------------------")
    print("## Total length:%d" % (tot_len))
    print("## GC content:%.2f" % (100.0*(count['G']+count['C'])/tot_len))

    for nuc in bases:
        print("%s,%d,%.2f" % (nuc, count[nuc], 100.0*count[nuc]/tot_len))

    print("------------------")

if __name__ == "__main__":
    param = sys.argv
    nucCount(param[1])
