#include <sched.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <string.h>
#include <stdbit.h>

#define MAX_PLAYERS 4
#define MAX_BOXES 4
#define TIME_INVISIBLE 3
#define MAX_BULLETS 3
#define MAX_LENGTH 1024

typedef struct position {
    int x;
    int y;
    int theta;
} pos_t;

typedef struct player_t {
    int id;
    pos_t playerPos;
    pos_t bulletPos[MAX_BULLETS];
    int score;
    int taken;
} Player;

typedef struct box_t {
    int id;
    int x;
    int y;
    int theta;
    int visible;
    long long timeinv;
} Box;

Player players[MAX_PLAYERS];
Box boxes[MAX_BOXES];


struct connection_input {
    int sockfd;
    int id;
};

int parse_pos(char* posstr, pos_t* p) {
    char* x;
    char* y;
    char* theta;
    char* temp;
    printf("parsing: %s\n", posstr);
    temp = strtok(posstr, " ");
    if (temp == NULL) {
        printf("bad temp");
        return -1;
    }

    x = strtok(NULL, " ");
    if (x == NULL) {
        printf("bad x");
        return -1;
    }
    y = strtok(NULL, " ");
    if (y == NULL) {
        printf("bad y");
        return -1;
    }
    theta = strtok(NULL, " ");
    if (theta == NULL) { 
        printf("bad theta");
        return -1;
    }
    int x_parsed = -1; 
    int y_parsed = -1;
    int theta_parsed = -1;

    x_parsed = atoi(x);
    y_parsed = atoi(y);
    theta_parsed = atoi(theta);
    // ignoring possibility of overflow or invalid read for now
    printf("x: %d y: %d theta: %d\n", x_parsed, y_parsed, theta_parsed);

    p->x = x_parsed;
    p->y = y_parsed;
    p->theta = theta_parsed;
    
    return (x_parsed == -1 || y_parsed == -1 || theta_parsed == -1) ? -1 : 0;
}

int parse_box(char* posstr, Box* b) {
    char* x;
    char* y;
    char* theta;
    char* visible;
    char* timeinv;
    char* temp;
    temp = strtok(posstr, " ");
    if (temp == NULL) return -1;

    x = strtok(NULL, " ");
    if (x == NULL) return -1;
    y = strtok(NULL, " ");
    if (y == NULL) return -1;
    theta = strtok(NULL, " ");
    if (theta == NULL) return -1;
    visible = strtok(NULL, " ");
    if (visible == NULL) return -1;
    timeinv = strtok(NULL, " ");
    if (timeinv == NULL) return -1;
    int x_parsed = -1; 
    int y_parsed = -1;
    int theta_parsed = -1;
    int vis_parsed = -1;
    int time_parsed = -1;

    x_parsed = atoi(x);
    y_parsed = atoi(y);
    theta_parsed = atoi(theta);
    vis_parsed = atoi(visible);
    time_parsed = atoi(timeinv);
    // ignoring possibility of overflow or invalid read for now

    b->x = x_parsed;
    b->y = y_parsed;
    b->theta = theta_parsed;
    b->visible = vis_parsed;
    b->timeinv = time_parsed;
    if (b->timeinv >= TIME_INVISIBLE*10000){
	b->timeinv = 0;
	b->visible = 1;
    }
    
    return (x_parsed == -1 || y_parsed == -1 || theta_parsed == -1 || vis_parsed == -1 || time_parsed == -1) ? -1 : 0;
}
void *
connection_handler(void *input) {
    struct connection_input* in = (struct connection_input*)input;	
	/* Get the socket descriptor */
	int sock = in->sockfd;
    int id = in->id;
	int read_size;
	char *message , client_message[MAX_LENGTH];
    memset(&players[id], 0, sizeof(Player));
    players[id].id = id;
    players[id].taken = 1;
    dprintf(sock, "%d\n", id);
    int j = 0;
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC_RAW, &start);

	do {
        read_size = recv(sock , client_message , MAX_LENGTH , 0);
        if (read_size == 0) break;
        client_message[read_size] = '\0';
        printf("read size: %d, client_message %s\n", read_size, client_message);
        char* playerStr = strtok(client_message, ",");
        char* bulletStr[MAX_BULLETS];
        // printf("playerstr %s\n", playerStr);
        for (int i = 0; i < MAX_BULLETS; i++) {
            bulletStr[i] = strtok(NULL, ",");
        }
        char* boxStr[MAX_BOXES];
        for (int i = 0;i<MAX_BOXES;i++) {
            boxStr[i] = strtok(NULL,",");
        }
        char* hitby = strtok(NULL, ",");
        int hitbyID = atoi(hitby);
        if (hitbyID > -1) {
            players[hitbyID].score++;
        }
        if (parse_pos(playerStr, &players[id].playerPos) == -1) {
            printf("bad player data");
            //break;
        }
        for (int i = 0; i<MAX_BULLETS; i++) {
            if (parse_pos(bulletStr[i], &players[id].bulletPos[i]) == -1) {
                //break;
            }
        }

        clock_gettime(CLOCK_MONOTONIC_RAW, &end);
        for (int i = 0;i<MAX_BOXES;i++){
            if (parse_box(boxStr[i], &boxes[i]) == -1) {
                printf("bad box data\n");
                /*j++;
                  if (j>=MAX_BOXES){
                  j=0;
                  }*/
                break;
            }
            if (boxes[i].visible == 0){
                boxes[i].timeinv += (uint64_t)(((end.tv_sec - start.tv_sec) * 1000000 + (end.tv_nsec - start.tv_nsec) / 1000)/100);
                //printf("boxes[%d]: %ld\n",i,boxes[i].timeinv);
            }
        }
        clock_gettime(CLOCK_MONOTONIC_RAW, &start);
        for (int p = 0; p<MAX_PLAYERS && players[p].taken == 1; p++) {
            dprintf(sock, "%d %d %d %d %d\n", p, players[p].playerPos.x, players[p].playerPos.y, players[p].playerPos.theta, players[p].score);
            printf("%d %d %d %d\n", p, players[p].playerPos.x, players[p].playerPos.y, players[p].playerPos.theta);
            for (int i = 0; i<MAX_BULLETS; i++) {
                dprintf(sock, "%d %d %d %d\n", p, players[p].bulletPos[i].x, players[p].bulletPos[i].y, players[p].bulletPos[i].theta);
                printf("bullet: %d %d %d %d\n", p, players[p].bulletPos[i].x, players[p].bulletPos[i].y, players[p].bulletPos[i].theta);
            }
        }
        dprintf(sock,"\n");
        for (int b = 0; b<MAX_BOXES; b++) {
            dprintf(sock, "%d %d %d %d %d\n", b, boxes[b].x, boxes[b].y, boxes[b].visible,boxes[b].timeinv);
        }
        // dprintf(sock, "\n");

        /* Clear the message buffer */
        memset(client_message, 0, MAX_LENGTH);
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


