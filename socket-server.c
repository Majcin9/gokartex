#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <string.h>

#define MAX_PLAYERS 4

typedef struct player_t {
    int id;
    int x;
    int y;
    int theta;
    int taken;
} Player;

Player players[MAX_PLAYERS];

struct connection_input {
    int sockfd;
    int id;
};

void *
connection_handler(void *input) {
    struct connection_input* in = (struct connection_input*)input;	
	/* Get the socket descriptor */
	int sock = in->sockfd;
    int id = in->id;
	int read_size;
	char *message , client_message[128];
    players[id].id = id;
	
	do {
		read_size = recv(sock , client_message , 128 , 0);
		client_message[read_size] = '\0';
        char* x;
        char* y;
        char* theta;
        x = strtok(client_message, " ");
        if (x == NULL) {
            break;
        }
        y = strtok(NULL, " ");
        if (y == NULL) break;
        theta = strtok(NULL, " ");
        if (theta == NULL) break;
        int x_parsed = -1; 
        int y_parsed = -1;
        int theta_parsed = -1;

        x_parsed = atoi(x);
        y_parsed = atoi(y);
        theta_parsed = atoi(theta);
        // ignoring possibility of overflow or invalid read for now
        
        players[id].x = x_parsed;
        players[id].y = y_parsed;
        players[id].theta = theta_parsed;

        // printf("id: %d, x: %d, y: %d\n", players[id].id, players[id].x, players[id].y);
        if (x_parsed == -1  || y_parsed == -1 || theta_parsed == -1) {
            break;
        }
        for (int p = 0; p<MAX_PLAYERS && players[p].taken == 1; p++) {
            dprintf(sock, "%d %d %d %d\n", p, players[p].x, players[p].y, players[p].theta);
        }
        dprintf(sock, "\n");
		
		/* Clear the message buffer */
		memset(client_message, 0, 128);
	} while(read_size > 2); /* Wait for empty line */
	
	fprintf(stderr, "Client disconnected\n"); 
	
    players[id].taken = 0;
	close(sock);
	pthread_exit(NULL);
}

int
main(int argc, char *argv[]) {
	int listenfd = 0, connfd = 0;
	struct sockaddr_in serv_addr; 

    for (int i = 0; i<MAX_PLAYERS; i++) {
        players[i].taken = 0;
    }
	
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
        struct connection_input ci;
        int id = 0;

        while (id < MAX_PLAYERS && players[id].taken == 1) {id++;}
        ci.id = id;
        ci.sockfd = connfd;
        players[id].taken = 1;
		pthread_create(&thread_id, NULL, connection_handler , (void *) &ci);
	}
}


