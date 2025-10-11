ssh-keygen -t ed25519 -C "daniverson@hotmail.com"

# start agent
eval $(ssh-agent -s)

# add key
ssh-add ~/.ssh/id_ed25519

# show key
cat ~/.ssh/id_ed25519.pub

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILn3C+A7vV477dKzBFJmpFEdX/zC8womsF1iJrZIdoXf daniverson@hotmail.com

git remote set-url origin git@github.com:cloud-plat-org/kubernetes-administration-cka-practice.git

git fetch
git push -u origin main
