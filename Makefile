DOIS := $(shell cat doilist.txt | cut -d'/' -f2 | grep s )
JATS := ${shell cat doilist.txt | cut -d'/' -f2 | grep s | sed -e 's/\(.*\)\r/\1.xml/' }

all: doilist.txt

distclean: clean
	@rm -Rf doilist.txt

clean:
	@rm -Rf volume_*.ttl *.response.xml

kb:
	@curl https://raw.githubusercontent.com/jcheminform/jcheminform-kb/main/volume_1.ttl  -o volume_1.ttl
	@curl https://raw.githubusercontent.com/jcheminform/jcheminform-kb/main/volume_12.ttl -o volume_12.ttl
	@curl https://raw.githubusercontent.com/jcheminform/jcheminform-kb/main/volume_13.ttl -o volume_13.ttl

doilist.txt: kb
	@echo "" > doilist.txt
	@roqet -q queries/citoPaper.rq -D volume_1.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/citoPaper.rq -D volume_12.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/citoPaper.rq -D volume_13.ttl -r csv | grep -v "doi" | tee -a doilist.txt

fetch:
	$(foreach doi,$(DOIS), curl http://api.springernature.com/openaccess/jats/doi/10.1186/${doi}?api_key=${SecretKey} | xmllint --format - > $(doi).response.xml ;)

jats: ${JATS}

%.xml: %.response.xml
	@echo "<?xml version=\"1.0\"?>" > $@
	@echo "<!ENTITY % article SYSTEM \"http://jats.nlm.nih.gov/archiving/1.2/JATS-archivearticle1.dtd\">" >> $@
	@xpath -e "/response/records/article" $< >> $@ || :
