#  Copyright (C) 2018 Curt Brune <curt@cumulusnetworks.com>
#
#  SPDX-License-Identifier:     GPL-2.0

FROM debian:9

# Add initial development packages
RUN apt-get update && apt-get install -y \
    build-essential util-linux sudo libelf-dev \
    openssh-client sbsigntool gcc-multilib debhelper

# Create cumulus user
RUN useradd -m -s /bin/bash cumulus && \
        adduser cumulus sudo && \
        echo "cumulus:cumulus" | chpasswd

WORKDIR /home/cumulus

# Add the source files
COPY src src

RUN mkdir build

RUN dpkg-source -x src/gnu-efi_3.0.8-cl4u1.dsc build/gnu-efi && \
        cd build/gnu-efi && \
        dpkg-buildpackage -j8 -uc -us -nc -b && \
        dpkg -i ../gnu-efi_3.0.8-cl4u1_amd64.deb

RUN dpkg-source -x src/shim-unsigned_15-cl4u1.dsc build/shim-unsigned && \
        cd build/shim-unsigned && \
        dpkg-buildpackage -j8 -uc -us -nc -b

# Goods are in /home/cumulus/build/shim-unsigned/debian/shim-unsigned/usr/share/shim

# Make sure everything in /home/cumulus is owned by the cumulus user
RUN chown -R cumulus:cumulus .

USER cumulus

CMD ["/bin/bash", "--login"]
