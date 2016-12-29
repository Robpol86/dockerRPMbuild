# Docker RPM Build Images

Minimal Docker Images for building RPM files for different RedHat-based Linux distributions.

Available images:
* [fedora25](https://github.com/Robpol86/dockerRPMbuild/blob/master/fedora/25/Dockerfile)

## Usage

To use one of the images to build your RPM file run the following command (using fedora25 as an example):
```bash
mkdir out
sudo docker run -v $PWD:/SPECS -v $PWD:/SOURCES -v $PWD/out:/RPMS -v $PWD/out:/SRPMS robpol86/dockerrpmbuild:fedora25 
```

This assumes your .spec file and any additional local sources (remote/http sources will be downloaded by the container
automatically) are in the current working directory. If you don't have any local sources you can just omit the
`-v $PWD:/SOURCES` argument.
