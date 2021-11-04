#this script is designed to calculate polygenic adjustments
#read in a bgzip compressed matrix that consists of (a) rows of each variant included in the polygenic score and columns which include beta, freq, and dosage for each individual of the variant
#example matrix:
#variant"\t"beta"\t"freq"\t"sample1"\t"sample2"\t"sample3...
#1_1000_G/C"\t"numeric_value"\t"numeric_value"\t"dosage"\t"dosage"\t"dosage....
#1_1001_C/G"\t"numeric_value"\t"numeric_value"\t"dosage"\t"dosage"\t"dosage....
#1_1001_T/A"\t"numeric_value"\t"numeric_value"\t"dosage"\t"dosage"\t"dosage....
#...

matrix=$1
out_file=$2

beta_col=`zcat $matrix | awk -F '\t' ' { for (i = 1; i <= NF; ++i) print i, $i; exit } ' | grep -w -e beta | cut -f1 -d" "`
freq_col=`zcat $matrix | awk -F '\t' ' { for (i = 1; i <= NF; ++i) print i, $i; exit } ' | grep -w -e freq | cut -f1 -d" "`
    
if [[ ! -s $out_file ]]; then
    zcat $matrix | awk -F "\t" 'NR==1{ for (i=4; i<=NF; i++) header[i]=$i; next; } {for (i=4;i<=NF;i++) {if($i>0) sum[i]+=($'$beta_col'*( $i-$'$freq_col'))}} END{for (i in sum) print header[i], sum[i]}'  OFS="\t" | bgzip > $out_file
fi

