# Gentoo pre-builds

Pre-built packages to reduce build time and image size for gentoo-based
container images.

## Usage
### 1. Use `mprzybylski/gentoo-prebuilds/gentoo-with-binpkgs:<date_code_tag>` as the base image
This is based on the `gentoo/stage3` image with `emerge --sync` already run, and pre-built, binary
packages stored in `/var/cache/binpkgs`

Its tags track the simple, date-coded tags in https://hub.docker.com/r/gentoo/stage3/tags like `20240729` or
`20240805`

### 2. Run `emerge` and `crossdev` commands with the `--usepkgonly` flag

This forces `emerge` to try to install every package it needs using only the packages in `/var/cache/binpkgs`.
If it is unable to install the necessary packages, `emerge` will exit with an error.  This allows the developer
to see what packages are missing, have the wrong `USE` flags, etc., and add them rather than falling back on
building missing or misconfigured packages from source.

### 3. Pipe the image through `tar --wildcards --delete 'var/db/repos/*' --delete 'var/cache/binpkgs/*'`

It is possible to strip nearly 800MB out of the final docker image by removing the contents of
`/var/db/repos` and `/var/cache/binpkgs` from the image after all the desired packages are installed.

A simple way to accomplish this is to create a temporary container, `docker export ...` the container, pipe
`docker export`'s output to `tar --wildcards --delete 'var/db/repos/*' --delete 'var/cache/binpkgs/*'`,
and then pipe `tar`'s output to `docker import - ...`, i.e.:

```shell
CONTAINER_ID="$(docker create "mprzybylski/bpf-iotrace/fat-dev-image:20240729")"
docker export $CONTAINER_ID | \
    tar --wildcards --delete 'var/db/repos/*' --delete 'var/cache/binpkgs/*' | \
    docker import - "mprzybylski/bpf-iotrace/dev-image:20240729"
```

Don't forget to remove the temporary container after this operation is complete.

The results speak for themselves:
```text
mikep@thinky-winks:~$ docker image ls
REPOSITORY                                  TAG        IMAGE ID       CREATED          SIZE
mprzybylski/bpf-iotrace/dev-image           20240729   78909a47c2f5   26 minutes ago   2.64GB
mprzybylski/bpf-iotrace/fat-dev-image       20240729   bb1260d99fcb   27 minutes ago   3.45GB
...
```

## Pre-built packages

The `mprzybylski/gentoo-prebuilds/gentoo-with-binpkgs` image currently caches the following pre-built binary packages:
* acct-group/dnsmasq-0-r3
* acct-group/messagebus-0-r3
* acct-group/nullmail-0-r2
* acct-group/qemu-0-r3
* acct-group/radvd-0-r2
* acct-group/tss-0-r3
* acct-user/dnsmasq-0-r3
* acct-user/messagebus-0-r3
* acct-user/nullmail-0-r2
* acct-user/qemu-0-r3
* acct-user/radvd-0-r2
* acct-user/tss-0-r3
* app-admin/metalog-20230719
* app-admin/sudo-1.9.15_p5
* app-arch/brotli-1.1.0
* app-arch/libarchive-3.7.4
* app-arch/tar-1.35
* app-arch/unzip-6.0_p27-r1
* app-arch/zip-3.0-r7
* app-crypt/p11-kit-0.25.3-r2
* app-crypt/rhash-1.4.3
* app-crypt/swtpm-0.8.2
* app-emulation/libvirt-10.3.0-r2
* app-emulation/libvirt-glib-5.0.0
* app-emulation/qemu-8.2.3
* app-emulation/virt-manager-4.1.0-r1
* app-eselect/eselect-fontconfig-20220403
* app-eselect/eselect-repository-14
* app-misc/scrub-2.6.1-r1
* app-text/docbook-xml-dtd-4.4-r3
* app-text/xhtml1-20020801-r6
* app-text/xmlto-0.0.28-r11
* cross-x86_64-generic-linux-gnu/binutils-2.42-r2
* cross-x86_64-generic-linux-gnu/gcc-14.2.0
* cross-x86_64-generic-linux-gnu/gdb-15.1
* cross-x86_64-generic-linux-gnu/glibc-2.26-r7
* cross-x86_64-generic-linux-gnu/linux-headers-4.14-r2
* dev-build/cmake-3.28.5
* dev-build/make-4.3-r1
* dev-build/ninja-1.11.1-r5
* dev-lang/nasm-2.16.01-r1
* dev-lang/vala-0.56.16
* dev-libs/elfutils-0.191-r1
* dev-libs/glib-2.78.6
* dev-libs/gobject-introspection-1.78.1
* dev-libs/gobject-introspection-common-1.78.1
* dev-libs/json-glib-1.8.0
* dev-libs/jsoncpp-1.9.5
* dev-libs/libaio-0.3.113-r1
* dev-libs/libburn-1.5.6-r1
* dev-libs/libisoburn-1.5.6-r1
* dev-libs/libisofs-1.5.6_p1-r1
* dev-libs/libnl-3.9.0
* dev-libs/libtpms-0.9.6
* dev-libs/libuv-1.48.0
* dev-libs/lzo-2.10
* dev-libs/vala-common-0.56.16
* dev-libs/yajl-2.1.0-r4
* dev-perl/Authen-SASL-2.170.0
* dev-perl/Clone-0.460.0
* dev-perl/Devel-CheckLib-1.160.0-r1
* dev-perl/Digest-HMAC-1.40.0
* dev-perl/Encode-Locale-1.50.0-r1
* dev-perl/Error-0.170.290
* dev-perl/File-Listing-6.160.0
* dev-perl/HTML-Parser-3.820.0
* dev-perl/HTML-Tagset-3.240.0
* dev-perl/HTTP-Cookies-6.110.0
* dev-perl/HTTP-Date-6.60.0
* dev-perl/HTTP-Message-6.460.0
* dev-perl/HTTP-Negotiate-6.10.0-r2
* dev-perl/IO-HTML-1.4.0
* dev-perl/IO-Socket-INET6-2.730.0
* dev-perl/IO-Socket-SSL-2.85.0
* dev-perl/LWP-MediaTypes-6.40.0
* dev-perl/LWP-Protocol-https-6.140.0
* dev-perl/MailTools-2.210.0
* dev-perl/Mozilla-CA-20999999-r1
* dev-perl/Net-HTTP-6.230.0
* dev-perl/Net-SSLeay-1.940.0
* dev-perl/Regexp-IPv6-0.30.0-r2
* dev-perl/Socket6-0.290.0
* dev-perl/Sub-Name-0.270.0
* dev-perl/TimeDate-2.330.0-r1
* dev-perl/Try-Tiny-0.310.0
* dev-perl/URI-5.280.0
* dev-perl/WWW-RobotRules-6.20.0-r2
* dev-perl/XML-Parser-2.470.0
* dev-perl/XML-XPath-1.480.0
* dev-perl/libwww-perl-6.770.0
* dev-python/argcomplete-3.4.0
* dev-python/cachecontrol-0.14.0
* dev-python/colorama-0.4.6
* dev-python/distlib-0.3.8
* dev-python/distro-1.9.0
* dev-python/docutils-0.21.2
* dev-python/fastjsonschema-2.20.0
* dev-python/lark-1.1.9
* dev-python/libvirt-python-10.3.0
* dev-python/linkify-it-py-2.0.3
* dev-python/markdown-it-py-3.0.0
* dev-python/mdurl-0.1.2
* dev-python/msgpack-1.0.8
* dev-python/olefile-0.47
* dev-python/pillow-10.4.0
* dev-python/pip-24.1.2
* dev-python/poetry-core-1.9.0
* dev-python/pycairo-1.26.1
* dev-python/pygments-2.18.0
* dev-python/pygobject-3.46.0-r1
* dev-python/pyproject-hooks-1.1.0
* dev-python/resolvelib-1.0.1
* dev-python/rich-13.7.1
* dev-python/tenacity-8.5.0
* dev-python/tomli-2.0.1-r1
* dev-python/truststore-0.9.1
* dev-python/uc-micro-py-1.0.3
* dev-util/bpftool-6.9.2
* dev-util/desktop-file-utils-0.27
* dev-util/glib-utils-2.78.6
* dev-util/patchutils-0.4.2
* dev-vcs/git-2.44.2
* gnome-base/gsettings-desktop-schemas-45.0
* mail-mta/nullmailer-2.2-r2
* media-fonts/liberation-fonts-2.1.5
* media-libs/fontconfig-2.15.0
* media-libs/freetype-2.13.2
* media-libs/libjpeg-turbo-3.0.0
* media-libs/libpng-1.6.43
* net-analyzer/openbsd-netcat-1.219_p1
* net-dns/dnsmasq-2.90
* net-firewall/ebtables-2.0.11-r3
* net-libs/glib-networking-2.78.1
* net-libs/gnutls-3.8.0
* net-libs/libproxy-0.5.5
* net-libs/libslirp-4.7.0
* net-libs/libsoup-3.4.4
* net-libs/nghttp2-1.61.0
* net-misc/curl-8.8.0-r1
* net-misc/ethertypes-0
* net-misc/radvd-2.19-r5
* perl-core/Compress-Raw-Zlib-2.206.0
* sys-apps/config-site-0
* sys-apps/dbus-1.15.8
* sys-apps/dmidecode-3.6
* sys-apps/dtc-1.6.0
* sys-apps/hwdata-0.383
* sys-apps/osinfo-db-20240523
* sys-apps/osinfo-db-tools-1.11.0
* sys-devel/clang-18.1.8
* sys-devel/clang-common-18.1.8-r1
* sys-devel/clang-runtime-18.1.8
* sys-devel/clang-toolchain-symlinks-18
* sys-devel/crossdev-20240209
* sys-devel/llvm-18.1.8-r1
* sys-devel/llvm-common-18.1.8
* sys-devel/llvm-toolchain-symlinks-18
* sys-devel/llvmgold-18
* sys-firmware/edk2-ovmf-bin-202202
* sys-firmware/ipxe-1.21.1
* sys-firmware/seabios-bin-1.16.0
* sys-firmware/sgabios-0.1_pre10
* sys-libs/binutils-libs-2.42-r1
* sys-libs/compiler-rt-18.1.8
* sys-libs/compiler-rt-sanitizers-18.1.8
* sys-libs/libcap-ng-0.8.5
* sys-libs/libomp-18.1.8
* sys-libs/libosinfo-1.11.0
* virtual/libelf-3-r1
* virtual/libudev-251-r2
* virtual/logger-0-r1
* virtual/mta-1-r2
* virtual/perl-Compress-Raw-Bzip2-2.204.1_rc
* virtual/perl-Compress-Raw-Zlib-2.206.0
* virtual/perl-Digest-MD5-2.580.100_rc-r1
* virtual/perl-Digest-SHA-6.40.0-r1
* virtual/perl-IO-1.520.0
* virtual/perl-IO-Compress-2.204.0
* virtual/perl-IO-Socket-IP-0.410.100_rc
* virtual/perl-MIME-Base64-3.160.100_rc-r1
* virtual/perl-Module-Load-0.360.0-r4
* virtual/perl-Time-Local-1.300.0-r2
* virtual/perl-XSLoader-0.320.0-r1
* virtual/perl-libnet-3.150.0-r1
* virtual/perl-parent-0.241.0-r1
* virtual/ttf-fonts-1-r2
* x11-base/xorg-proto-2024.1
* x11-libs/cairo-1.18.0
* x11-libs/libpciaccess-0.18.1
* x11-libs/pixman-0.43.4
* x11-misc/shared-mime-info-2.4-r1

