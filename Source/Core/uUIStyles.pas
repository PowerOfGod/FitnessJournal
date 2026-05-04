unit uUIStyles;

interface

uses
  Vcl.DBGrids,
  Vcl.Graphics,
  Data.DB;

type
  TUIStyles = class
  public
    class procedure FormatDates(DataSet: TDataSet; const DateFields: array of string);
  end;

implementation

class procedure TUIStyles.FormatDates(DataSet: TDataSet; const DateFields: array of string);
var
  i: Integer;
  fld: TField;
begin
  if DataSet = nil then Exit;
  if not DataSet.Active then Exit;

  for i := 0 to Length(DateFields) - 1 do
  begin
    fld := DataSet.FindField(DateFields[i]);
    if (fld <> nil) and (fld is TDateTimeField) then
      TDateTimeField(fld).DisplayFormat := 'dd.mm.yyyy';
  end;
end;

end.иже
