unit DBModule;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Comp.Client, FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.SQLite, FireDAC.DApt, FireDAC.UI.Intf,
  AppConsts;

type
  TDBConnect = class
  private
//    FConnection: TFDConnection;
//    function GetDBPath: string;

  public                                    //    constructor Create;
//    destructor Destroy; override;
//
//    function Connect: Boolean;
//    procedure Disconnect;
//    function IsConnected: Boolean;
//
//    function ExecuteSQL(const SQL: string): Boolean;
//    function GetClient: TStringList;
//    function AddClient(const Name, Phone: String): Boolean;
//
//    function TestConnection: Boolean;
//   function GetDBInfo: string;


  end;

var
DB: TDBConnect;
//
implementation
//
//constructor TDBConnect.Create;
//begin
//  WriteLn('=== Создаем TDBManager ===');
//
//  // Создаем объект подключения
//  FConnection := TFDConnection.Create(nil);
//  WriteLn('✅ FConnection создан');
//
//  // Проверяем что создался
//  if FConnection = nil then
//    WriteLn('❌ ОШИБКА: FConnection не создан!')
//  else
//    WriteLn('✅ FConnection готов к работе');
//end;
//
//destructor TDBConnect.Destroy;
//begin
//  Disconnect;
//  FConnection.Free;
//  inherited;
//end;
//
//procedure TDBConnect.Disconnect;
//begin
//  if FConnection.Connected then
//    FConnection.Connected := False;
//end;
//
//
//function TDBConnect.ExecuteSQL(const SQL: string): Boolean;
//begin
//  Result := false;
//  try
//          FConnection.ExecSQL(SQL);
//          Result := true;
//  except
//      on E: Exception do
//      WriteLn('Ошибка SQL: ' + E.Message);
//  end;
//end;
//
//function TDBConnect.GetDBPath: string;
//begin
//  // Вместо ExpandFileName используем более надежный вариант
//  Result := ('D:\программирование\FitnessJournal\' + FILE_DATABASE);
//
//  // Выведем путь для отладки
//  WriteLn('Путь к БД: ' + Result);
//  WriteLn('Файл существует: ' + BoolToStr(FileExists(Result), True));
//end;
//
//function TDBConnect.IsConnected: Boolean;
//begin
//  Result := FConnection.Connected;
//end;
//
//function TDBConnect.Connect: Boolean;
//begin
//  Result := False;
//  try
//    FConnection.DriverName := 'SQLite';
//    FConnection.Params.Database := GetDBPath;
//    FConnection.Params.Add('LockingMode=Normal');
//    FConnection.Params.Add('Synchronous=Normal');
//
//    FConnection.Connected := True;
//    Result := True;
//    WriteLn('БД подключена: ' + GetDBPath);
//  except
//    on E: Exception do
//    begin
//      WriteLn('Ошибка подключения: ' + E.Message);
//      Result := False;
//    end;
//
//  end;
//end;
//
//
//function TDBConnect.GetClient: TStringList;
//var
//  Query: TFDQuery;
//begin
//Result := TStringList.Create;
//
//if not IsConnected then
//  Exit;
//
//  Query := TFDQuery.Create(nil);
//
//    try
//      Query.Connection := FConnection;
//      Query.SQL.Text := 'SELECT id, full_name FROM clients ORDER BY full_name';
//      Query.Open;
//
//      while not Query.Eof do
//      begin
//        Result.Add(Query.FieldByName('full_name').AsString);
//        Query.Next;
//      end;
//
//      Query.Close;
//
//    finally
//      Query.Free;
//
//    end;
//
//
//end;
//
//
//function TDBConnect.AddClient(const Name, Phone: string): Boolean;
//var
//  SQL: string;
//begin
//  SQL := Format('INSERT INTO clients (full_name, phone) VALUES (''%s'', ''%s'')',
//                [Name, Phone]);
//  Result := ExecuteSQL(SQL);
//end;
//
//
//initialization
//  DB := TDBConnect.Create;
//
//finalization
//  DB.Free;
//
end.
