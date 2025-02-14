#!/bin/bash
function lineaSeparador()
{
	printf '%.s─' $(seq 1 $(tput cols))
} 
function clearConTexto()
{
	lineaSeparador
	echo '[Legitunlocks]'
	lineaSeparador
} 
function linux_depends()
{
	lineaSeparador
	echo '[Linux]'
	lineaSeparador
	echo 'The installation for Linux dependencies needs sudo permission, please input the password of your user (it is invisible) and press return'
	
	lineaSeparador	
	sudo -v
	if [[ $(which apt-get) ]]
	then	
		clearConTexto
		sudo apt-get install -y \
			build-essential \
			curl \
			checkinstall \
			git \
			autoconf \
			automake \
			libtool-bin \
			pkg-config \
			usbmuxd \
			libssl-dev \
			libusb-1.0-0-dev \
			zlib1g-dev \
			udev \
			libreadline-dev \
			libzip-dev \
			libxml2-dev \
			libcurl4-openssl-dev \
			zlib1g-dev \
			libusb-dev \
			libdbus-1-dev \
			plocate \
			libglib2.0-dev 
		clearConTexto
		sudo apt-get install -y protobuf-compiler
		clearConTexto
		sudo apt-get install -y python2 python3 python3-pip python3-tk
		clearConTexto
		python3 -m pip install --upgrade pip
		clearConTexto
		# Check for libprotobuf.so.23
		if ! locate libprotobuf.so.23; then
		    echo "libprotobuf.so.23 is not present, downloading and installing..."
		    wget http://archive.ubuntu.com/ubuntu/pool/main/p/protobuf/libprotobuf23_3.12.4-1ubuntu7_amd64.deb
		    if [[ -f "libprotobuf23_3.12.4-1ubuntu7_amd64.deb" ]]; then
		        echo "Package libprotobuf23_3.12.4-1ubuntu7_amd64.deb downloaded successfully."
		        sudo dpkg -i libprotobuf23_3.12.4-1ubuntu7_amd64.deb
		        sudo apt --fix-broken install
		        rm libprotobuf23_3.12.4-1ubuntu7_amd64.deb
		    else
		        echo "Error: Could not download the libprotobuf23 package."
		        exit 1
		    fi
		else
		    echo "libprotobuf.so.23 already exists in the system."
		fi
	fi
}
function macos_depends()
{
	lineaSeparador
	echo '[MacOS]'
	lineaSeparador
	echo 'The installation for MacOS dependencies needs sudo permission, please input the password of your user (it is invisible) and press return'
	lineaSeparador	
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$" || exit; done 2>/dev/null &
	if [[ ! -e $(which brew) ]] 
	then
		clearConTexto
		echo '[Brew]'
		lineaSeparador
		echo 'The package manager brew will be installed.'
		lineaSeparador
		sleep 5
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		clearConTexto
		echo '[Brew]'
		lineaSeparador
		echo 'brew is already installed. Ok!'
		lineaSeparador
		sleep 2
	fi
	clearConTexto
	echo 'From this point the installation is automated and it may take 10-40 minutes depending on internet and CPU speed.'
	lineaSeparador
	sleep 5
	clearConTexto

	for i in {1..10}; do
	    sudo chown -R $(whoami) /usr/local/share/man/man$i
	done
	
	brew install pkg-config libtool automake cmake
	clearConTexto

	brew install python@3.13 python-tk@3.13
}
function build_libimobiledevice()
{
	libs=( "libplist" "libtatsu" "libimobiledevice-glue" "libusbmuxd" "libimobiledevice" "usbmuxd" "libirecovery" "ideviceinstaller" "libideviceactivation" "idevicerestore" )
	buildlibs(){
		for i in "${libs[@]}"
		do
			clearConTexto
			rm -rf $i
			echo -e "[IDEV DEP] Fetching $i..."
			lineaSeparador
			git clone https://github.com/libimobiledevice/${i}.git
			cd $i
			lineaSeparador
			echo -e "[IDEV DEP] Configuring $i..."
			lineaSeparador
			PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./autogen.sh --without-cython
			lineaSeparador
			echo -e "[IDEV DEP] Building $i..."
			lineaSeparador
			make
			lineaSeparador
			echo -e "[IDEV DEP] Installing $i..."
			lineaSeparador
			sudo make install
			lineaSeparador
			cd ..
			rm -rf $i
			if [[ -e $(which ldconfig) ]] 
			then
				sudo ldconfig
			else 
				echo ""
			fi
		done
	}
	buildlibs
	if [[ -e $(which ldconfig) ]] 
	then
		sudo ldconfig
	else 
		echo ""
	fi
}
clearConTexto
echo 'Welcome! This script will install all the dependencies needed to run the tool without any problems or bugs.'
lineaSeparador
if [[ $(uname) == 'Linux' ]]
then
	linux_depends
elif [[ $(uname) == 'Darwin' ]]
then
	macos_depends
fi
clearConTexto
echo 'Dependencies installation is complete! You may now proceed with the other command to finalize the setup.'
echo 'Thanks for waiting!'
lineaSeparador
