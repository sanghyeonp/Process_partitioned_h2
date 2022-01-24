suppressPackageStartupMessages({
  library(data.table)
  library(stringr)
  require(argparse)
})


parser <- argparse::ArgumentParser(description=":: FDR calculation for Paritioned h2 result; by Sanghyeon Park. ::", formatter_class="argparse.ArgumentDefaultsHelpFormatter")
parser$add_argument("--file", "-f", required=TRUE, help="Result file path of partitioned h2 cell-type specific analysis.")
parser$add_argument("--dir", required=FALSE, default='', help="Directory path where the FDR calculated result file will be saved.")

args <- parser$parse_args()

celltype_analysis_processing <- function(FILE, save2='') {
  sp <- str_split(FILE, "/")
  filename <- str_sub(sp[[1]][length(sp[[1]])], end=-5)
  data <- fread(file=FILE, header=TRUE)
  p <- data$Coefficient_P_value
  cat('Number of cell types compared:', length(p), '\n')
  fdr <- p.adjust(p, method='fdr', n = length(p))
  data$Coefficient_P_FDR <- fdr
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

celltype_analysis_processing(args$file, args$dir)
