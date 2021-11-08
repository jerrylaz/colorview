unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  LazSerial, unicomm;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnOpen: TButton;
    btnStart: TButton;
    btnStop: TButton;
    btnCalWhite: TButton;
    btnCalBlack: TButton;
    cbCom: TComboBox;
    Label1: TLabel;
    com: TLazSerial;
    lblData: TLabel;
    pnlClear: TPanel;
    pnlRed: TPanel;
    pnlGreen: TPanel;
    pnlBlue: TPanel;
    shp: TShape;
    procedure btnCalBlackClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnCalWhiteClick(Sender: TObject);
    procedure cbComChange(Sender: TObject);
    procedure cbComDropDown(Sender: TObject);
    procedure comReceive(Sender: TObject);
    procedure comRxData(Sender: TObject);
  private
    rxbuf: String;
    r,g,b: byte;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.cbComDropDown(Sender: TObject);
begin
  cbCom.Items.CommaText := EnumerateComport(False);
end;

procedure TForm1.comReceive(Sender: TObject);
var tmp: String;
    aColor: TColor;
begin
// rawclear,rawred,rawgreen,rawblue,clear,red,green,blue
  //rxBuf := com.ReadString;
  //com.ReadData(rxBuf);
  if Pos(#$D, rxBuf) > 0 then begin
    tmp := Copy(rxBuf, 1, Pos(#$D, rxBuf)-1);
    if Length(tmp) < 47 then begin
      rxBuf := '';
      Exit;
    end;
    tmp := Trim(tmp);
    //tmp := Trim(Copy(rxBuf, 1, Length(rxBuf)));
    lblData.Caption := tmp;
    //rxBuf := '';
    //Delete(rxBuf, 1, Pos(#$D, rxBuf)+1);
    Delete(tmp, 1, Pos(',', tmp)); //delete raw clear
    Delete(tmp, 1, Pos(',', tmp)); //delete raw red
    Delete(tmp, 1, Pos(',', tmp)); //delete raw green
    Delete(tmp, 1, Pos(',', tmp)); //delete raw blue
    pnlRed.Caption := Copy(tmp, 1, Pos(',', tmp)-1); //get red
    Delete(tmp, 1, Pos(',', tmp));
    pnlGreen.Caption := Copy(tmp, 1, Pos(',', tmp)-1); //get green
    Delete(tmp, 1, Pos(',', tmp));
    pnlBlue.Caption := Copy(tmp, 1, Pos(',', tmp)-1); //get blue
    Delete(tmp, 1, Pos(',', tmp));
    if Pos(',', tmp) > 0 then
      pnlClear.Caption := Copy(tmp, 1, Pos(',', tmp)-1) //get clear
    else
      pnlClear.Caption := tmp;
    r := StrToInt(pnlRed.Caption);
    g := StrToInt(pnlGreen.Caption);
    b := StrToInt(pnlBlue.Caption);
    aColor := RGBToColor(r, g, b);
    shp.Brush.Color := aColor;
  end;
end;

procedure TForm1.comRxData(Sender: TObject);
var tmp: String;
    aColor: TColor;
begin
// rawclear,rawred,rawgreen,rawblue,clear,red,green,blue
  //rxBuf := com.ReadString;
  rxBuf := rxBuf + com.ReadData;
  if Pos(#$D, rxBuf) > 0 then begin
    tmp := Copy(rxBuf, 1, Pos(#$D, rxBuf)-1);
    if Length(tmp) < 47 then begin
      rxBuf := '';
      Exit;
    end;
    tmp := Trim(tmp);
    //tmp := Trim(Copy(rxBuf, 1, Length(rxBuf)));
    lblData.Caption := tmp;
    //rxBuf := '';
    Delete(rxBuf, 1, Pos(#$D, rxBuf));
    Delete(tmp, 1, Pos(',', tmp)); //delete raw clear
    Delete(tmp, 1, Pos(',', tmp)); //delete raw red
    Delete(tmp, 1, Pos(',', tmp)); //delete raw green
    Delete(tmp, 1, Pos(',', tmp)); //delete raw blue
    pnlRed.Caption := Copy(tmp, 1, Pos(',', tmp)-1); //get red
    Delete(tmp, 1, Pos(',', tmp));
    pnlGreen.Caption := Copy(tmp, 1, Pos(',', tmp)-1); //get green
    Delete(tmp, 1, Pos(',', tmp));
    pnlBlue.Caption := Copy(tmp, 1, Pos(',', tmp)-1); //get blue
    Delete(tmp, 1, Pos(',', tmp));
    if Pos(',', tmp) > 0 then
      pnlClear.Caption := Copy(tmp, 1, Pos(',', tmp)-1) //get clear
    else
      pnlClear.Caption := tmp;
    r := StrToIntDef(pnlRed.Caption, 0);
    g := StrToIntDef(pnlGreen.Caption, 0);
    b := StrToIntDef(pnlBlue.Caption, 0);
    aColor := RGBToColor(r, g, b);
    shp.Brush.Color := aColor;
  end;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  try
    if btnOpen.Caption = 'Open' then begin
      com.Device := cbCom.Text;
      com.Open;
      //com.PortName := cbCom.Text;
      //com.Baudrate := 9600;
      //com.DataBits := 8;
      //com.Parity := NOPARITY;
      //com.StopBits := ONESTOPBIT;
      //com.Enabled := True;
      btnOpen.Caption := 'Close';
      btnStart.Enabled := True;
      btnStop.Enabled := True;
      btnCalBlack.Enabled := True;
      btnCalWhite.Enabled := True;
    end else begin
      //com.Enabled := False;
      com.WriteData('OFF' + #$D#$A);
      com.Close;
      btnOpen.Caption := 'Open';
      btnStop.Enabled := False;
      btnStart.Enabled := False;
      btnCalBlack.Enabled := False;
      btnCalWhite.Enabled := False;
    end;
  Except
    com.Close;
    btnOpen.Caption := 'Open';
  end;
end;

procedure TForm1.btnCalBlackClick(Sender: TObject);
begin
  com.WriteData('CALB' + #$D#$A);
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  com.WriteData('ON' + #$D#$A);
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  com.WriteData('OFF' + #$D#$A);
end;

procedure TForm1.btnCalWhiteClick(Sender: TObject);
begin
  com.WriteData('CAL' + #$D#$A);
end;

procedure TForm1.cbComChange(Sender: TObject);
begin
  if cbCom.Text <> '' then
    btnOpen.Enabled := True;
end;

end.

