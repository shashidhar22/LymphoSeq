% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/searchSeq.R
\name{searchSeq}
\alias{searchSeq}
\title{Search for a sequence}
\usage{
searchSeq(
  list,
  sequence,
  type = "aminoAcid",
  match = "global",
  editDistance = 0
)
}
\arguments{
\item{list}{A list of data frames generated by the LymphoSeq functions readImmunoSeq 
or productiveSeq.  "aminoAcid" or "nucleotide", "frequencyCount", and 
"count" are required columns.}

\item{sequence}{A character vector of one ore more amino acid or nucleotide 
CDR3 sequences to search.}

\item{type}{A character vector specifying the type of sequence(s) to be 
searched.  Available options are "aminoAcid" or "nucleotide".}

\item{match}{A character vector specifying whether an exact partial or exact global
 match of the searched sequence(s) is desired.  Available options are 
"partial" and "global".}

\item{editDistance}{An integer giving the minimum edit distance that the 
sequence must be less than or equal to.  See details below.}
}
\value{
Returns the rows for every instance in the list of data frames where 
the searched sequence(s) appeared.
}
\description{
Search for one or more amino acid or nucleotide CDR3 sequences in a list of 
data frames.
}
\details{
An exact partial match means the searched sequence is contained within 
target sequence.  An exact global match means the searched sequence is identical to 
the target sequence.

Edit distance is a way of quantifying how dissimilar two sequences 
are to one another by counting the minimum number of operations required to 
transform one sequence into the other.  For example, an edit distance of 0 
means the sequences are identical and an edit distance of 1 indicates that 
the sequences different by a single amino acid or nucleotide.
}
\examples{
file.path <- system.file("extdata", "TCRB_sequencing", package = "LymphoSeq")

file.list <- readImmunoSeq(path = file.path)

aa1 <- "CASSPVSNEQFF"

aa2 <- "CASSQEVPPYQAFF"

searchSeq(list = file.list, sequence = aa1, type = "aminoAcid", 
   match = "global", editDistance = 0)

searchSeq(list = file.list, sequence = c(aa1, aa2), 
   type = "aminoAcid", match = "global", editDistance = 0)

searchSeq(list = file.list, sequence = aa1, type = "aminoAcid", editDistance = 1)

nt <- "CTGATTCTGGAGTCCGCCAGCACCAACCAGACATCTATGTACCTCTGTGCCAGCAGTCCGGTAAGCAATGAGCAGTTCTTCGGGCCA"

searchSeq(list = file.list, sequence = nt, type = "nucleotide", editDistance = 3)

searchSeq(list = file.list, sequence = "CASSPVS", type = "aminoAcid", 
   match = "partial", editDistance = 0)

searchSeq(list = file.list, sequence = nt, type = "nucleotide", editDistance = 0)
}
