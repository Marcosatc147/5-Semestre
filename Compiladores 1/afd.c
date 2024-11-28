/* Interpretador de automâtos desenvolvido em sala, juntamente com os */
/* alunos, de compiladores da UnB-FGA turma de 2024-1. Esta */
/* implementação ainda está incompleta e faltam pedaços significativos */
/* no que tange a interpretação dos estados. Também é necessária */
/* reflexão sobre modificações para comportar AFN */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct Q_st {
     char t;
     int *v;
} Q_st;

int compara(const void *a,const void *b) {
	fprintf(stderr,"XXXX\n");
	fprintf(stderr,"xxxx: %s\n",*(const char **)a);
	return strcmp( *(const char**)a,*(const char**)b);
}

int main(void)
{
  int Qs;
  scanf("%d",&Qs);
  Q_st *estados=calloc(Qs,sizeof(Q_st));

  int Es;
  scanf("%d",&Es);

  char **alfabeto;
  alfabeto=calloc(Es,sizeof(char*));
  for(int i=0;i<Es;i++){
		char buffer[10];
		scanf(" %s",buffer);
		alfabeto[i]=strdup(buffer);
  }

	qsort(alfabeto,Es,sizeof(char*),compara);
	printf("Meu alfabeto:");
	for(int i=0;i<Es;i++) printf("[%s] ",alfabeto[i]);
	printf("\n");
	for(int i=0;i<Qs;i++){
		estados[i].v=malloc(sizeof(int)*Es);
		for(int j=0;j<Es;j++)
			estados[i].v[j]=-1;
	}

	int ds;
	scanf("%d",&ds);
	char *simbolo=malloc(10);
	char s2;
	for(int i=0;i<ds;i++)
	{
		int e; int e2;
		scanf("%d %s %d",&e,simbolo,&e2);
		printf("D: %d %s %d\n",e,simbolo,e2);
		char **p=bsearch(&simbolo,alfabeto,Es,sizeof(char*),compara);
		unsigned long pv=(p-alfabeto)/8;
		estados[e].v[pv]=e2;
	}

	int qi; scanf("%d",&qi);
	int Fs;
	scanf("%d",&Fs);
	for(int i=0;i<Fs;i++) {
		int q;
		scanf("%d",&q);
		estados[q].t='f';
	}
}
