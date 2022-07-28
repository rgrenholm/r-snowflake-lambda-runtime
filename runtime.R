library("odbc")

list_snowflake_drivers <- function() {
  odbc::odbcListDrivers(keep = "SnowflakeDSIIDriver")
}

lambdr::start_lambda()
