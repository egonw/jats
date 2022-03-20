# JATS of Journal of Cheminformatics

Repository with JATS of [Journal of Cheminformatics](https://jcheminf.biomedcentral.com/) CC-BY articles.

## Springer Nature API

The JATS of open access articles can be downloaded from the [Springer Nature API](https://dev.springernature.com/) (where you get your api key) with a call like this:

http://api.springernature.com/openaccess/jats/doi/10.1186/s13321-020-00448-1?api_key=SecretKey

## How to run

There is a helpful Makefile (GNU make), wich can be run like this:

```shell
export SecretKey=${YOUR_KEY}
make doilist.txt
make fetch
make jats
```

The first make step downloads a list of DOIs from the [Journal of Cheminformatics Knowledge Base](https://github.com/egonw/jcheminform-kb)
which is used to calls API methods fo all DOIs from which the JATS is extracted.
