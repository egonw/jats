# jats
Repository with JATS of [Journal of Cheminformatics](https://jcheminf.biomedcentral.com/) CC-BY articles

JATS can be downloaded from the [Springer Nature API](https://dev.springernature.com/) (where you get your api key) with a call like this:

http://api.springernature.com/openaccess/jats/doi/10.1186/s13321-020-00448-1?api_key=SecretKey

There is a helpful Makefile (GNU make), wich can be run like this:

```shell
export SecretKey=${YOUR_KEY}
make doilist.txt
make fetch
make jats
```
