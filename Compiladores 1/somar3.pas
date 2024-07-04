program sum;
var
    soma, num1, num2, num3, num4 : integer;
begin

    readln(num1,num2, num3,num4);
    soma := num1 + num2 + num3;

    if soma = num4 then
        writeln('Acertou')
    else 
        writeln('Errou');
end.