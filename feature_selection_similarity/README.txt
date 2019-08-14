 Feature selection method using similarity measure and fuzzy entropy 
 measures based on the article:

 P. Luukka, (2011) Feature Selection Using Fuzzy Entropy Measures with
 Similarity Classifier, Expert Systems with Applications, 38, pp.
 4600-4607

 Function call:
 [data_mod, index_rem]=feat_sel_sim(data, measure, p)

 OUTPUTS:
 data_mod      data without removed feature
 index_rem     index of removed feature in original data

 INPUTS:
 data          data matrix, contains class values
 measure       fuzzy entropy measure, either 'luca' or 'park' 
               currently coded
 p             parameter for similarity measure
               p in (0, \infty) as default p=1.

One can use this function in a following way:

1) load your data in your matlab

For example in this case write load exampledata2.txt
which should give you following data:

    0.4600    0.3400    0.1400    0.0300    0.9218    1.0000
    0.5000    0.3400    0.1500    0.0200    0.7382    1.0000
    0.4400    0.2900    0.1400    0.0200    0.1763    1.0000
    0.7600    0.3000    0.6600    0.2100    0.4057    2.0000
    0.4900    0.2500    0.4500    0.1700    0.9355    2.0000
    0.7300    0.2900    0.6300    0.1800    0.9169    2.0000

there we have an artificial data where in first four columns we
have data measurements in fifth column we have randomly generated artificial
noise column (which we want to remove) and in last column we have label
information about the classes of the samples. 

2) run the program by writing 

[data_mod, index_rem]=feat_sel_sim(exampledata2,'luca',1)

you will get the result:

data_mod =
    0.4600    0.3400    0.1400    0.0300    1.0000
    0.5000    0.3400    0.1500    0.0200    1.0000
    0.4400    0.2900    0.1400    0.0200    1.0000
    0.7600    0.3000    0.6600    0.2100    2.0000
    0.4900    0.2500    0.4500    0.1700    2.0000
    0.7300    0.2900    0.6300    0.1800    2.0000
index_rem =
     5

where now in data_mod you have the data where feature 5 is now removed by using
the method and index_rem gives you the index of the column which was removed. 