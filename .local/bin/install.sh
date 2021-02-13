#/bin/bash -s

set -euo pipefail

cd "$HOME"
echo ".homefiles" >> .gitignore

git clone --bare https://github.com/0x8b/homefiles.git "$HOME/.homefiles"

config() {
  /usr/bin/git --git-dir="$HOME/.homefiles/" --work-tree="$HOME" "$@"
}

backup_file() {
  mkdir -p ".config-backup/$(dirname $1)"
  mv "$1" ".config-backup/$1"
}

mkdir -p .config-backup

if config checkout; then
  echo "Checked out config."
else
  echo "Backing up pre-existing dot files."

  files=$((config checkout 2>&1 || true) | awk '/^\s+/ { print $1 }')

  while read file; do
    backup_file $file
  done <<< $files
fi

config checkout
config config status.showUntrackedFiles no

echo "DONE"
