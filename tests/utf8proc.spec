Summary: Library for processing UTF-8 encoded Unicode strings
Name:    utf8proc
Version: 2.1.0
Release: 1%{?dist}
License: BSD
Group:   System Environment/Libraries
URL:     http://julialang.org/utf8proc/
Source:  https://github.com/JuliaLang/utf8proc/archive/v%{version}.tar.gz#/%{name}-v%{version}.tar.gz

%description
utf8proc is a library for processing UTF-8 encoded Unicode strings.
Some features are Unicode normalization, stripping of default ignorable
characters, case folding and detection of grapheme cluster boundaries.
A special character mapping is available, which converts for example
the characters “Hyphen” (U+2010), “Minus” (U+2212) and “Hyphen-Minus
(U+002D, ASCII Minus) all into the ASCII minus sign, to make them
equal for comparisons.

The currently supported Unicode version is 9.0.0.

This package only contains the C library.

%package devel
Summary:  Header files, libraries and development documentation for %{name}
Group:    Development/Libraries
Requires: %{name}%{?_isa} = %{version}-%{release}

%description devel
Contains header files for developing applications that use the %{name}
library.

The documentation for the C library is found in the utf8proc.h header file.
"utf8proc_map" is most likely the function you will be using for mapping UTF-8
strings, unless you want to allocate memory yourself.

%prep
%setup -qn %{name}-%{version}

%build
make %{?_smp_mflags} CFLAGS="%{optflags}"

%check
make %{?_smp_mflags} CFLAGS="%{optflags}" \
     test/normtest test/graphemetest test/printproperty \
     test/charwidth test/normtest test/graphemetest test/charwidth

%install
make install DESTDIR=%{buildroot} prefix=%{_prefix} includedir=%{_includedir} libdir=%{_libdir}
rm %{buildroot}%{_libdir}/libutf8proc.a

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%doc LICENSE.md NEWS.md README.md
%{_libdir}/libutf8proc.so.*

%files devel
%{_includedir}/utf8proc.h
%{_libdir}/libutf8proc.so

%changelog
* Sat Jan 7 2017  Milan Bouchet-Valat <nalimilan@club.fr> - 2.1.0
- New upstream release.

* Thu Sep 15 2016  Milan Bouchet-Valat <nalimilan@club.fr> - 2.0.2-1
- New upstream release.

* Fri Feb 05 2016 Fedora Release Engineering <releng@fedoraproject.org> - 1.3.1-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_24_Mass_Rebuild

* Tue Nov 03 2015  Milan Bouchet-Valat <nalimilan@club.fr> - 1.3.1-1
- New upstream release.

* Tue Aug 11 2015 Milan Bouchet-Valat <nalimilan@club.fr> - 1.3-1
- New upstream release.

* Fri Jun 19 2015 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.2-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_23_Mass_Rebuild

* Sat Mar 28 2015 Milan Bouchet-Valat <nalimilan@club.fr> - 1.2-1
- New upstream release.

* Mon Aug 18 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.1.6-5
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_22_Mass_Rebuild

* Sun Jun 08 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.1.6-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Sun May 4 2014 Milan Bouchet-Valat <nalimilan@club.fr> - 1.1.6-3
- Add downstream SONAME version 0.1 since upstream does not set one.

* Fri Feb 14 2014 Milan Bouchet-Valat <nalimilan@club.fr> - 1.1.6-2
- Fix package Group.
- Do not remove build root on install phase.

* Sun Jan 26 2014 Milan Bouchet-Valat <nalimilan@club.fr> - 1.1.6-1
- Adapt package to Fedora.
- Updated to release 1.1.6.

* Sat Aug 29 2009 Dries Verachtert <dries@ulyssis.org> - 1.1.4-1 - 7981/dag
- Updated to release 1.1.4.

* Sun Jul 29 2007 Dries Verachtert <dries@ulyssis.org> - 1.1.2-1
- Updated to release 1.1.2.

* Mon Jul 23 2007 Dries Verachtert <dries@ulyssis.org> - 1.1.1-1
- Updated to release 1.1.1.

* Tue Apr 17 2007 Dries Verachtert <dries@ulyssis.org> - 1.0.3-1
- Initial package.
