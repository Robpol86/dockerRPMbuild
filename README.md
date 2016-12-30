# Docker RPM Build Images

Minimal Docker Images for building RPM files for different RedHat-based Linux distributions.

Available images:
* [fedoraRawhide](https://github.com/Robpol86/dockerRPMbuild/blob/master/fedora/rawhide/Dockerfile)
* [fedora25](https://github.com/Robpol86/dockerRPMbuild/blob/master/fedora/25/Dockerfile)
* [fedora24](https://github.com/Robpol86/dockerRPMbuild/blob/master/fedora/24/Dockerfile)
* [fedora23](https://github.com/Robpol86/dockerRPMbuild/blob/master/fedora/23/Dockerfile)
* [fedora22](https://github.com/Robpol86/dockerRPMbuild/blob/master/fedora/22/Dockerfile)

## Usage

To use one of the images to build your RPM file run the following command (using fedora25 as an example):
```bash
mkdir out
sudo docker run -v $PWD:/SPECS:Z -v $PWD:/SOURCES:Z -v $PWD/out:/RPMS:Z -v $PWD/out:/SRPMS:Z robpol86/dockerrpmbuild:fedora25
```

This assumes your .spec file and any additional local sources (remote/http sources will be downloaded by the container
automatically) are in the current working directory. If you don't have any local sources you can just omit the
`-v $PWD:/SOURCES` argument.

Note if you omit the `:Z` suffixes from all of the volumes when running the `docker run` command you may run into
SELinux permission issues. More info: http://stackoverflow.com/questions/24288616/permission-denied-on-accessing-host-directory-in-docker
