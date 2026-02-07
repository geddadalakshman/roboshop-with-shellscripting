commit-msg ?= "Automated commit"
git-push:
	git add .
	git commit -m "$(commit-msg)"
	git push
	say "code pushed"