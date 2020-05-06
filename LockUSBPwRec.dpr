program LockUSBPwRec;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {LockUSBFrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLockUSBFrmMain, LockUSBFrmMain);
  Application.Run;
end.
