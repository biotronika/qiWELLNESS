unit unitDownload;
(*
 *  GZ 2020-05-31
 *  Multiplatform module, works with SSL (openssl)
 *
 *)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, fphttpclient(*, ssockets, sslsockets, fpopenssl*);

type

  { TDownloadFrInternet }

  TDownloadFrInternet = class(TObject)


  private

     function Download(AFrom, ATo: String): Boolean;
     procedure DataReceived(Sender : TObject; const ContentLength, CurrentPos : Int64);
     procedure GetSocketHandler(Sender : TObject; const {%H-}UseSSL : Boolean(*; Out AHandler : TSocketHandler*));

  public
    function DownloadInternetFile(Src, Dst: String): Boolean;

  end;

var
  DownloadFrInternet: TDownloadFrInternet;

implementation

procedure TDownloadFrInternet.DataReceived(Sender: TObject;const ContentLength,
  CurrentPos: Int64);
begin
     Application.ProcessMessages;
end;

procedure TDownloadFrInternet.GetSocketHandler(Sender: TObject; const UseSSL: Boolean(*; out
  AHandler: TSocketHandler*));
begin
  //AHandler := TSSLSocketHandler.Create;
  //TSSLSocketHandler(AHandler).SSLType := stTLSv1_2;

end;

function TDownloadFrInternet.Download(AFrom, ATo: String): Boolean;
var
  HTTPClient: TFPHTTPClient;
begin
  Result := False;
  HTTPClient := TFPHTTPClient.Create(nil);
  try
    //HTTPClient.OnDataReceived := @DataReceived;
    //HTTPClient.OnGetSocketHandler := @GetSocketHandler;

    HTTPClient.AllowRedirect := True;
    //HTTPClient.AddHeader('User-Agent','Mozilla/5.0 (compatible; fpweb)');
    HTTPClient.AddHeader('User-Agent','qiwellness');
    try
      HTTPClient.Get(AFrom, ATo);
      Result := True;
    except
      on E: Exception do
        ShowMessage(E.Message)
    end;
  finally
     HTTPClient.Free;
  end;
end;

function TDownloadFrInternet.DownloadInternetFile(Src, Dst: String): Boolean;
begin
  try
     Application.ProcessMessages;
     Result := Download (Src, Dst);
  except
    Result := False;
  end;
end;


end.


