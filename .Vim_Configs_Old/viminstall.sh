git clone https://github.com/vim/vim.git ~/vim-src &&
cd ~/vim-src &&
.configure --prefix=$HOME/.local \
            --enable-python3interp=yes \
            --with-features=huge \
            --disable-gui \
            --without-x &&
make && make install &&
cd ~ &&
rm -rf ~/vim-src &&
echo "Vim installed successfully!"
