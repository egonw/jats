all: kb

clean:
	@rm -Rf volume_*.ttl

kb:
	@curl https://raw.githubusercontent.com/jcheminform/jcheminform-kb/main/volume_1.ttl  -o volume_1.ttl
	@curl https://raw.githubusercontent.com/jcheminform/jcheminform-kb/main/volume_12.ttl -o volume_12.ttl
	@curl https://raw.githubusercontent.com/jcheminform/jcheminform-kb/main/volume_13.ttl -o volume_13.ttl

doilist.txt:
	@echo "" > doilist.txt
	@roqet -q queries/citoPaper.rq -D volume_1.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/citoPaper.rq -D volume_12.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/citoPaper.rq -D volume_13.ttl -r csv | grep -v "doi" | tee -a doilist.txt
