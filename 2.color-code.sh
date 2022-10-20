#!/bin/bash

# Color	    Foreground Code (Text)	Background Code
# Black	        30	                    40
# Red	        31	                    41
# Green	        32	                    42
# Yellow	    33	                    43
# Blue	        34	                    44
# Magenta	    35	                    45
# Cyan	        36	                    46
# White	        37	                    47
# dark grey	    90	                    100
# light red	    91	                    101
# light green	92	                    102
# light yellow	93	                    103
# light blue	94	                    104
# light purple	95	                    105
# turquoise	    96	                    106
# light white	97	                    107

# echo -e "\e[1;31m This is red text \e[0m"

echo -e "\e[1;31m This is red text \e[0m"

echo -e "\e[1;35m This is red text \e[105m"

echo -e "\e[1;35m This is red text \e[43m"

echo -e "\e[1;95m This is red text \e[44m"

echo -e "\e[1;93m This is red text \e[107m"