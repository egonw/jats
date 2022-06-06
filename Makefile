DOIS := $(shell cat doilist.txt | grep "10." | cut -d'/' -f2 )
JATS := ${shell cat doilist.txt | grep "10." | cut -d'/' -f2 | sed -e 's/\(.*\)\r/\1.xml/' }

all: doilist.txt

distclean: clean
	@rm -Rf doilist.txt

clean:
	@rm -Rf volume_*.ttl *.response.xml

kb:
	@curl https://raw.githubusercontent.com/egonw/jcheminform-kb/main/volume_1.ttl  -o volume_1.ttl
	@curl https://raw.githubusercontent.com/egonw/jcheminform-kb/main/volume_2.ttl  -o volume_2.ttl
	@curl https://raw.githubusercontent.com/egonw/jcheminform-kb/main/volume_3.ttl  -o volume_3.ttl
	@curl https://raw.githubusercontent.com/egonw/jcheminform-kb/main/volume_3.ttl  -o volume_11.ttl
	@curl https://raw.githubusercontent.com/egonw/jcheminform-kb/main/volume_12.ttl -o volume_12.ttl
	@curl https://raw.githubusercontent.com/egonw/jcheminform-kb/main/volume_13.ttl -o volume_13.ttl

doilist.txt: kb
	@echo "" > doilist.txt
	@roqet -q queries/allPaper.rq -D volume_1.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/allPaper.rq -D volume_2.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/allPaper.rq -D volume_3.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/allPaper.rq -D volume_11.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/allPaper.rq -D volume_12.ttl -r csv | grep -v "doi" | tee -a doilist.txt
	@roqet -q queries/allPaper.rq -D volume_13.ttl -r csv | grep -v "doi" | tee -a doilist.txt

fetch:
	$(foreach doi,$(DOIS), curl http://api.springernature.com/openaccess/jats/doi/10.1186/${doi}?api_key=${SecretKey} | xmllint --format - > $(doi).response.xml ;)

jats: ${JATS}

%.xml: %.response.xml
	@echo "<?xml version=\"1.0\"?>" > $@
	@echo "<!ENTITY % article SYSTEM \"http://jats.nlm.nih.gov/archiving/1.2/JATS-archivearticle1.dtd\">" >> $@
	@xpath -e "/response/records/article" $< | sed -e 's/\(<email>\).*\(<\/email>\)/\1HIDDEN\2/' >> $@ || :
