package sql_queries

import _ "embed"

//go:embed count.sql
var CountSql string

//go:embed average.sql
var AverageSql string

//go:embed weekly_deployment.sql
var WeeklyDeploymentSql string

//go:embed monthly_deployment.sql
var MonthlyDeploymentSql string

//go:embed quarterly_deployment.sql
var QuarterlyDeploymentSql string

//go:embed benchmark_df.sql
var BenchmarkDfSql string

//go:embed benchmark_mltc.sql
var BenchmarkMltcSql string

//go:embed monthly_mltc.sql
var MonthlyMltcSql string

//go:embed weekly_mltc.sql
var WeeklyMltcSql string

//go:embed quarterly_mltc.sql
var QuarterlyMltcSql string

//go:embed weekly_cfr.sql
var WeeklyCfrSql string

//go:embed monthly_cfr.sql
var MonthlyCfrSql string

//go:embed quarterly_cfr.sql
var QuarterlyCfrSql string
