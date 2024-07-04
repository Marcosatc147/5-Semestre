program SumIntegers;
var
  N, X, i: integer;
  sum : longint;
begin
  sum := 0;  { Inicializa a soma como 0 }

  readln(N);  { Lê o valor de N }

  for i := 1 to N do
  begin
    readln(X);  { Lê cada número inteiro X }

    sum := sum + X;  { Adiciona X à soma }
  end;
  writeln(sum);
end.
