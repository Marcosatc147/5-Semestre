program teste (input, output);
var m, n, s : integer;
begin
   read(m);
   read(n);
   s:=0;
   while m<=n do
   begin
      s:=s+m*m;
      writeln (m);
      writeln (s);
      m:=m+1;
      writeln (m)
   end

end.
