__author__ = 'michaeldahnke'

##infile = open ('untitled2.txt', encoding='UTF-8')
##text = infile.read()
##infile.close()

open('counted.txt', 'w').close()

a = 0            # FIRST, set the initial value of the variable a to 0(zero).
while a < 25:    # While the value of the variable a is less than 10 do the following:
    a = a + 1    # Increase the value of the variable a by 1, as in: a = a + 1! 
##  print(a)     # Print to screen what the present value of the variable a is.
                 # REPEAT! until the value of the variable a is equal to 9!? See note. 
                 
                 # NOTE:
                 # The value of the variable a will increase by 1
                 # with each repeat, or loop of the 'while statement BLOCK'.
                 # e.g. a = 1 then a = 2 then a = 3 etc. until a = 9 then...
                 # the code will finish adding 1 to a (now a = 10), printing the 
                 # result, and then exiting the 'while statement BLOCK'. 
                 #              --
                 # While a < 36: |
                 #     a = a + 1 |<--[ The while statement BLOCK ]
                 #     print (a) |
                 #              --
    if a < 10:
##        print(type(a))
        outfile = open("counted.txt", mode="a", encoding='UTF-8')
        outfile.write("0"+str(a)+". "+"Monat"+"\r")
        outfile.close()
    else:
        outfile = open("counted.txt", mode="a", encoding='UTF-8')
        outfile.write(str(a)+". "+"Monat"+"\r")
        outfile.close()





