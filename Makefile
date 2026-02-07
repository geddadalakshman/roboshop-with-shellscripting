commit-msg ?= "Automated commit"
git:
	git add .
	git commit -m "$(commit-msg)"
	git push