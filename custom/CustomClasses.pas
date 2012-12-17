(*
  AbstractClasses, Custom Classes and Routines
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit CustomClasses;

{$I abs.inc}

interface

uses
  SysUtils;

type
  ECustomException = class(Exception)
  end;

{ unit uExtenso; }
{ Autor.....: Eugênio Reis }

function Extenso( Numero : extended ) : string;

implementation

{ unit uExtenso; }

{ Autor.....: Eugênio Reis
  Proposito.: Rotina desenvolvida para dar apoio a treinamentos de Delphi.
              Recebe um valor numérico e devolve uma string com seu valor por
              extenso, em reais. O limite se encerra na casa dos trilhões.
              É uma rotina escrita com uma intenção muito "Pascalista" de
              explorar bem os recursos da linguagem (não das bibliotecas, mas
              da linguagem em si).
  Data......: 12/09/95, revisada em 27/09/02.
  Obs.......: Existem detalhes sutis da língua portuguesa que aumentam muito
              o trabalho de implementação deste tipo de rotina. Em caso de
              sugestões para o melhoramento da rotina ou bugs encontrados,
              favor escrever para o endereço ebrire@yahoo.com.
              Peço a gentileza de sempre distribuir o código exatamente como no
              original, com todos os comentários (inclusive este, obviamente).
}

{
  Como esta rotina visa a ser compatível também com Delphi 1 e Turbo Pascal,
  optei por manipular strings usando apenas o básico do básico (sem recorrer à
  SysUtils) e por usar tipos númericos simples. Lembre-se que o tipo extended
  pode apresentar ligeiras imprecisões em números na casa das centenas de
  trilhão.
  A função ReplaceSubstring poderia ser facilmente substituída com recursos do
  Delphi, mas, como já disse, optei por usar uma implementação mais pascalista
  mesmo, e portanto menos sujeita a problemas de versão do Pascal (Turbo Pascal,
  Think Pascal, Borland Pascal, Delphi 1-7, Kylix, etc).
}
function ReplaceSubstring( StringAntiga, StringNova, s : string ) : string;
  var p : word;
begin
   repeat
     p := Pos( StringAntiga, s );
     if p > 0 then begin
        Delete( s, p, Length( StringAntiga ) );
        Insert( StringNova, s, p );
     end;
   until p = 0;
   ReplaceSubstring := s;
end;


{ Esta é a função que gera os blocos de extenso que depois serão montados }
function Extenso3em3( Numero : Word ) : string;
  const Valores : array[1..36] of word = ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                       13, 14, 15, 16, 17, 18, 19, 20, 30, 40, 50, 60, 70, 80, 90,
                       100, 200, 300, 400, 500, 600, 700, 800, 900 );
        Nomes : array[0..36] of string[12] = ( '', 'UM', 'DOIS', 'TRÊS', 'QUATRO',
                       'CINCO', 'SEIS', 'SETE', 'OITO', 'NOVE', 'DEZ', 'ONZE',
                       'DOZE', 'TREZE', 'QUATORZE', 'QUINZE', 'DEZESSEIS',
                       'DEZESSETE', 'DEZOITO', 'DEZENOVE', 'VINTE', 'TRINTA',
                       'QUARENTA', 'CINQÜENTA', 'SESSENTA', 'SETENTA', 'OITENTA',
                       'NOVENTA', 'CENTO', 'DUZENTOS', 'TREZENTOS', 'QUATROCENTOS',
                       'QUINHENTOS', 'SEISCENTOS', 'SETECENTOS', 'OITOCENTOS',
                       'NOVECENTOS' );
  var i         : byte;
      Resposta  : string;
      Inteiro   : word;
      Resto     : word;
begin
  Inteiro   := Numero;
  Resposta  := '';

  for i := 36 downto 1 do begin
      Resto := ( Inteiro div valores[i] ) * valores[i];
      if ( Resto = valores[i] ) and ( Inteiro >= Resto ) then begin
         Resposta := Resposta + Nomes[i] + ' E ';
         Inteiro  := Inteiro - Valores[i];
      end;
  end;

  { Corta o 'E' excedente do final da string }
  Extenso3em3 := Copy( Resposta, 1, Length( Resposta ) - 3 );
end;


{
  A função extenso divide os números em grupos de três e chama a função
  extenso3em3 para o obter extenso de cada parte e armazená-los no vetor
  Resposta.
}
function Extenso( Numero : extended ) : string;
  const NoSingular : array[1..6] of string = ( 'TRILHÃO', 'BILHÃO', 'MILHÃO', 'MIL',
                                               'REAL', 'CENTAVO' );
        NoPlural   : array[1..6] of string = ( 'TRILHÕES', 'BILHÕES', 'MILHÕES', 'MIL',
                                               'REAIS', 'CENTAVOS' );
        {
          Estas constantes facilitam o entendimento do código.
          Como os valores de singular e plural são armazenados em um vetor,
          cada posicao indica a grandeza do número armazenado (leia-se sempre
          da esquerda para a direita).
        }
        CasaDosTrilhoes = 1;
        CasaDosBilhoes  = CasaDosTrilhoes + 1;
        CasaDosMilhoes  = CasaDosBilhoes  + 1;
        CasaDosMilhares = CasaDosMilhoes  + 1;
        CasaDasCentenas = CasaDosMilhares + 1;
        CasaDosCentavos = CasaDasCentenas + 1;

  var TrioAtual,
      TrioPosterior : byte;
      v             : integer; { usada apenas com o Val }
      Resposta      : array[CasaDosTrilhoes..CasaDosCentavos] of string;
      RespostaN     : array[CasaDosTrilhoes..CasaDosCentavos] of word;
      Plural        : array[CasaDosTrilhoes..CasaDosCentavos] of boolean;
      Inteiro       : extended;
      NumStr        : string;
      TriosUsados   : set of CasaDosTrilhoes..CasaDosCentavos;
      NumTriosInt   : byte;

  { Para os não pascalistas de tradição, observe o uso de uma função
    encapsulada na outra. }
  function ProximoTrio( i : byte ) : byte;
  begin
     repeat
       Inc( i );
     until ( i in TriosUsados ) or ( i >= CasaDosCentavos );
     ProximoTrio := i;
  end;

begin
  Inteiro  := Round( Numero * 100 );

  { Inicializa os vetores }
  for TrioAtual := CasaDosTrilhoes to CasaDosCentavos do begin
       Resposta[TrioAtual] := '';
       Plural[TrioAtual]   := False;
  end;

  {
    O número é quebrado em partes distintas, agrupadas de três em três casas:
    centenas, milhares, milhões, bilhões e trilhões. A última parte (a sexta)
    contém apenas os centavos, com duas casas
  }
  Str( Inteiro : 17 : 0, NumStr );
  TrioAtual    := 1;
  Inteiro      := Int( Inteiro / 100 ); { remove os centavos }

  { Preenche os espaços vazios com zeros para evitar erros de conversão }
  while NumStr[TrioAtual] = ' ' do begin
     NumStr[TrioAtual] := '0';
     Inc( TrioAtual );
  end;

  { Inicializa o conjunto como vazio }
  TriosUsados := [];
  NumTriosInt := 0; { Números de trios da parte inteira (sem os centavos) } 

  { Este loop gera os extensos de cada parte do número }
  for TrioAtual := CasaDosTrilhoes to CasaDosCentavos do begin
      Val( Copy( NumStr, 3 * TrioAtual - 2, 3 ), RespostaN[TrioAtual], v );
      if RespostaN[TrioAtual] <> 0 then begin
         Resposta[TrioAtual] := Resposta[TrioAtual] +
                                Extenso3em3( RespostaN[TrioAtual] );
         TriosUsados := TriosUsados + [ TrioAtual ];
         Inc( NumTriosInt );
         if RespostaN[TrioAtual] > 1 then begin
            Plural[TrioAtual] := True;
         end;
      end;
  end;

  if CasaDosCentavos in TriosUsados then
     Dec( NumTriosInt );

  { Gerar a resposta propriamente dita }
  NumStr := '';

  {
    Este trecho obriga que o nome da moeda seja sempre impresso no caso de
    haver uma parte inteira, qualquer que seja o valor.
  }
  if (Resposta[CasaDasCentenas]='') and ( Inteiro > 0 ) then begin
      Resposta[CasaDasCentenas] := ' ';
      Plural[CasaDasCentenas]   := True;
      TriosUsados := TriosUsados + [ CasaDasCentenas ];
  end;


  { Basta ser maior que um para que a palavra "real" seja escrita no plural }
  if Inteiro > 1 then
     Plural[CasaDasCentenas] := True;

  { Localiza o primeiro elemento }
  TrioAtual     := 0;
  TrioPosterior := ProximoTrio( TrioAtual );

  { Localiza o segundo elemento }
  TrioAtual     := TrioPosterior;
  TrioPosterior := ProximoTrio( TrioAtual );

  { Este loop vai percorrer apenas os trios preenchidos e saltar os vazios. }
  while TrioAtual <= CasaDosCentavos do begin
     { se for apenas cem, não escrever 'cento' }
     if Resposta[TrioAtual] = 'CENTO' then
        Resposta[TrioAtual] := 'CEM';

     { Verifica se a resposta deve ser no plural ou no singular }
     if Resposta[TrioAtual] <> '' then begin
        NumStr := NumStr + Resposta[TrioAtual] + ' ';
        if plural[TrioAtual] then
           NumStr := NumStr + NoPlural[TrioAtual] + ' '
        else
           NumStr := NumStr + NoSingular[TrioAtual] + ' ';

        { Verifica a necessidade da particula 'e' para os números }
        if ( TrioAtual < CasaDosCentavos ) and ( Resposta[TrioPosterior] <> '' )
           and ( Resposta[TrioPosterior] <> ' ' ) then begin
           {
             Este trecho analisa diversos fatores e decide entre usar uma
             vírgula ou um "E", em função de uma peculiaridade da língua. Veja
             os exemplos para compreender:
             - DOIS MIL, QUINHENTOS E CINQÜENTA REAIS
             - DOIS MIL E QUINHENTOS REAIS
             - DOIS MIL E UM REAIS
             - TRÊS MIL E NOVENTA E CINCO REAIS
             - QUATRO MIL, CENTO E UM REAIS
             - UM MILHÃO E DUZENTOS MIL REAIS
             - UM MILHÃO, DUZENTOS MIL E UM REAIS
             - UM MILHÃO, OITOCENTOS E NOVENTA REAIS
             Obs.: Fiz o máximo esforço pra que o extenso soasse o mais natural
                   possível em relação à lingua falada, mas se aparecer alguma
                   situação em que algo soe esquisito, peço a gentileza de me
                   avisar.
           }
           if ( TrioAtual < CasaDosCentavos ) and
              ( ( NumTriosInt = 2 ) or ( TrioAtual = CasaDosMilhares ) ) and
              ( ( RespostaN[TrioPosterior] <= 100 ) or
                ( RespostaN[TrioPosterior] mod 100 = 0 ) ) then
              NumStr := NumStr + 'E '
           else
              NumStr := NumStr + ', ';
        end;
     end;

     { se for apenas trilhões, bilhões ou milhões, acrescenta o 'de' }
     if ( NumTriosInt = 1 ) and ( Inteiro > 0 ) and ( TrioAtual <= CasaDosMilhoes ) then begin
        NumStr := NumStr + ' DE ';
     end;

     { se tiver centavos, acrescenta a partícula 'e', mas somente se houver
       qualquer valor na parte inteira }
     if ( TrioAtual = CasaDasCentenas ) and ( Resposta[CasaDosCentavos] <> '' )
        and ( inteiro > 0 ) then begin
        NumStr := Copy( NumStr, 1, Length( NumStr ) - 2 ) + ' E ';
     end;

     TrioAtual     := ProximoTrio( TrioAtual );
     TrioPosterior := ProximoTrio( TrioAtual );
  end;

  { Eliminar algumas situações em que o extenso gera excessos de espaços
    da resposta. Mero perfeccionismo... }
  NumStr := ReplaceSubstring( '  ', ' ', NumStr );
  NumStr := ReplaceSubstring( ' ,', ',', NumStr );

  Extenso := NumStr;
end;

end.
