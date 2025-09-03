# Install packages
install.packages(c("devtools", "roxygen2", "testthat"))
install.packages(c("DSI", "DSOpal", "dsBase", "dsBaseClient"))

# Load library
library(devtools)
library(roxygen2)

# Rebuild server package
setwd("C:/Users/golna/OneDrive/Documents/DataShield Package (5)/dsMyPackageServer")
devtools::document()
devtools::install(force = TRUE)

# Rebuild client package
setwd("C:/Users/golna/OneDrive/Documents/DataShield Package (5)/dsMyPackageClient")
devtools::document()
devtools::install(force = TRUE)


setwd("C:/Users/golna/OneDrive/Documents/DataShield Package (5)")
create_package("dsMyPackageServer")
setwd("dsMyPackageServer")

setwd("C:/Users/golna/OneDrive/Documents/DataShield Package (5)")
create_package("dsMyPackageClient")
setwd("dsMyPackageClient")


# Reload everything
library(DSLite)
library(dsMyPackageServer)
library(dsMyPackageClient)

# Check if ds.viz is now available
exists("ds.viz", envir = asNamespace("dsMyPackageClient"))

# Recreate your setup
test_data <- data.frame(
  age = c(25, 30, 35, 40, 45, 50, 55, 60),
  income = c(30000, 35000, 40000, 45000, 50000, 55000, 60000, 65000)
)

dslite.server <- DSLite::newDSLiteServer(
  tables = list(dataset1 = test_data),
  config = DSLite::defaultDSConfiguration(include = "dsBase")
)

dslite.server$aggregateMethod("histDataDS", "dsMyPackageServer::histDataDS")
dslite.server$aggregateMethod("summaryStatsDS", "dsMyPackageServer::summaryStatsDS")

builder <- DSI::newDSLoginBuilder()
builder$append(server = "server1", url = "dslite.server", table = "dataset1", driver = "DSLiteDriver")
logindata <- builder$build()
conns <- DSI::datashield.login(logindata, assign = TRUE, symbol = "D")

# Now test
result <- ds.viz(conns, "D$age", breaks = 5)
print(result)
