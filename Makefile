all: *.lua
	love .

server: socket-server.c
	gcc socket-server.c -lpthread -o server
