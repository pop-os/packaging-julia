rootdir := ''
arch := `uname -m`
version := '1.8.2'
target := 'julia-' + version
filename := 'julia-' + version + '-linux-' + arch
tarballs := 'upstream'
compressed := tarballs + '/' + filename + '.tar.gz'

all:
	tar -xf {{compressed}}

distclean:
	rm -rf {{filename}} upstream julia-*

install:
  mkdir -p {{rootdir}}/usr
  mkdir -p {{rootdir}}/usr/share/licenses/julia
  mkdir -p {{rootdir}}/usr/share/icons/hicolor/scalable/apps/
  cp ./{{target}}/* {{rootdir}}/usr -r
  cp julia-dots.svg {{rootdir}}/usr/share/icons/hicolor/scalable/apps/julia.svg
  install -Dm644 ./{{target}}/LICENSE.md {{rootdir}}/usr/share/licenses/julia/LICENSE.md
