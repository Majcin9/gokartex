#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <string.h>

typedef struct player_t {
    int id;
    int x;
    int y;
} Player;

Player p;

void *
connection_handler(void *socket_desc) {
	
	/* Get the socket descriptor */
	int sock = * (int *)socket_desc;
	int read_size;
	char *message , client_message[128];
	
	do {
		read_size = recv(sock , client_message , 128 , 0);
		client_message[read_size] = '\0';
        char* x;
        char* y;
        x = strtok(client_message, " ");
        if (x != NULL) {
            y = strtok(NULL, " ");
        }
        int x_parsed = -1; 
        int y_parsed = -1;
        if (x != NULL && y != NULL) {
            x_parsed = atoi(x);
            y_parsed = atoi(y);
        }    
        // ignoring possibility of overflow or invalid read for now
        
        p.x = x_parsed;
        p.y = y_parsed;

        printf("id: %d, x: %d, y: %d\n", p.id, p.x, p.y);
		
		/* Clear the message buffer */
		memset(client_message, 0, 128);
	} while(read_size > 2); /* Wait for empty line */
	
	fprintf(stderr, "Client disconnected\n"); 
	
	close(sock);
	pthread_exit(NULL);
}

int
main(int argc, char *argv[]) {
	int listenfd = 0, connfd = 0;
	struct sockaddr_in serv_addr; 
	
	pthread_t thread_id;

	listenfd = socket(AF_INET, SOCK_STREAM, 0);
	memset(&serv_addr, '0', sizeof(serv_addr));

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_addr.sin_port = htons(5000); 

	bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)); 

	listen(listenfd, 10); 

	for (;;) {
		connfd = accept(listenfd, (struct sockaddr*)NULL, NULL);
		fprintf(stderr, "Connection accepted\n"); 
		pthread_create(&thread_id, NULL, connection_handler , (void *) &connfd);
	}
}


