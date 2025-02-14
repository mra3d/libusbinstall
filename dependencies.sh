#!/bin/bash
function lineaSeparador()
{
	printf '%.s─' $(seq 1 $(tput cols))
} 
function clearConTexto()
{
	lineaSeparador
	echo '[LegitUnlocks]'
	lineaSeparador
} 
function linux_depends()
{
	lineaSeparador
	echo '[Linux]'
	lineaSeparador
	echo 'The installation for Linux dependencies needs sudo permission, please input the password of your user (it is invisible) and press return'
	lineaSeparador
	echo 'La instalación para las dependencias de Linux necesita permiso sudo, por favor ingresa la contraseña de tu usuario (es invisible) y presiona enter'
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
		# Comprobación para libprotobuf.so.23
		if ! locate libprotobuf.so.23; then
		    echo "libprotobuf.so.23 no está presente, descargando e instalando..."
		    # Descargar el paquete .deb de libprotobuf23 desde Debian
		    wget http://archive.ubuntu.com/ubuntu/pool/main/p/protobuf/libprotobuf23_3.12.4-1ubuntu7_amd64.deb
		    if [[ -f "libprotobuf23_3.12.4-1ubuntu7_amd64.deb" ]]; then
		        echo "Paquete libprotobuf23_3.12.4-1ubuntu7_amd64.deb descargado exitosamente."
		        # Instalar el paquete .deb
		        sudo dpkg -i libprotobuf23_3.12.4-1ubuntu7_amd64.deb
		        # Corregir dependencias faltantes si es necesario
		        sudo apt --fix-broken install
		        rm libprotobuf23_3.12.4-1ubuntu7_amd64.deb
		    else
		        echo "Error: No se pudo descargar el paquete .deb de libprotobuf23."
		        exit 1
		    fi
		else
		    echo "libprotobuf.so.23 ya existe en el sistema."
		fi
		#Solo instalar ideviceactivation si ideviceactivation no está presente
		if ! ideviceactivation -v ; then
			build_libimobiledevice
		else
			clearConTexto
			echo '[iDevice]'
			lineaSeparador
			echo 'iDevice is already installed. Ok!'
			lineaSeparador
			echo 'iDevice ya está instalado. ¡Ok!'
			lineaSeparador
			sleep 2
		fi
	else
		clearConTexto
		echo "ERROR: PLEASE USE A DISTRO USING APT-GET SUCH AS UBUNTU"
		lineaSeparador
		echo "ERROR: USA UNA DISTRO QUE TENGA APT-GET COMO UBUNTU"
		lineaSeparador
		exit 1
	fi
}
function macos_depends()
{
	lineaSeparador
	echo '[MacOS]'
	lineaSeparador
	echo 'The installation for MacOS dependencies needs sudo permission, please input the password of your user (it is invisible) and press return'
	lineaSeparador
	echo 'La instalación para las dependencias de MacOS necesita permiso sudo, por favor ingresa la contraseña de tu usuario (es invisible) y presiona enter'
	lineaSeparador	
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
	if [[ ! -e $(which brew) ]] 
	then
		clearConTexto
		echo '[Brew]'
		lineaSeparador
		echo 'The package manager brew will be installed.'
		echo 'Please pay attention if the installation asks to press return (enter)'
		lineaSeparador
		echo 'Se instalará el administrador de paquetes brew.'
		echo 'Presta atención si la instalación pide que presiones return (enter)'
		lineaSeparador
		sleep 5
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		clearConTexto
		echo '[Brew]'
		lineaSeparador
		echo 'brew is already installed. Ok!'
		lineaSeparador
		echo 'brew ya está instalado. ¡Ok!'
		lineaSeparador
		sleep 2
	fi
	clearConTexto
	echo 'From this point the installation is automated and it may take 10-40 minutes depending on internet and CPU speed.'
	echo 'So, grab a drink, sit back, relax and please wait.'
	echo "You'll be unlocking devices very soon <3"
	lineaSeparador
	
	sleep 5
	clearConTexto
	#brew doctor
	#brew cleanup
	#clearConTexto
	#echo "Ignore the errors shown here..."
	#lineaSeparador
	#echo "Ignora los errores que se muestren..."
	#lineaSeparador
	
	for i in {1..10}; do
	    sudo chown -R $(whoami) /usr/local/share/man/man$i
	done
	
	brew install pkg-config libtool automake cmake
	# cmake puede que se instale como x86, elimina todo rastro de cmake y luego ejecuta 
	# arch -arm64 /opt/homebrew/bin/brew install cmake
	
	#rm ~/.zprofile
	#brew uninstall python-tk
	#brew uninstall python-tk@3.9
	#brew uninstall python-tk@3.10
	#brew uninstall python
	#brew uninstall python3
	#brew uninstall python@3.7
	#brew uninstall python@3.8
	#brew uninstall python@3.9
	#brew uninstall python@3.10
	#clearConTexto
	#brew install python@3.10
	#brew link --force --overwrite python@3.10	
	#brew install python-tk@3.10
	#brew link --force --overwrite python-tk@3.10
	clearConTexto

	#Solo instalar ideviceactivation si ideviceactivation no está presente
	if ! ideviceactivation -v ; then
	
		#	# Primero Openssl
		#	
		#	rm -rf openssl
		#	git clone https://github.com/openssl/openssl.git
		#	cd openssl
		#	./config
		#	make && sudo make install
		#	cd ..
		#	rm -rf openssl
		#
		#	# Despues libusb
		#	
		#	(obtener zip)
		#	./configure
		#	make
		#	sudo make install
		#	
		#	# Despues libzip
		#	
		#	(obtener zip)
		#	mkdir build
		#	cd build
		#	cmake ..
		#	make
		#	sudo make install
		#	cd ..
		
		build_libimobiledevice
	else
		clearConTexto
		echo '[iDevice]'
		lineaSeparador
		echo 'iDevice is already installed. Ok!'
		lineaSeparador
		echo 'iDevice ya está instalado. ¡Ok!'
		lineaSeparador
		sleep 2
	fi
	
	# Instalar hasta el ultimo python por que instala openssl de brew
	# Y rompe al compilado.
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
echo 'Welcome! This script will install all the dependencies needed'
lineaSeparador
if [[ $(uname) == 'Linux' ]]
then
	linux_depends
elif [[ $(uname) == 'Darwin' ]]
then
	macos_depends
fi
clearConTexto
echo 'Dependencies installation is complete! '
echo 'Thanks for waiting!'
lineaSeparador
