#' Search chokepoint risk records in natural language
#'
#' A single free-text entry point to the data: describe what you are looking for
#' (e.g. "drought Panama", "piracy Hormuz", "cyberattack") and
#' \code{cp_search()} returns the matching records, ranked by relevance. Every
#' whitespace-separated term must appear (case-insensitively) somewhere in a
#' record's location, risk, risk category, risk code, level or incident text.
#'
#' @param query A search string. Multiple words are treated as an AND query
#'   (all terms must match). If empty or missing, the full dataset is returned.
#' @param incidents_only If \code{TRUE}, restrict results to records that
#'   describe a documented incident (non-missing \code{incident}). Default
#'   \code{FALSE}.
#'
#' @return A data frame of matching rows from \code{\link{chokepoint_risks}}, ordered so
#'   that the strongest matches (most terms hit, documented incidents first)
#'   appear at the top. Returns 0 rows if nothing matches.
#' @export
#'
#' @seealso \code{\link{cp_data}} for structured filtering.
#'
#' @examples
#' cp_search("drought Panama")
#' cp_search("piracy")
#' cp_search("Suez storm", incidents_only = TRUE)
#' cp_search("Red Sea")
cp_search <- function(query = "", incidents_only = FALSE) {
  d <- chokepoint_risks
  if (isTRUE(incidents_only)) d <- d[!is.na(d$incident), , drop = FALSE]

  if (missing(query) || is.null(query) || !nzchar(trimws(paste(query, collapse = " ")))) {
    rownames(d) <- NULL
    return(d)
  }

  terms <- tolower(strsplit(trimws(query), "\\s+")[[1]])

  # Searchable text for each row (all descriptive columns combined).
  text_cols <- c("location", "risk", "risk_category", "risk_code",
                 "level", "incident", "source")
  hay <- tolower(do.call(paste, c(lapply(text_cols, function(cl) {
    v <- d[[cl]]
    ifelse(is.na(v), "", as.character(v))
  }), sep = " ")))

  # Per-term substring hit matrix; keep rows matching ALL terms.
  hits <- vapply(terms, function(t) grepl(t, hay, fixed = TRUE),
                 logical(length(hay)))
  if (is.null(dim(hits))) hits <- matrix(hits, ncol = length(terms))
  n_hits <- rowSums(hits)
  keep <- n_hits == length(terms)

  out <- d[keep, , drop = FALSE]
  if (nrow(out) == 0L) {
    rownames(out) <- NULL
    return(out)
  }

  # Rank: more term hits first, then documented incidents first.
  ord <- order(-n_hits[keep], is.na(out$incident))
  out <- out[ord, , drop = FALSE]
  rownames(out) <- NULL
  out
}
