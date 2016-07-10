#!/bin/bash -e
set -e

 #working sometimes :D  I have to code something to handle missing dependencies
 
listofpackages=(
    mate-common
    libmatekbd
    libmateweather
    libmatemixer
    mate-icon-theme
    mate-icon-theme-faenza
    mate-dialogs
    mate-desktop
    caja
    mate-notification-daemon
    mate-backgrounds
    mate-menus
    marco
    mate-polkit
    mate-settings-daemon
    mate-control-center
    mate-panel
    mate-session-manager
    pluma
    engrampa
    atril
    mate-media
    mate-power-manager
    python2-caja
    caja-extensions
    mate-applets
    mate-screensaver
    mate-sensors-applet
    mate-user-share
    )
    

for package in ${listofpackages[@]}
	do
	echo " "
	echo "----->  Starting $package build"
	cd $package

	if [ -f *.pkg.tar.xz ];
	then echo "----- $package package already built ^^ I'm checking if it's already installed..."
			if [[  `pacman -Qqe | grep "$package"` ]];
				then installed_pkg_stuff=$(pacman -Q | grep $package);
		#those operations could be done/written in a shorter [but a little more complex] way. I choose to let it this way to have a "readable" code
		newver=$(cat PKGBUILD | grep pkgver=) && newver=${newver##pkgver=};
		installedver=$(pacman -Q | grep $package) && installedver=${installedver##$package} && installedver=${installedver%%-*};

				if [ $newver == $installedver ]
						then  echo "!****! The same version of package $package is already  installed,skipping...."
						
				fi
			fi
	else (echo "---------- START Making ->  $package -------------------" && makepkg ) && sudo pacman -U --noconfirm $package-*.pkg.tar.xz
			
	fi

#break if there is some error
  if [ $? -ne 0 ]
  then
    break
  fi


	
echo "-----> Done building & installing $package"
echo " "

cd ..
done
