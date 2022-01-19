#BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I HAVE STRICTLY ADHERED
#TO THE TENURES OF THE OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY
#WITH RESPECT TO THIS ASSIGNMENT. 
#Charlie Vukovic


gcc_Sopt = -lc -m64 -c -g

all: lab7.zip readrec

lab7.zip: Makefile printlines.s readlines.s readrec.s lab7Readme
	zip lab7.zip Makefile printlines.s readlines.s readrec.s lab7Readme

readrec: printlines.o readlines.o readrec.o
	gcc printlines.o readlines.o readrec.o -o readrec

printlines.o: printlines.s
	gcc $(gcc_Sopt) -o printlines.o printlines.s

readlines.o: readlines.s
	gcc $(gcc_Sopt) -o readlines.o readlines.s

readrec.o: readrec.s
	gcc $(gcc_Sopt) -o readrec.o readrec.s 

clean:
	rm -rf lab7.zip readrec




