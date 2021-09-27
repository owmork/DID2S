## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval = FALSE------------------------------------------------------------
#  remotes::install_github("kylebutts/did2s")

## ----load-data, code_folding=TRUE---------------------------------------------
library(did2s) ## The main package. Will automatically load fixest as well.
library(ggplot2) 

## Load heterogeneous treatment dataset from the package
data("df_het")
head(df_het)

## ----plot-df-het, fig.width=8, fig.height=4, fig.cap="Example data with heterogeneous treatment effects"----

# Mean for treatment group-year
agg <- aggregate(df_het$dep_var, by=list(g = df_het$g, year = df_het$year), FUN = mean)

agg$g <- as.character(agg$g)
agg$g <- ifelse(agg$g == "0", "Never Treated", agg$g)

never <- agg[agg$g == "Never Treated", ]
g1 <- agg[agg$g == "2000", ]
g2 <- agg[agg$g == "2010", ]


plot(0, 0, xlim = c(1990,2020), ylim = c(4,7.2), type = "n",
     main = "Data-generating Process", ylab = "Outcome", xlab = "Year")
abline(v = c(1999.5, 2009.5), lty = 2)
lines(never$year, never$x, col = "#8e549f", type = "b", pch = 15)
lines(g1$year, g1$x, col = "#497eb3", type = "b", pch = 17)
lines(g2$year, g2$x, col = "#d2382c", type = "b", pch = 16)
legend(x=1990, y=7.1, col = c("#8e549f", "#497eb3", "#d2382c"), 
       pch = c(15, 17, 16),
       legend = c("Never Treated", "2000", "2010"))



## ----static-------------------------------------------------------------------

# Static
static <- did2s(df_het, 
				yname = "dep_var", first_stage = ~ 0 | state + year, 
				second_stage = ~i(treat, ref=FALSE), treatment = "treat", 
				cluster_var = "state")

fixest::esttable(static)


## ----event-study--------------------------------------------------------------

# Event Study
es <- did2s(df_het,
			yname = "dep_var", first_stage = ~ 0 | state + year, 
			second_stage = ~i(rel_year, ref=c(-1, Inf)), treatment = "treat", 
			cluster_var = "state")


## ----plot-es, fig.cap="Event-study plot with example data"--------------------

fixest::iplot(es, main = "Event study: Staggered treatment", xlab = "Relative time to treatment", col = "steelblue", ref.line = -0.5)

# Add the (mean) true effects
true_effects = head(tapply((df_het$te + df_het$te_dynamic), df_het$rel_year, mean), -1)
points(-20:20, true_effects, pch = 20, col = "black")

# Legend
legend(x=-20, y=3, col = c("steelblue", "black"), pch = c(20, 20), 
       legend = c("Two-stage estimate", "True effect"))


## ----plot-compare, ig.cap="TWFE and Two-Stage estimates of Event-Study"-------

twfe = feols(dep_var ~ i(rel_year, ref=c(-1, Inf)) | unit + year, data = df_het) 

fixest::iplot(list(es, twfe), sep = 0.2, ref.line = -0.5,
      col = c("steelblue", "#82b446"), pt.pch = c(20, 18), 
      xlab = "Relative time to treatment", 
      main = "Event study: Staggered treatment (comparison)")


# Legend
legend(x=-20, y=3, col = c("steelblue", "#82b446"), pch = c(20, 18), 
       legend = c("Two-stage estimate", "TWFE"))


## -----------------------------------------------------------------------------
citation(package = "did2s")

