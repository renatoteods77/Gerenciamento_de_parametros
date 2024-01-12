-- Para ver todos os parâmetros de inicialização do banco:

show parameter

-- Para ver o valor de parâmetros específicos (substituir control pelo nome desejado):

show parameter control

-- Verificação de parâmetros estáticos e dinâmicos:
 "Quando voltar false, significa que ele não é um parametro dinamico"
comando abaixo é para verificar ser o parametro 'processes' é dinamico:
parametro quando estatico só é permitido alterar no scope do spfile e nao na memoria.

SELECT ISINSTANCE_MODIFIABLE FROM V$PARAMETER WHERE NAME='processes';

SHOW PARAMETER processes

ALTER SYSTEM SET processes=500;

ALTER SYSTEM SET processes=500 SCOPE=BOTH;

ALTER SYSTEM SET processes=500 SCOPE=MEMORY;

ALTER SYSTEM SET processes=500 SCOPE=SPFILE;

SELECT ISINSTANCE_MODIFIABLE FROM V$PARAMETER WHERE NAME='db_cache_size';

SHOW PARAMETER db_cache_size

ALTER SYSTEM SET db_cache_size=100M SCOPE=MEMORY;

SHOW PARAMETER db_cache_size

ALTER SYSTEM RESET db_cache_size SCOPE=MEMORY;

-- Criar pfile a partir do spfile:

cd $ORACLE_HOME/dbs

rm initorcl.ora

create pfile from spfile;

create pfile='/home/oracle/my_pfile.ora' from spfile;

-- Inicializar instância pelo pfile:

SHUTDOWN IMMEDIATE

STARTUP PFILE='/home/oracle/my_pfile.ora'

ALTER SYSTEM SET processes=500 SCOPE=SPFILE;

ALTER SYSTEM SET processes=500 SCOPE=BOTH;

ALTER SYSTEM SET processes=500 SCOPE=MEMORY;

SHOW PARAMETER db_cache_size

ALTER SYSTEM SET db_cache_size=100M SCOPE=MEMORY;

SHOW PARAMETER db_cache_size

SHUTDOWN IMMEDIATE

STARTUP

SHOW PARAMETER db_cache_size

-- RECUPERAÇÃO DE SPFILE USANDO DADOS EM MEMÓRIA:

SHOW PARAMETER SPFILE

!rm -f /u01/app/oracle/product/19.0.0/dbhome_1/dbs/spfileorcl.ora
!rm -f /u01/app/oracle/product/19.0.0/dbhome_1/dbs/initorcl.ora

!ls -lh /u01/app/oracle/product/19.0.0/dbhome_1/dbs/spfileorcl.ora

CREATE SPFILE='/home/oracle/spfile_from_memory.ora' FROM MEMORY;

ALTER SYSTEM SET PROCESSES=500 SCOPE=SPFILE;

cp /home/oracle/spfile_from_memory.ora /u01/app/oracle/product/19.0.0/dbhome_1/dbs/spfileorcl.ora

ALTER SYSTEM SET PROCESSES=500 SCOPE=SPFILE;

-- RECUPERAÇÃO DE SPFILE ATRAVÉS DO PFILE:

!rm -f /u01/app/oracle/product/19.0.0/dbhome_1/dbs/spfileorcl.ora

SHUTDOWN IMMEDIATE

STARTUP

STARTUP NOMOUNT PFILE='/home/oracle/my_pfile.ora';

CREATE SPFILE FROM PFILE='/home/oracle/my_pfile.ora';

SHUTDOWN IMMEDIATE

STARTUP

-- RECUPERAÇÃO DE SPFILE ATRAVÉS DO ALERT LOG:

!rm -f /u01/app/oracle/product/19.0.0/dbhome_1/dbs/spfileorcl.ora

ALTER SYSTEM SET PROCESSES=500 SCOPE=SPFILE;

SHUTDOWN IMMEDIATE

STARTUP

-- 1.criar pfile:

vi /home/oracle/pfile_from_alert.ora

processes                = 320
nls_language             = "AMERICAN"
nls_territory            = "AMERICA"
memory_target            = 1472M
control_files            = "/u02/oradata/ORCL/control01.ctl"
control_files            = "/u02/oradata/ORCL/control02.ctl"
db_block_size            = 8192
compatible               = "19.0.0"
db_create_file_dest      = "/u02/oradata"
db_recovery_file_dest    = "/u02/oradata"
db_recovery_file_dest_size= 10G
undo_tablespace          = "UNDOTBS1"
remote_login_passwordfile= "EXCLUSIVE"
db_domain                = "localdomain"
dispatchers              = "(PROTOCOL=TCP) (SERVICE=orclXDB)"
local_listener           = "LISTENER"
audit_file_dest          = "/u01/app/oracle/admin/orcl/adump"
audit_trail              = "DB"
db_name                  = "orcl"
open_cursors             = 300
diagnostic_dest          = "/u01/app/oracle"
enable_pluggable_database= TRUE

-- 2. Iniciar o banco através do PFILE criado
startup pfile='/home/oracle/pfile_from_alert.ora'

-- 3. Criar um spfile a partir do PFILE ou da memória:

create spfile from pfile='/home/oracle/pfile_from_alert.ora';

create spfile from memory;

-- Reiniciar o banco:
shutdown immediate

startup

