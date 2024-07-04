program TemperatureConverter;
var
  inputUnit, outputUnit: Char;
  inputTemp, outputTemp: Real;

function CelsiusToKelvin(c: Real): Real;
begin
  CelsiusToKelvin := c + 273.15;
end;

function CelsiusToFahrenheit(c: Real): Real;
begin
  CelsiusToFahrenheit := (c * 9/5) + 32;
end;

function KelvinToCelsius(k: Real): Real;
begin
  KelvinToCelsius := k - 273.15;
end;

function KelvinToFahrenheit(k: Real): Real;
begin
  KelvinToFahrenheit := (k - 273.15) * 9/5 + 32;
end;

function FahrenheitToCelsius(f: Real): Real;
begin
  FahrenheitToCelsius := (f - 32) * 5/9;
end;

function FahrenheitToKelvin(f: Real): Real;
begin
  FahrenheitToKelvin := (f - 32) * 5/9 + 273.15;
end;

begin
  readln(inputUnit);
  readln(outputUnit);
  readln(inputTemp);

  if (inputUnit = 'C') and (outputUnit = 'K') then
    outputTemp := CelsiusToKelvin(inputTemp)
  else if (inputUnit = 'C') and (outputUnit = 'F') then
    outputTemp := CelsiusToFahrenheit(inputTemp)
  else if (inputUnit = 'K') and (outputUnit = 'C') then
    outputTemp := KelvinToCelsius(inputTemp)
  else if (inputUnit = 'K') and (outputUnit = 'F') then
    outputTemp := KelvinToFahrenheit(inputTemp)
  else if (inputUnit = 'F') and (outputUnit = 'C') then
    outputTemp := FahrenheitToCelsius(inputTemp)
  else if (inputUnit = 'F') and (outputUnit = 'K') then
    outputTemp := FahrenheitToKelvin(inputTemp)
  else
  begin
    writeln('Invalid unit combination.');
    exit;
  end;

  writeln(outputTemp:0:2);
end.
