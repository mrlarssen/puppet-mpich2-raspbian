node default {
#install fortran
  package {"gfortran":
    ensure => "installed",
    before => File["/home/pi/mpich2", "/home/pi/mpich2/install", "/home/pi/mpich2/build"],
  }

#create directory
  file {["/home/pi/mpich2", "/home/pi/mpich2/install", "/home/pi/mpich2/build"]:
    ensure => "directory",
    before => Exec["download_mpich2"],
  }

#wget MPICH2
  exec {"download_mpich2":
    command => "wget http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.4.1p1/mpich2-1.4.1p1.tar.gz -O /home/pi/mpich2/mpich2-1.4.1p1.tar.gz",
    creates => "/home/pi/mpich2/mpich2-1.4.1p1.tar.gz",
    path => "/usr/bin/",
    before => Exec["unarchive"],
  }

#unarchive
  exec {"unarchive":
    command => "tar -zxvf /home/pi/mpich2/mpich2-1.4.1p1.tar.gz",
    cwd => "/home/pi/mpich2",
    creates => "/home/pi/mpich2/mpich2-1.4.1p1",
    path => "/bin/",
    before => Exec["configure_mpich2"],
  }

#configure mpich2
  exec {"configure_mpich2":
    command => "/home/pi/mpich2/mpich2-1.4.1p1/configure --prefix=/home/pi/mpich2/install",
    cwd => "/home/pi/mpich2/build",
    timeout => 3600,
    before => Exec["make"],
  }

#make
  exec {"make":
    command => "make",
    cwd => "/home/pi/mpich2/build",
    path => ["/usr/bin/", "/bin/"],
    logoutput => "on_failure",
    timeout => 3600,
    before => Exec["make_install"],
  }

#make install
  exec {"make_install":
    command => "make install",
    cwd => "/home/pi/mpich2/build",
    path => ["/usr/bin/", "/bin/"],
    timeout => 3600,
    before => File["/home/pi/.profile"],
  }

#add to path
  file {"/home/pi/.profile":
    ensure => "present",
    content => "PATH=\$PATH:/home/pi/mpich2/install/bin",
  }
}
