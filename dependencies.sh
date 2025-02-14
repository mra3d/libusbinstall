#!/bin/bash

function print_separator() {
    printf '%.s─' $(seq 1 $(tput cols))
}

function clear_with_text() {
    print_separator
    echo '[Legitunlocks]'
    print_separator
}

function install_macos_dependencies() {
    print_separator
    echo '[MacOS]'
    print_separator
    echo 'The installation for macOS dependencies requires sudo permission. Please enter your password (it is invisible) and press return.'
    print_separator
    
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$" || exit; done 2>/dev/null &
    
    if [[ ! -e $(which brew) ]]; then
        clear_with_text
        echo '[Homebrew]'
        print_separator
        echo 'The package manager Homebrew will be installed.'
        echo 'Please pay attention if the installation asks to press return (enter).'
        print_separator
        sleep 5
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        clear_with_text
        echo '[Homebrew]'
        print_separator
        echo 'Homebrew is already installed. Proceeding...'
        print_separator
        sleep 2
    fi
    
    clear_with_text
    echo 'Automated installation will now proceed. This may take 10-40 minutes depending on internet speed and CPU performance.'
    echo 'Sit back, relax, and please wait.'
    print_separator
    sleep 5
    
    for i in {1..10}; do
        sudo chown -R $(whoami) /usr/local/share/man/man$i
    done
    
    brew install pkg-config libtool automake cmake python@3.13 python-tk@3.13
    
    clear_with_text
    
    if ! ideviceactivation -v; then
        build_libimobiledevice
    else
        clear_with_text
        echo '[iDevice]'
        print_separator
        echo 'iDevice is already installed. Proceeding...'
        print_separator
        sleep 2
    fi
}

function build_libimobiledevice() {
    libs=( "libplist" "libtatsu" "libimobiledevice-glue" "libusbmuxd" "libimobiledevice" "usbmuxd" "libirecovery" "ideviceinstaller" "libideviceactivation" "idevicerestore" )
    
    for lib in "${libs[@]}"; do
        clear_with_text
        rm -rf $lib
        echo "[Building] Fetching $lib..."
        print_separator
        git clone https://github.com/libimobiledevice/${lib}.git
        cd $lib
        print_separator
        echo "[Building] Configuring $lib..."
        print_separator
        PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./autogen.sh --without-cython
        print_separator
        echo "[Building] Compiling $lib..."
        print_separator
        make
        print_separator
        echo "[Building] Installing $lib..."
        print_separator
        sudo make install
        print_separator
        cd ..
        rm -rf $lib
        
        if [[ -e $(which ldconfig) ]]; then
            sudo ldconfig
        fi
    done
    
    if [[ -e $(which ldconfig) ]]; then
        sudo ldconfig
    fi
}

clear_with_text

echo 'Welcome! This script will install all dependencies .'
print_separator

if [[ $(uname) == 'Darwin' ]]; then
    install_macos_dependencies
fi

clear_with_text
echo 'Dependency installation is complete!'
echo 'Thank you for your patience!'
print_separator
