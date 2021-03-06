#' Clonality
#' 
#' Creates a data frame giving the total number of sequences, number of unique 
#' productive sequences, number of genomes, entropy, clonality, Gini 
#' coefficient, and the frequency (\%) of the top productive sequences in a list 
#' of sample data frames.
#' 
#' @param file.list A list of data frames consisting of antigen receptor 
#' sequencing imported by the LymphoSeq function readImmunoSeq. "aminoAcid", "count", 
#' and "frequencyCount" are required columns.  "estimatedNumberGenomes" is optional.  
#' Note that clonality is usually calculated from productive nucleotide sequences.  
#' Therefore, it is not recommended to run this function using a productive sequence
#' list aggregated by amino acids.
#' @return Returns a data frame giving the total number of sequences, number of 
#' unique productive sequences, number of genomes, clonality, Gini coefficient, 
#' and the frequency (\%) of the top productive sequence in each sample.
#' @details Clonality is derived from the Shannon entropy, which is calculated 
#' from the frequencies of all productive sequences divided by the logarithm of 
#' the total number of unique productive sequences.  This normalized entropy 
#' value is then inverted (1 - normalized entropy) to produce the clonality 
#' metric.  
#' 
#' The Gini coefficient is an alternative metric used to calculate repertoire 
#' diversity and is derived from the Lorenz curve.  The Lorenz curve is drawn 
#' such that x-axis represents the cumulative percentage of unique sequences and 
#' the y-axis represents the cumulative percentage of reads.  A line passing 
#' through the origin with a slope of 1 reflects equal frequencies of all clones.  
#' The Gini coefficient is the ratio of the area between the line of equality 
#' and the observed Lorenz curve over the total area under the line of equality.  
#' Both Gini coefficient and clonality are reported on a scale from 0 to 1 where 
#' 0 indicates all sequences have the same frequency and 1 indicates the 
#' repertoire is dominated by a single sequence.
#' @examples
#' file.path <- system.file("extdata", "TCRB_sequencing", package = "LymphoSeq")
#' 
#' file.list <- readImmunoSeq(path = file.path)
#' 
#' clonality(file.list = file.list)
#' @seealso \code{\link{lorenzCurve}}
#' @export
#' @importFrom ineq Gini
clonality <- function(file.list) {
    table <- data.frame(samples = names(file.list))
    i <- 1
    for (i in 1:length(file.list)) {
        file <- file.list[[i]]
        total.reads <- nrow(file)
        total.count <- sum(file$count)
        productive <- file[file$`function` == "in-frame", ]
        frequency <- productive$count/sum(productive$count)
        entropy <- -sum(frequency * log2(frequency), na.rm = TRUE)
        unique.productive <- nrow(productive)
        clonality <- 1 - round(entropy/log2(unique.productive), digits = 6)
        table$totalSequences[i] <- total.reads
        table$uniqueProductiveSequences[i] <- unique.productive
        table$totalCount[i] <- total.count
        table$clonality[i] <- clonality
        table$giniCoefficient[i] <- ineq::Gini(frequency)
        table$topProductiveSequence[i] <- max(frequency) * 100
        if (any(grepl("estimatedNumberGenomes", colnames(file)))) {
            file$estimatedNumberGenomes <- suppressWarnings(as.integer(file$estimatedNumberGenomes))
            total.genomes <- sum(file$estimatedNumberGenomes)
            table$totalGenomes[i] <- ifelse(total.genomes == 0, NA, total.genomes)
        } else {
            table$totalGenomes[i] <- NA
        }
    }
    table <- table[order(table$topProductiveSequence, decreasing = TRUE), ]
    rownames(table) <- NULL
    return(table)
} 