# Report

These are the steps I took to solve this problem:

I started by addressing the command line arguments. This was easy enough by checking the value of @ARGV and testing to see if the last three characters of the file had .json. I also added a /i at the end of the regular expression to accept filenames that were in uppercase or a mix of uppercase and lowercase. I also added another clause to check whether a command line argument had been given and if not, the script would exit.

The second step was to find a way to extract the relevant data and remove any of the curly braces and brackets that are contained in a json file.
