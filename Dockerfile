FROM ubuntu:18.04

RUN apt-get update && apt-get -y upgrade

# Install the following utilities (required by poky)
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/London" apt-get install -y build-essential chrpath curl diffstat gcc-multilib gawk git-core libsdl1.2-dev texinfo unzip wget xterm dos2unix python bc u-boot-tools cpio gawk wget git diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping libsdl1.2-dev xterm autoconf libtool libglib2.0-dev libarchive-dev python-git sed cvs subversion coreutils texi2html docbook-utils python-pysqlite2 help2man make gcc g++ desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial automake groff curl lzop asciidoc u-boot-tools dos2unix mtd-utils pv libncurses5 libncurses5-dev libncursesw5-dev libelf-dev zlib1g-dev bc rename

# Additional host packages required by poky/scripts/wic
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/London" apt-get install -y bzip2 dosfstools mtools parted syslinux tree cpio

# Add "repo" tool (used by many Yocto-based projects)
RUN curl http://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

# Create user "jenkins"
RUN id jenkins 2>/dev/null || useradd --uid 1000 --create-home jenkins

# Create a non-root user that will perform the actual build
RUN id build 2>/dev/null || useradd --uid 30000 --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# Fix error "Please use a locale setting which supports utf-8."
# See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN apt -y install locales && \
  dpkg-reconfigure locales && \
  locale-gen en_US.UTF-8 && \
  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

USER build
WORKDIR /home/build
CMD "/bin/bash"

# EOF
