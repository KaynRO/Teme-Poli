build:
	mkdir -p target
	javac ./*.java -d target;
	javac -cp target ./*.java -d target;
clean:
	rm -rf target
	rm -rf output
run:
	java -cp target Tema2 $(INPUT_FILE)
