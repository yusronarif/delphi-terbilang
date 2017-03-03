unit Penomoran;
{
Component       : Penomoran
Version         : 1.0
Coder           : Much. Yusron Arif <yusron.arif4@gmail.com> 

      Copyright © Mata Air Teknologi - Januari 2017
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TPenomoran = class(TComponent)
  private
    NullValS : string;
    FAuthor  : string;
    FNumber  : integer;
    procedure SetNumber(value:integer);
    function GetTerbilang:string;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property Author    : string read FAuthor write NullValS;
    property Number    : integer read FNumber write SetNumber;
    property Terbilang : string read GetTerbilang write NullValS;
  end;

procedure Register;

implementation

const
  Satu      = 'satu ';
  Belas     = 'belas ';
  Angka     : array[1..9]of string = ('se','dua ','tiga ','empat ',
                                      'lima ','enam ','tujuh ','delapan ',
                                      'sembilan ');
  Satuan3   : array[1..2]of string = ('ratus ','puluh ');
  Satuan    : array[0..3]of string = ('','ribu ','juta ','milyar ');

function TPenomoran.GetTerbilang:string;
var
  tmp,tmp2  : string;
  TStr      : TStringList;
  i,j       : integer;
  
begin
  TStr:=TStringList.Create;
  tmp :=format('%0.0n',[strtofloat(inttostr(FNumber))])+ThousandSeparator;
  while tmp <> '' do
  begin
    TStr.Insert(0,copy(tmp,1,pos(ThousandSeparator,tmp)-1));
    delete(tmp,1,pos(ThousandSeparator,tmp));
  end;
  for i:=0 to TStr.Count-1 do
    TStr.Strings[i] :=format('%0.3d',[strtoint(TStr.Strings[i])]);
  for i:=TStr.Count-1 downto 0 do
  begin
    tmp  :=TStr.Strings[i];
    for j:=1 to 3 do
    begin
      if tmp[j] = '0' then continue;
      case j of
        1 : if tmp[j] <> '0' then
              tmp2 := tmp2 + Angka[strtoint(tmp[j])] + Satuan3[j];
        2 : case tmp[j] of
              '1'      : begin
                           case tmp[j+1] of
                             '0'      : tmp2 := tmp2 + Angka[strtoint(tmp[j])] + Satuan3[j];
                             '1'..'9' : tmp2 := tmp2 + Angka[strtoint(tmp[j+1])] + Belas;
                           end;
                           break;
                         end;
              '2'..'9' : tmp2 := tmp2 + Angka[strtoint(tmp[j])] + Satuan3[j];
            end;
        3 : case tmp[j] of
              '1' : case FNumber of
                      1         : tmp2 := tmp2 + Satu;
                      1000..1999: if i = 0 then
                                    tmp2 := tmp2 + Satu
                                  else
                                    tmp2 := tmp2 + Angka[strtoint(tmp[j])];
                    else
                      tmp2 :=tmp2 + Satu;
                    end;
            else
              tmp2 := tmp2 + Angka[strtoint(tmp[j])];
            end;
      end;
    end;
    if strtoint(tmp) <> 0 then
      tmp2 := tmp2 + Satuan[i];
  end;
  TStr.Free;
  result :=Trim(tmp2);
end;

procedure TPenomoran.SetNumber(value:integer);
begin
  if value <> FNumber then FNumber :=value;
end;

constructor TPenomoran.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FAuthor  :='Much. Yusron Arif <yusron.arif4 *at* gmail *dot* com>';
  FNumber  :=0;
end;

destructor TPenomoran.Destroy;
begin
  inherited;
end;

procedure Register;
begin
  RegisterComponents('MATek', [TPenomoran]);
end;

end.
