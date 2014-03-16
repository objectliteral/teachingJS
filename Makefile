source=chapters/*/*.md
title='teachingJS - The Language'
filename='./build/index'

all: markdown html

markdown:
	awk 'FNR==1{print ""}{print}' $(source) > $(filename).md

html: markdown

	pandoc -f markdown -t html -o ./build/LICENSE.html LICENSE.md

	pandoc -f markdown+pandoc_title_block -t html5 -o $(filename).html $(filename).md \
		--standalone \
		--template template.html \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--toc \
		--include-before-body=./build/LICENSE.html

#pdf: markdown
#	pandoc -s $(filename).md -o $(filename).pdf \
#		--title-prefix $(title) \
#		--normalize \
#		--smart \
#		--toc \
#		--latex-engine=xelatex
