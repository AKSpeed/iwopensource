program ArcTest150;

uses
  IWRtlFix,
  Forms,
  IWStart,
  ArcForm150Test in 'ArcForm150Test.pas' {IWFormTest150: TIWAppForm},
  ServerController in 'ServerController.pas' {IWServerController: TIWServerControllerBase},
  UserSessionUnit in 'UserSessionUnit.pas' {IWUserSession: TIWUserSessionBase};

{$R *.res}

begin
  TIWStart.Execute(True);
end.
