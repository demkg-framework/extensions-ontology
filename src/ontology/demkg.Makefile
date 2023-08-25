## Customize Makefile settings for demkg
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

properties-redundant.nt: demkg-base.owl
	relation-graph --ontology-file $< --output-subclasses true --disable-owl-nothing true --output-file $@

rdf.facts: properties-redundant.nt
	sed 's/ /\t/' <$< | sed 's/ /\t/' | sed 's/ \.$$//' >$@

ontrdf.facts: demkg-base.owl
	riot --output=ntriples $< | sed 's/ /\t/' | sed 's/ /\t/' | sed 's/ \.$$//' >$@

properties-nonredundant.nt: rdf.facts ontrdf.facts prune.dl
	souffle -c prune.dl && mv nonredundant.csv $@ && cp $@ ../../$(ONT)-materialized-relations.nt
