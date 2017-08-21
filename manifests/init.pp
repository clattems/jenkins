class jenkins {

  exec { 'install_jenkins_package_keys':
    command => '/usr/bin/wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo | rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key',
    unless  => '/bin/test -e /etc/yum.repos.d/jenkins.repo',
  }
  exec { 'open firewall ports':
    command => '/bin/firewall-cmd --add-port=8000/tcp --perm; firewall-cmd --reload',
    unless  => '/bin/firewall-cmd --list-all|grep 8000'
  }

  package { 'java':
      ensure => latest,
  }

  package { 'jenkins':
      ensure => latest,
    require  => [ Exec['install_jenkins_package_keys']],
  }

  service { 'jenkins':
    ensure => running,
    enable => true,
  }

  file { '/etc/sysconfig/jenkins':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/jenkins/jenkins',
    notify => Service['jenkins'],
  }
}
