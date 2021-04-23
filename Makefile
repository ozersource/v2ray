THISDIR = $(shell pwd)
PKG_NAME:=Xray-core
PKG_VERSION := 1.4.2
PKG_RELEASE:=1
export GO111MODULE=off
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
export GOPROXY=https://goproxy.io

PKG_URL := https://codeload.github.com/XTLS/xray-core/tar.gz/v$(PKG_VERSION)

all:download_PKG build_extract build

build_extract:
	mkdir -p $(THISDIR)/github.com/xtls
	mkdir -p $(THISDIR)/bin
	( if [ ! -f /$(THISDIR)/$(PKG_SOURCE) ]; then \
	tar zxfv /$(THISDIR)/$(PKG_SOURCE) -C $(THISDIR)/github.com/xtls ; \
	fi )
	
	( if [ ! -d $(THISDIR)/github.com/xtls/$(PKG_NAME)-$(PKG_VERSION) ]; then \
	mv $(THISDIR)/github.com/xtls/$(PKG_NAME)-$(PKG_VERSION) $(THISDIR)/github.com/xtls/xray-core ; \
	fi )	
	
	( if [  -d $(THISDIR)/github.com/xtls/xray-core/$(PKG_NAME)-$(PKG_VERSION) ]; then \
	mv $(THISDIR)/github.com/xtls/xray-core/$(PKG_NAME)-$(PKG_VERSION) $(THISDIR)/github.com/xtls/xray-core1 ; \
	rm -rf $(THISDIR)/github.com/xtls/xray-core ; \
	mv $(THISDIR)/github.com/xtls/xray-core1 $(THISDIR)/github.com/xtls/xray-core ; \
	fi )

build:
	( cd $(THISDIR)/github.com/xtls/xray-core/main ; \
	GOOS=linux GOARCH=mipsle go build -ldflags "-w -s" -o $(THISDIR)/bin/v2ray; \
	upx --lzma --best $(THISDIR)/bin/v2ray; \
	)

download_PKG:
	( if [ ! -f /$(THISDIR)/$(PKG_SOURCE) ]; then \
	curl --create-dirs -L $(PKG_URL) -o /$(THISDIR)/$(PKG_SOURCE) ; \
	fi )

clean:
	rm -rf $(THISDIR)/github.com
	rm -rf $(THISDIR)/bin

