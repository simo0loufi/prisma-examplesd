#!/bin/sh

set -eu

mkdir -p ~/.ssh
echo "$SSH_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keyscan github.com >> ~/.ssh/known_hosts

git config --global user.email "prismabots@gmail.com"
git config --global user.name "Prismo"

git remote add github "git@github.com:$GITHUB_REPOSITORY.git"

sh .github/scripts/upgrade-all.sh alpha

git commit -am "chore(packages): bump prisma2 to $PRISMA_VERSION"

# fail silently if the unlikely event happens that this change already has been pushed either manually
# or by an overlapping upgrade action
git pull github "${GITHUB_REF}" --rebase || true

# force-push to alpha
git push github HEAD:origin/alpha --force
