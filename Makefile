all: render deploy

render:
		R -e 'babelquarto::render_website()'

deploy:
		rsync -avz ./_site/ ubuntu@5.196.76.20:/var/www/geo-df
