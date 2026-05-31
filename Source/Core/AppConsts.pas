unit AppConsts;

interface

uses
  System.SysUtils;

function GetDBPath: string;

const

  APP_NAME = 'Фитнес-центр';
  APP_TITLE = 'Журнал посещений фитнес-центра';
  APP_VERSION = '1.0.0';
  APP_FULL_TITLE = 'Фитнес-центр - Журнал посещений v1.0.0';


  PATH_DATA = 'Data';
  PATH_DATABASE = PATH_DATA + '\Database';
  PATH_IMAGES = PATH_DATA + '\Images';
  PATH_BACKUP = PATH_DATA + '\Backup';
  PATH_TEMPLATES = PATH_DATA + '\Templates';

  FILE_DATABASE = PATH_DATABASE + '\FitnessCenter.db';


  DB_DEFAULT_PAGE_SIZE = 4096;
  DB_ENCODING = 'UTF8';


  FORMAT_DATE_DISPLAY = 'dd.mm.yyyy';
  FORMAT_DATE_DB = 'yyyy-mm-dd';
  FORMAT_TIME_DISPLAY = 'hh:nn';
  FORMAT_TIME_DB = 'hh:nn:ss';


  LIMIT_CLIENT_NAME = 100;
  LIMIT_CLIENT_PHONE = 20;
  LIMIT_CLIENT_EMAIL = 100;


  MSG_CONFIRM_DELETE = 'Вы уверены, что хотите удалить запись?';
  MSG_DB_CONNECTED = 'База данных подключена';
  MSG_DB_ERROR = 'Ошибка базы данных';

implementation

function GetDBPath: string;
    begin
      Result := ExtractFilePath(ParamStr(0)) + 'FitnessCenter.db';
    end;

end.
