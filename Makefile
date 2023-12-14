prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib
buildroot = $(shell swift build -c release --show-bin-path)

configure:
	echo "let DEFAULT_PLUGIN_LOCATION=\"$(libdir)/libSwitGrapModuleImportPlugin.dylib\"" > Sources/switgrap/Generated.swift

build: configure
	xcrun swift build -c release --disable-sandbox

install: build
	# Seems like brew hasn't created this yet and it confuses 'install' so...
	mkdir -p "$(bindir)"
	mkdir -p "$(libdir)"
	# Install the binary
	install "$(buildroot)/switgrap" "$(bindir)"
	# Install the libs
	install "$(buildroot)/libSwitGrapPluginSupport.dylib" "$(libdir)"
	install "$(buildroot)/libSwitGrapModuleImportPlugin.dylib" "$(libdir)"
	install_name_tool -change "$(buildroot)/libSwitGrapPluginSupport.dylib" "$(libdir)/libSwitGrapPluginSupport.dylib" "$(bindir)/switgrap"
	install_name_tool -change "@rpath/libSwitGrapPluginSupport.dylib" "$(libdir)/libSwitGrapPluginSupport.dylib" "$(bindir)/switgrap"

uninstall:
	rm -rf "$(bindir)/switgrap"
	rm -rf "$(libdir)/libSwitGrapPluginSupport.dylib"
	rm -rf "$(libdir)/libSwitGrapModuleImportPlugin.dylib"

lint:
	swiftlint --autocorrect .
	swiftlint .
	swiftformat .

clean:
	rm -rf .build
	rm Sources/switgrap/Generated.swift

.PHONY: build install uninstall clean configure
