source=chapters/*/*.md
title='teachingJS - The Language'
filename='./build/index'

all: markdown html

markdown:
	awk 'FNR==1{print ""}{print}' $(source) > $(filename).md

html: markdown
	pandoc -s $(filename).md -t html5 -o $(filename).html -c ../style.css \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--toc

#pdf: markdown
#	pandoc -s $(filename).md -o $(filename).pdf \
#		--title-prefix $(title) \
#		--normalize \
#		--smart \
#		--toc \
#		--latex-engine=xelatex
