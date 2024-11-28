// Implementação de um simulador de Autômato
// feito em sala com a turma de Compiladores no dia 26/03/2019
// UnB-Gama . prof. Bruno Ribas <bruno.ribas _AT_ unb.br>
// Esta implementação recebe como entrada a quintupla de um AFD, no seguinte
// formato:
/*********************
A primeira linha contendo um número inteiro contendo a quantidade de estados
A segunda linha iniciando por um número inteiro representando a quantidade de
  símbolo do alfabeto seguida de cada um dos símbolos
A tabela de transição representada por #estados * #símbolos linhas, cada uma
contendo:
 Id do estado de origem, símbolo, destino
O id do estado inicial
A quantidade de estados finais seguidos dos ids de todos estados finais
A última linha possui uma palavra que deve ser processada pelo autômato
*********************/
#include <stdio.h>

int main(void)
{
  int estados;
  scanf("%d",&estados);
  char alfabeto[1000];
  int simbolos;
  scanf("%d",&simbolos);
  for(int i=0;i<simbolos;i++)
    scanf(" %c",&alfabeto[i]);

  int tabtran[estados]['z'+1];
  for(int i=0;i<estados;i++)
  {
    int pos,dest; char trig;
    for(int j=0;j<simbolos;j++)
    {
      scanf("%d %c %d",&pos,&trig,&dest);
      tabtran[i][trig]=dest;
    }
  }
  int inicial;
  scanf("%d",&inicial);
  int finaisct;
  scanf("%d",&finaisct);
  int finais[estados];

  for(int i=0;i<estados;i++)
    finais[i]=-1;

  for(int i=0;i<finaisct;i++)
  {
    int final;
    scanf("%d",&final);
    finais[final]=1;
  }

  int atual=inicial;
  char buf[1000];
  scanf(" %s",buf);
  int bpos=0;
  while(atual!=-1 && buf[bpos]!='\0')
  {
    atual=tabtran[atual][buf[bpos]];
    bpos++;
  }
  if(atual!=-1 && finais[atual]==1)
    printf("Aceito\n");
  else
    printf("Rejeito\n");
  return 0;
}
