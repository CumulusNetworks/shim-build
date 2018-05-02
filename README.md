# Build SHIM with Cumulus Certificate

The Dockerfile creates a Debian 9 based build environment and:

* builds/installs gnu-efi-3.0.8
* builds/installs shim-15, containing Cumulus certificate

## Create Debian 9 Based Container

Build the container image like this:

```
linux:~/shim-build$ docker build -t cumulus:shim-build .
```

## Look at Build Results

Start the container and look in the /home/cumulus/build directory:

```
linux:~/shim-build$ docker run -it --name verify-build cumulus:shim-build
cumulus@0eb25f287084:~$ find build/shim-unsigned/debian/shim-unsigned -name *.efi
build/shim-unsigned/debian/shim-unsigned/usr/share/shim/mmx64.efi
build/shim-unsigned/debian/shim-unsigned/usr/share/shim/fbx64.efi
build/shim-unsigned/debian/shim-unsigned/usr/share/shim/shimx64.efi
```

If needed, the `cumulus` user has sudo privs, using the password
`cumulus`.

## Changes from shim-15 release

The only modification to the base shim-15 release is the addition of
the debian/ subdirectory.  Those changes are contained in
`0001-CUMULUS-add-initial-debian-directory.patch`.
