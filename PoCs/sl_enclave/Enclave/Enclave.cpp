#include "../eType.h"
#include "Enclave_t.h"
#include <stdio.h>
#include <string.h>

void send_it_vfn(struct eData* data, char *msg, int len){
  data->msg = (char*) malloc(len);
  memcpy(data->msg, msg, len);
  data->len = len;
}

void send_it_cfn(struct eData* data, char *msg, int len){
  data->msg = (char*) malloc(strlen(msg));
  memcpy(data->msg, msg, strlen(msg));
  data->len = strlen(msg);
}

void ecall_start() {
  char local_msg[16] = {0};
  int local_msg_len;
  
  struct eData *vdata = (struct eData*) malloc(sizeof(struct eData));
  struct eData *cdata = (struct eData*) malloc(sizeof(struct eData));

  ocall_ask(local_msg, sizeof(local_msg), &local_msg_len);

  send_it_vfn(cdata, local_msg, local_msg_len);

  send_it_cfn(cdata, local_msg, local_msg_len);
}