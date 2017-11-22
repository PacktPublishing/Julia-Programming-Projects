module Database

using MySQL

const HOST = "localhost"
const USER = "root"
const PASS = ""
const DB = "six_degrees"

const CONN = mysql_connect(HOST, USER, PASS, DB)

export CONN

disconnect() = mysql_disconnect(CONN)

atexit(disconnect)

end