# https://eric.blog/2019/01/12/install-unison-2-48-4-on-mac-os-x-with-homebrew/

# Get rid of existing Unison
brew uninstall --force unison

# Checkout version of homebrew with Unison 2.48.4
cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
git checkout 05460e0bf3ae5f1a15ae40315940b2d39dd6ac52 Formula/unison.rb

# Install
brew install --force-bottle unison

# Set homebrew-core back to normal
git checkout master
git reset HEAD .
git checkout -- .
