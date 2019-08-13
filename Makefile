.PHONY: all clean build deps install uninstall reinstall

PREFIX = /usr/local
GOBUILD = go build
GOGET = go get -d -v
CONFIG_DIR = /etc/plexbot
CONFIG = $(CONFIG_DIR)/plexbot.conf

all: deps clean build

clean:
	rm -rf bin

build: clean
	$(GOBUILD) -o bin/goplex -ldflags "-X main.configDir=$(CONFIG)" main.go
	install -m0755 src/deluge bin/deluge
	install -m0755 src/nzbget bin/nzbget
	install -m0755 src/filebot bin/filebot

install: bin
	install -d -m0755 $(PREFIX)/plexbot/bin
	install -m0755 bin/* $(PREFIX)/plexbot/bin
	if [ ! -f $(CONFIG) ]; then \
    	install -m0755 src/plexbot.conf $(CONFIG); \
	fi

uninstall:
	rm -rf $(CONFIG_DIR)
	rm -rf $(PREFIX)/plexbot

reinstall:
	rm -rf $(PREFIX)/plexbot
	install -d -m0755 $(PREFIX)/plexbot/bin
	install -m0755 bin/* $(PREFIX)/plexbot/bin

deps:
	$(GOGET) ./...
