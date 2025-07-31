ls ~/.ssh/id_rsa.pub

ssh-keygen -t rsa -b 4096 -C "your.email@cibc.com"


eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

pbcopy < ~/.ssh/id_rsa.pub

git remote set-url origin git@cvgit10hd1.ca.cibcwm.com:Mobile-Application-Services.git


git push


