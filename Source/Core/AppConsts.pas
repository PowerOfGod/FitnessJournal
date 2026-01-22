unit AppConsts;

interface

const
  // ============================================
  // ИНФОРМАЦИЯ О ПРИЛОЖЕНИИ
  // ============================================
  APP_NAME = 'Фитнес-центр';
  APP_TITLE = 'Журнал посещений фитнес-центра';
  APP_VERSION = '1.0.0';
  APP_FULL_TITLE = 'Фитнес-центр - Журнал посещений v1.0.0';

  // ============================================
  // ПУТИ И ФАЙЛЫ (ИСПОЛЬЗУЕМ ПРЯМОЙ СЛЕШ ИЛИ БЕЗ СЛЕША НА КОНЦЕ)
  // ============================================
  PATH_DATA = '.\Data';
  PATH_DATABASE = '.\Data\Database';
  PATH_IMAGES = '.\Data\Images';
  PATH_BACKUP = '.\Data\Backup';
  PATH_TEMPLATES = '.\Data\Templates';

  FILE_DATABASE = '.\Data\Database\FitnessCenter.db';
  FILE_DB_TEMPLATE = '.\Data\Templates\DatabaseTemplate.sql';

  // ============================================
  // НАСТРОЙКИ БАЗЫ ДАННЫХ
  // ============================================
  DB_DEFAULT_PAGE_SIZE = 4096;
  DB_ENCODING = 'UTF8';

  // ============================================
  // ФОРМАТЫ ДАТЫ И ВРЕМЕНИ
  // ============================================
  FORMAT_DATE_DISPLAY = 'dd.mm.yyyy';
  FORMAT_DATE_DB = 'yyyy-mm-dd';
  FORMAT_TIME_DISPLAY = 'hh:nn';
  FORMAT_TIME_DB = 'hh:nn:ss';

  // ============================================
  // ЛИМИТЫ ДАННЫХ
  // ============================================
  LIMIT_CLIENT_NAME = 100;
  LIMIT_CLIENT_PHONE = 20;
  LIMIT_CLIENT_EMAIL = 100;

  // ============================================
  // СООБЩЕНИЯ
  // ============================================
  MSG_CONFIRM_DELETE = 'Вы уверены, что хотите удалить запись?';
  MSG_DB_CONNECTED = 'База данных подключена';
  MSG_DB_ERROR = 'Ошибка базы данных';

implementation

end.
