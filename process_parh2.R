# Partitioned heritability result processing

suppressPackageStartupMessages({
  library(data.table)
  library(stringr)
  require(argparse)
})


parser <- argparse::ArgumentParser(description=":: FDR calculation for Paritioned h2 result; by Sanghyeon Park. ::", formatter_class="argparse.ArgumentDefaultsHelpFormatter")
parser$add_argument("--file", "-f", required=TRUE, help="Result file path of partitioned h2.")
parser$add_argument("--dir", required=FALSE, default='', help="Directory path where the FDR calculated result file will be saved.")

args <- parser$parse_args()

partitioned_h2_processing <- function(FILE, save2='') {
  filename <- str_split(FILE, "/")
  filename <- filename[[1]][length(filename[[1]])]
  data <- fread(file=FILE, header=TRUE)
  p <- 2*pnorm(-abs(data$'Coefficient_z-score'))
  cat('Number of genes compared:', length(p))
  fdr <- p.adjust(p, method='fdr', n = length(p))
  data$Cofficient_P <- p
  data$Cofficient_P_FDR <- fdr
  if(nchar(save2) == 0){
    save2 <- paste(getwd(), "/", sep="")
  }
  else{
    if(str_sub(save2, -1, -1) != '/'){
      save2 <- paste(save2, "/", sep="")
    }
  }
  write.csv(data, paste(save2, paste(filename, "_withFDR.csv", sep=""), sep=""), row.names=TRUE)
}

partitioned_h2_processing(FILE=args$file, save2=args$dir)
