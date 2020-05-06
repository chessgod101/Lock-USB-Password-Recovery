unit MainFrm;

interface

uses
  Windows, Forms, StdCtrls, Controls, Classes;

type
  TLockUSBFrmMain = class(TForm)
    DriveComboBox: TComboBox;
    PswEdit: TEdit;
    RecoverBtn: TButton;
    Label1: TLabel;
    RefreshBtn: TButton;
    Label2: TLabel;
    AboutBtn: TButton;
    procedure RecoverBtnClick(Sender: TObject);
    procedure EnumDrives;
    procedure FormCreate(Sender: TObject);
    procedure RefreshBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Type DISK_GEOMETRY= Record
Cylinders:Int64;
MEDIA_TYPE:Cardinal;
TracksPerCylinder:Cardinal;
SectorsPertTrack:Cardinal;
BytesPerSector:Cardinal;
End;


var
  LockUSBFrmMain: TLockUSBFrmMain;
  DriveArray: Array of WideChar;
  DALen:Cardinal;
CONST ULVersions:Array [0..2] of AnsiString=('Lock USB ex','Lock USB 32', 'Lock USB NT');
CONST ULConst:Array [0..2] of cardinal=($18, 9, $0A);
implementation

{$R *.dfm}

Function memcmp(d1,d2:PByte;len:Cardinal):Boolean;
var
I:Cardinal;
Begin
I:=0;
Result:=false;
while I<len do begin
if d1[I]<>d2[I] then
exit;
inc(I);
end;
Result:=true;
End;

Function DetectVersion(mHeader:PByte):Cardinal;
var
I,I2:cardinal;
Begin
for I := 0 to $40 do begin
for I2 := 0 to 2 do begin
 if memcmp(@ULVersions[I2][1],@mHeader[I],11) then begin
 Result:= ULConst[I2] SHL 9;
 exit;
 end;

end;
end;
result:=0;
End;

Function DecryptPassword(inBuf:PByte):AnsiString;
var
I:Cardinal;
Begin
I:=0;
Result:='';
while I<$40 do begin
inBuf[I]:=inBuf[I] + $F6;
inc(I);
if inBuf[I]=0 then break;
end;
Setlength(Result,I);
CopyMemory(@Result[1],@inBuf[0],I);
End;


Function RecoverPassword(driveL:WideChar):ansiString;
var
fhnd,tmp,ver:Cardinal;
mnHeader:Array[0..511] of Byte;
stF:WideString;
dg:DISK_GEOMETRY;
Begin
Result:='';
stF:='\\.\'+driveL+':';

fhnd:=CreateFileW(@stF[1],GENERIC_READ ,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,0,0);
if fhnd=INVALID_HANDLE_VALUE then begin
MessageBox(LockUSBFrmMain.Handle,'Cannot open drive.','Error',MB_OK);
exit;
end;

if DeviceIoControl(fhnd,IOCTL_DISK_GET_DRIVE_GEOMETRY,nil,0,@dg,sizeof(dg),tmp,nil)=false then Begin
MessageBox(LockUSBFrmMain.Handle,'Cannot Get Drive Geometry.','Error',MB_OK);
CloseHandle(fhnd);
exit;
End;

if dg.BytesPerSector<>512 then begin
MessageBox(LockUSBFrmMain.Handle,'Only 512 sector size supported.','Error',MB_OK);
CloseHandle(fhnd);
exit;
end;

if ReadFile(fhnd,mnHeader[0],$200,tmp,nil)=false then begin
MessageBox(LockUSBFrmMain.Handle,'Could not read from drive.','Error',MB_OK);
CloseHandle(fhnd);
exit
end;

ver:=DetectVersion(@mnHeader[0]);
if ver=0 then begin
MessageBox(LockUSBFrmMain.Handle,'Not protected with Lock USB.','Error',MB_OK);
CloseHandle(fhnd);
exit;
end;

SetFilePointer(fhnd,ver,nil,FILE_BEGIN);

if ReadFile(fhnd,mnHeader[0],$200,tmp,nil)=false then begin
CloseHandle(fhnd);
exit
end;
Result:=DecryptPassword(@mnHeader[10]);
//ListBox1.Items.Add(pswrd);

CloseHandle(fhnd);
//Result:=pswrd;
End;





procedure TLockUSBFrmMain.RecoverBtnClick(Sender: TObject);
begin
PswEdit.Text:=String(RecoverPassword(DriveArray[DriveComboBox.ItemIndex]));
end;





Function GetDiskName(dPath:WideString):WideString;
var
s,s2:Array [0..255] of WideChar;
tmp,tmp1,ln:Cardinal;
Begin
ZeroMemory(@s[0],256);
ZeroMemory(@s2[0],256);
 Result:='';
if GetVolumeInformationW(@dPath[1],@s[0],256,@tmp,ln,tmp1,@s2[0],256)= false then exit;
Result:=s;
End;


procedure TLockUSBFrmMain.RefreshBtnClick(Sender: TObject);
begin
EnumDrives;
end;

procedure TLockUSBFrmMain.AboutBtnClick(Sender: TObject);
begin
MessageBox(LockUSBFrmMain.Handle,'Copyright 2020 © Chester Fritz <reverseengineeringtips.blogspot.com>. All Rights Reserved','About',MB_OK);
end;

procedure TLockUSBFrmMain.EnumDrives;
var
I,dr,dt:Cardinal;
S:WideString;
begin
DriveComboBox.Clear;
SetLength(DriveArray,0);
DAlen:=0;
dr:=GetLogicalDrives;
for I := 0 to 25 do Begin
 if dr and 1=1 then  Begin
 S:=WideChar($41+I)+':\';
 dt:=GetDriveTypeW(@S[1]);
 if dt=2 then begin
 inc(DAlen);
 SetLength(DriveArray,DAlen);
 DriveArray[DAlen-1]:=WideChar($41+I);
 S:=S+' ('+GetDiskName(S)+')';
  DriveComboBox.Items.Add(S);
end;

 End;
  dr:=dr shr 1;
End;
DriveComboBox.ItemIndex:=0;
//
end;

procedure TLockUSBFrmMain.FormCreate(Sender: TObject);
begin
EnumDrives;
end;

end.
