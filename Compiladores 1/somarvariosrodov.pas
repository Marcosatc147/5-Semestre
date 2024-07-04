program SomaN_Verifica;
  var
    n: integer;      { Quantidade de números }
    i: integer;      { Contador do loop }
    numero: integer; { Valor de cada número }
    soma: integer;   { Soma dos números }
    respostaUsuario: integer; { Resposta do usuário para a soma }

  begin
    { Recebe a quantidade de números }
    read(n);

    { Inicializa a variável soma }
    soma := 0;

    { Lê e soma os números }
    for i := 1 to n do 
    begin
      read(numero);
      soma := soma + numero;
    end;

    { Recebe a resposta do usuário }
    Readln(respostaUsuario);

    { Verifica se a resposta do usuário está correta }
    if (respostaUsuario = soma) then
      Writeln('Acertou')
    else
      Writeln('Errou');
  end.