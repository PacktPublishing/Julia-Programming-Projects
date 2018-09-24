module Database

using MySQL

const HOST = "localhost"
const USER = "root"
const PASS = "root"
const DB = "six_degrees"

const CONN = MySQL.connect(HOST, USER, PASS, db = DB)

export CONN

disconnect() = MySQL.disconnect(CONN)

atexit(disconnect)

end
