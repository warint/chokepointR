#' @keywords internal
"_PACKAGE"

#' @importFrom utils globalVariables
NULL

# Silence R CMD check notes for bundled datasets referenced by name in package
# code (they are lazy-loaded from data/).
globalVariables(c("chokepoint_risks", "chokepoints", "risk_types",
                  "chokepoint_resilience", "chokepoint_context",
                  "chokepoint_sources"))
