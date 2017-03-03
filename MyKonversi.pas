unit MyKonversi;
{
Component       : MyKonversi
Version         : 1.0
Coder           : Much. Yusron Arif <yusron.arif4@gmail.com> 

      Copyright © Mata Air Teknologi - Januari 2017
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TBahasa = (Indonesia, Inggris);

  TMyKonversi = class(TComponent)
  private       
    NullValS : string;
    FAuthor  : string;
    FBahasa  : TBahasa;
    FSatuan  : string;
    FValue   : double;
    procedure SetBahasa(value:TBahasa);
    procedure SetSatuan(value:string);
    procedure SetValue(value:double);
    function GetNumStr:string;
    function Terbilang(value:string):string;
    function TerbilangKoma(value: string): string;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;                  
    function NumToStr(vLang:TBahasa; vNum:double; vCurr:string):string;
  published
    property Author         : string read FAuthor write NullValS;
    property Bahasa         : TBahasa read FBahasa write setBahasa;
    property Satuan         : string read FSatuan write setSatuan;
    property Nilai          : double read FValue write SetValue;
    property HasilKonversi  : string read GetNumStr write NullValS;
  end;

procedure Register;

implementation

function TMyKonversi.Terbilang(value: string):string;
const
  Angka : array [1..20] of string = ('', 'Satu', 'Dua', 'Tiga', 'Empat',
                                    'Lima', 'Enam', 'Tujuh', 'Delapan',
                                    'Sembilan', 'Sepuluh', 'Sebelas',
                                    'Duabelas', 'Tigabelas', 'Empatbelas',
                                    'Limabelas', 'Enambelas', 'Tujuhbelas',
                                    'Delapanbelas', 'Sembilanbelas');
  sPattern: string = '000000000000000';
var
  S,kata : string;
  Satu, Dua, Tiga, Belas, Gabung: string;
  Sen, Sen1, Sen2: string;
  Hitung : integer;
  one, two, three: integer;
begin
  One := 4;
  Two := 5;
  Three := 6;
  Hitung := 1;
  Kata := '';
  S := copy(sPattern, 1, length(sPattern) - length(trim(value))) + value;
  Sen1 := Copy(S, 14, 1);
  Sen2 := Copy(S, 15, 1);
  Sen := Sen1 + Sen2;

  while Hitung < 5 do
  begin
    Satu := Copy(S, One, 1);
    Dua := Copy(S, Two, 1);
    Tiga := Copy(S, Three, 1);
    Gabung := Satu + Dua + Tiga;

    if StrToInt(Satu) = 1 then
    begin
      Kata := Kata + 'Seratus '
    end else
    begin
      if StrToInt(Satu) > 1 Then
        Kata := Kata + Angka[StrToInt(satu)+1] + ' Ratus ';
    end;

    if StrToInt(Dua) = 1 then
    begin
      Belas := Dua + Tiga;
      Kata := Kata + Angka[StrToInt(Belas)+1];
    end
    else if StrToInt(Dua) > 1 Then
    begin
      Kata := Kata + Angka[StrToInt(Dua)+1] + ' Puluh ' + Angka[StrToInt(Tiga)+1];
    end else
    begin
      if (StrToInt(Dua) = 0) and (StrToInt(Tiga) > 0) Then
      begin
        if ((Hitung = 3) and (Gabung = '001')) or ((Hitung = 3) and (Gabung = ' 1')) then
        begin
          Kata := Kata + 'Seribu ';
        end else
        begin
          Kata := Kata + Angka[StrToInt(Tiga)+1];
        end;
      end;
    end;

    if (hitung = 1) and (StrToInt(Gabung) > 0) then
      Kata := Kata + ' Milyar '
    else if (Hitung = 2) and (StrToInt(Gabung) > 0) then
      Kata := Kata + ' Juta '
    else if (Hitung = 3) and (StrToInt(Gabung) > 0) then
    begin
      if (Gabung = '001') or (Gabung = ' 1') then
        Kata := Kata + ''
      else
        Kata := Kata + ' Ribu ';
    end;

    Hitung := Hitung + 1;
    One := One + 3;
    Two := Two + 3;
    Three := Three + 3;
  end;

  if length(Kata) > 1 then Kata := Kata;

  Result := Kata;
end;

function TMyKonversi.TerbilangKoma(value: string): string;
var
  a,b,c,Poskoma,PosTitik : integer;
  temp,angka,dpnKoma,BlkKoma : string;
  AdaKoma: boolean;
begin
  PosKoma:= pos(',', value);
  PosTitik:= pos('.', value);

  if (Poskoma<>0) or (posTitik<> 0) then
  begin
    adaKoma:= true;

    if PosKoma= 0 then
      posKoma:= PosTitik;
  end else
  begin
    adakoma:= False;
    DpnKoma:= value;
  end;

  // Jika ada Koma
  if adakoma then
  begin
    dpnkoma:= copy(value,1,posKoma-1);
    blkKoma:= Copy(value,posKoma+1,length(value)-posKoma);

    if trim(DpnKoma)='0' then
      temp:= 'Nol'+ ' Koma ' + terbilang(blkKoma)
    else
      temp:= Terbilang(dpnKoma)+ ' Koma ' + Terbilang(blkKoma);
  // Jika Tidak ada Koma
  end else
  begin
    temp:=Terbilang(dpnKoma);
  end;

  Result:= temp;
end;

function TMyKonversi.NumToStr(vLang:TBahasa; vNum:double; vCurr:string):string;
begin
  FValue := vNum;
  result := TerbilangKoma(FloatToStr(FValue)) + ' ' + vCurr;
end;

function TMyKonversi.GetNumStr:string;
begin
  result := NumToStr(FBahasa, FValue, FSatuan);
end;

procedure TMyKonversi.SetBahasa(value:TBahasa);
begin
  if value <> FBahasa then FBahasa :=value;
end;

procedure TMyKonversi.SetSatuan(value:string);
begin
  if value <> FSatuan then FSatuan :=value;
end;

procedure TMyKonversi.SetValue(value:double);
begin
  if value <> FValue then FValue :=value;
end;

constructor TMyKonversi.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FAuthor  :='Much. Yusron Arif <yusron.arif4 *at* gmail *dot* com>';
  FValue  :=0;
  FSatuan  :='Rupiah';
  FBahasa  :=Indonesia;
end;

destructor TMyKonversi.Destroy;
begin
  inherited;
end;

procedure Register;
begin
  RegisterComponents('MATek', [TMyKonversi]);
end;

end.
