---
title: plink
---

- plink 選取chr position
	 - 
```bash
plink2 --extract range MYSNPFILE --make-bed --out MYOUTFILE --pfile MYPSAM,PVAR,PGENFILES

```

- run VEP
	 - 
```bash
./INSTALL.pl --AUTO afp --SPECIES homo_sapiens --ASSEMBLY GRCh38 --PLUGINS AlphaMissense,ExAC,UpDownDistance
./convert_cache.pl --species homo_sapiens --version 110_GRCh38
./vep -i /home/dmr510/JAK_inhbitor_gene/TAICHUNG_Freeze_JAK_inhbitor_gene.vcf -o /home/dmr510/JAK_inhbitor_gene/TAICHUNG_Freeze_JAK_inhbitor_gene_GRCh38.vep.vcf --species homo_sapiens --cache --plugin AlphaMissense,file=/home/dmr510/ensembl-vep/AlphaMissense_hg38.tsv.gz --vcf --force_overwrite
./vep -i input.vcf -o output.vcf --cache --offline --assembly GRCh38 --fasta Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --vcf

awk 'NR==1 {header=$_} FNR==1 && NR!=1 { $_ ~ $header getline; } {print}' PDR_GWAS_*.hybrid > PDR_GWAS_output

for file in chr{1..99}_smallfiles; do # 99 is the maximum file number
    [ -f "$file" ] || continue # skip missing files
    awk 'FNR > 1' "$file"
done > bigfile

ls -v1 PDR_GWAS_chr*.caco.glm.logistic.hybrid | xargs -d $'\n' tail -q -n+2 > PDR_GWAS_output_merge.glm.logistic.hybrid

```

- PRS
	 - 
```bash
plink2 --bfile impute_postqc_merge_rsid --covar TUDR_PDR_train.cov --covar-name sex,age --pheno TUDR_PDR_train.cov --pheno-name caco --glm hide-covar --maf 0.01 --hwe 0.00001 --geno 0.05 --out TUDR_PDR_base 
plink2 --bfile impute_postqc_merge_rsid --covar V_PDR_train.cov --covar-name sex,age --pheno V_PDR_train.cov --pheno-name caco --glm hide-covar --maf 0.01 --hwe 0.00001 --geno 0.05 --out V_PDR_base

plink2 --bfile impute_postqc_merge_rsid --keep TUDR_V_test.cov --maf 0.01 --hwe 0.00001 --geno 0.05 --make-bed --out TUDR_V_target

plink2 --bfile impute_postqc_merge_rsid \
    --covar V_PDR_train.cov --covar-name sex,age \
    --pheno V_PDR_train.cov --pheno-name caco \
    --glm hide-covar \
    --maf 0.01 --hwe 0.00001 --geno 0.05 \
    --out V_PDR_base

```

	 - 
```r
dat <- read.table("TPMI_NUR_gwas_merge.txt", header=T, sep = "\t")
dat$BETA <- log(as.numeric(dat$OR))
write.table(dat, "TPMI_NUR_QC.Transformed", quote=F, row.names=F, col.names=T)
q() # exit R

dat <- read.table("V_PDR_base.caco.glm.logistic.hybrid", header=T, sep = "\t")
dat$BETA <- log(as.numeric(dat$OR))
write.table(dat, "V_PDR_base.QC.Transformed", quote=F, row.names=F, col.names=T)
q() # exit R

dat <- read.table("PDR_GWAS_output_merge.glm.logistic.hybrid", header=T, sep = "\t")
dat$BETA <- log(as.numeric(dat$OR))
write.table(dat, "TPMI_PDR_test.QC.Transformed", quote=F, row.names=F, col.names=T)
q() # exit R

dat <- read.table("TPMI_CAD_gwas_merge.txt", header=T, sep = "\t")
dat$BETA <- log(as.numeric(dat$OR))
write.table(dat, "TPMI_CAD_gwas_merge.Transformed", quote=F, row.names=F, col.names=T)
q() # exit R

```

	 - 
```bash
plink \
    --bfile TUDR_V_target \
    --pheno TUDR_V_test.cov --pheno-name caco \
    --allow-no-sex \
    --clump-p1 1 \
    --clump-r2 0.1 \
    --clump-kb 250 \
    --clump TPMI_PDR_base.QC.Transformed \
    --clump-snp-field SNP \
    --clump-field P \
    --out TUDR_V_TPMI

awk 'NR!=1{print $3}' TUDR_V.clumped > TUDR_V_TPMI.valid.snp
awk '{print $3,$13}' TPMI_PDR_base.QC.Transformed > TPMI_PDR_base.SNP.pvalue

```

- 
	 - PRS  計算 example
		 - 
```bash
#CAD
plink \
    --bfile CAD_PRS/TAICHI_CAD \
    --pheno CAD_PRS/TAICHI_CAD.txt --pheno-name CAD \
    --allow-no-sex \
    --clump-p1 1 \
    --clump-r2 0.1 \
    --clump-kb 250 \
    --clump TPMI_CAD_PRS/TPMI_CAD_gwas_merge.Transformed \
    --clump-snp-field SNP \
    --clump-field P \
    --out CAD_PRS

awk 'NR!=1{print $3}' CAD_PRS.clumped > CAD_PRS.valid.snp
awk '{print $3,$13}' TPMI_CAD_PRS/TPMI_CAD_gwas_merge.Transformed > TPMI_CAD_base.SNP.pvalue
awk '!seen[$3]++' TPMI_CAD_PRS/TPMI_CAD_gwas_merge.Transformed > TPMI_CAD_PRS/TPMI_CAD_gwas_merge.Transformed.clean
sort CAD_PRS.valid.snp | uniq -u > CAD_PRS.valid.snp.clean
awk '!seen[$1]++' TPMI_CAD_base.SNP.pvalue > TPMI_CAD_base.SNP.pvalue.clean


plink \
    --bfile CAD_PRS/TAICHI_CAD \
    --pheno CAD_PRS/TAICHI_CAD.txt --pheno-name CAD \
    --allow-no-sex \
    --score TPMI_CAD_PRS/TPMI_CAD_gwas_merge.Transformed.clean 3 6 15 header sum \
    --q-score-range range_list TPMI_CAD_base.SNP.pvalue.clean \
    --extract CAD_PRS.valid.snp.clean \
    --out V_TPMI_CAD_PRS

```

		 - 
```bash
#CKD
plink \
    --bfile impute_postqc_merge_rsid \
    --pheno V_CKD.cov --pheno-name caco \
    --allow-no-sex \
    --clump-p1 1 \
    --clump-r2 0.1 \
    --clump-kb 250 \
    --clump /data4/TPMI_GWAS/GWAS_TWB2.0/TPMI_imputation/imputation/TPMI_CKD_PRS/TPMI_CKD_QC.Transformed \
    --clump-snp-field SNP \
    --clump-field P \
    --out V_TPMI_CKD

awk 'NR!=1{print $3}' V_TPMI_CKD.clumped > V_TPMI_CKD.valid.snp
awk '{print $3,$13}' /data4/TPMI_GWAS/GWAS_TWB2.0/TPMI_imputation/imputation/TPMI_CKD_PRS/TPMI_CKD_QC.Transformed > TPMI_CKD.SNP.pvalue
awk '!seen[$3]++' TPMI_CKD_QC.Transformed > TPMI_CKD_QC.Transformed.clean
sort V_TPMI_CKD.valid.snp | uniq -u > V_TPMI_CKD.valid.snp.clean
awk '!seen[$1]++' TPMI_CKD.SNP.pvalue > TPMI_CKD.SNP.pvalue.clean

plink2 --bfile impute_postqc_merge_rsid --keep V_CKD.cov --maf 0.01 --hwe 0.00001 --geno 0.05 --make-bed --out V_CKD_target
plink \
    --bfile V_CKD_target \
    --pheno V_CKD.cov --pheno-name caco \
    --allow-no-sex \
    --score /data4/TPMI_GWAS/GWAS_TWB2.0/TPMI_imputation/imputation/TPMI_CKD_PRS/TPMI_CKD_QC.Transformed.clean 3 6 15 header sum \
    --q-score-range range_list TPMI_CKD.SNP.pvalue.clean \
    --extract V_TPMI_CKD.valid.snp \
    --out V_TPMI_CKD_PRS

```

		 - 
```bash
#NUR
plink \
    --bfile impute_postqc_merge_rsid \
    --pheno V_NUR.cov --pheno-name caco \
    --allow-no-sex \
    --clump-p1 1 \
    --clump-r2 0.1 \
    --clump-kb 250 \
    --clump /data4/TPMI_GWAS/GWAS_TWB2.0/TPMI_imputation/imputation/TPMI_NUR_PRS/TPMI_NUR_QC.Transformed \
    --clump-snp-field SNP \
    --clump-field P \
    --out V_TPMI_NUR

awk 'NR!=1{print $3}' V_TPMI_NUR.clumped > V_TPMI_NUR.valid.snp
awk '{print $3,$13}' /data4/TPMI_GWAS/GWAS_TWB2.0/TPMI_imputation/imputation/TPMI_NUR_PRS/TPMI_NUR_QC.Transformed > TPMI_NUR.SNP.pvalue
awk '!seen[$3]++' TPMI_NUR_QC.Transformed > TPMI_NUR_QC.Transformed.clean
sort V_TPMI_NUR.valid.snp | uniq -u > V_TPMI_NUR.valid.snp.clean
awk '!seen[$1]++' TPMI_NUR.SNP.pvalue > TPMI_NUR.SNP.pvalue.clean

plink2 --bfile impute_postqc_merge_rsid --keep V_NUR.cov --maf 0.01 --hwe 0.00001 --geno 0.05 --make-bed --out V_NUR_target
plink \
    --bfile V_NUR_target \
    --pheno V_NUR.cov --pheno-name caco \
    --allow-no-sex \
    --score /data4/TPMI_GWAS/GWAS_TWB2.0/TPMI_imputation/imputation/TPMI_NUR_PRS/TPMI_NUR_QC.Transformed.clean 3 6 15 header sum \
    --q-score-range range_list TPMI_NUR.SNP.pvalue.clean \
    --extract V_TPMI_NUR.valid.snp \
    --out V_TPMI_NUR_PRS

echo "0.00001 0 0.00001" > range_list 
echo "0.00005 0 0.00005" >> range_list
echo "0.0001 0 0.0001" >> range_list
echo "0.0005 0 0.0005" >> range_list
echo "0.001 0 0.001" >> range_list

plink \
    --bfile TPMI_41SNP_DM_target \
    --allow-no-sex \
    --score TUDR_SNP_base.41.Transformed 1 4 8 header \
    --q-score-range range_list TPMI_PDR_41.SNP \
    --extract TPMI_PDR_41.SNP \
    --out TPMI_41SNP_DM_PRS

plink \
    --bfile impute_postqc_merge_rsid \
    --pheno V_NUR.cov --pheno-name caco \
    --allow-no-sex \
    --score TPMI_PDR_base.QC.Transformed.clean 3 6 15 header \
    --q-score-range range_list TPMI_PDR_base.SNP.pvalue_clean \
    --extract TUDR_V_TPMI.valid.snp \
    --out TUDR_V_TPMI

plink \
    --bfile TUDR_V_target \
    --pheno TUDR_V_target.cov --pheno-name caco \
    --allow-no-sex \
    --score V_PDR_base.QC.Transformed 3 6 15 header \
    --q-score-range range_list V_PDR_base.SNP.pvalue \
    --extract TUDR_V_V.valid.snp \
    --out TUDR_V_V

plink \
    --bfile TUDR_V_target \
    --pheno TUDR_V_target.cov --pheno-name caco \
    --allow-no-sex \
    --score TUDR_PDR_base.QC.Transformed 3 6 15 header \
    --q-score-range range_list TUDR_PDR_base.SNP.pvalue \
    --extract TUDR_V_TUDR.valid.snp \
    --out TUDR_V_TUDR

plink \
    --bfile V_PDR_target \
    --pheno V_PDR.cov --pheno-name caco \
    --allow-no-sex \
    --score TUDR_PDR_base.QC.Transformed 3 6 15 header \
    --q-score-range range_list TUDR_PDR_base.SNP.pvalue \
    --extract TUDR_V_TUDR.valid.snp \
    --out V_PDR_target_prs

```

		 - 
```bash
#TUDR 41 SNPs

awk '{print $1}' TUDR_SNP_base.41.Transformed > TPMI_PDR_41.SNP

plink \
    --bfile V_PDR_target \
    --pheno V_PDR.cov --pheno-name caco \
    --allow-no-sex \
    --score TUDR_SNP_base.41.Transformed 1 4 8 header sum\
    --extract TPMI_PDR_41.SNP \
    --out TUDR_V_41_prs_sum

sudo yum install docker-ce-20.10.9 docker-ce-cli-20.10.9 containerd.io

plink2 --bfile impute_postqc_merge_rsid --keep V_PDR.cov --maf 0.01 --hwe 0.00001 --geno 0.05 --make-bed --out V_PDR_target

for i in {2,3,4,8,9,11,14}
do
echo TPMI_CKD_sig_chr$i >> mergelist.txt
done

plink --merge-list mergelist.txt --make-bed --out TPMI_CKD_sig
plink \
    --bfile TPMI_CKD_sig \
    --pheno TPMI_CKD.txt --pheno-name caco \
    --allow-no-sex \
    --score TPMI_CKD_sig.bim 2 5 sum \
    --out TPMI_CKD_sig

plink --bfile TPMI_PDR_target_chr1 --merge-list mergelist.txt --make-bed --out TPMI_PDR_target_merge
plink --bfile TPMI_PDR_target_chr2 --flip TPMI_PDR_target_chr2and13-merge.missnp.nodup --make-bed --out TPMI_PDR_target_merge_chr2
sort TPMI_PDR_target_chr2and13-merge.missnp | uniq -u > TPMI_PDR_target_chr2and13-merge.missnp.nodup
cut -f 2 TPMI_PDR_target_chr2.bim | sort | uniq -d > chr2.dups
cut -f 2 TPMI_PDR_target_chr13.bim | sort | uniq -d > chr13.dups

plink --bfile TPMI_PDR_target_chr2  --exclude chr2.dups --make-bed --out TPMI_PDR_target_chr2_nodup
plink --bfile TPMI_PDR_target_chr13  --exclude chr13.dups --make-bed --out TPMI_PDR_target_chr13_nodup

plink --bfile TPMI_PDR_target_chr2_nodup --bmerge TPMI_PDR_target_chr13_nodup --make-bed --out TPMI_PDR_target_chr2and13-merge

plink \
    --bfile ./TPMI_PDR_imputed/TPMI_PDR_target_chr2and13-merge \
    --pheno TPMI_PDR.cov --pheno-name caco \
    --allow-no-sex \
    --score ./TPMI_PDR_imputed/TUDR_SNP_base.41.Transformed 1 4 8 header sum\
    --extract ./TPMI_PDR_imputed/TPMI_PDR_41.SNP \
    --out ./TPMI_PDR_imputed/TPMI_PDR_TUDR41_target_sum

```

- 

- 照chromosome順序合併檔案
	 - 
```bash
**echo "$(ls *_chr*.txt | sort -V | grep -vP 'chr[^X|Y|\d]'; ls *_chr*.txt | sort -V | grep -vP 'chr[\d|X|Y]')" | xargs cat > GSA_DM_CKD_pst_eff_a1_b0.5_phi1e-04.txt
echo "$(ls *_apt_advnorm.bed)" > TPMI_B1toB30_merge.txt**

```

- PRScs PLINK score
	 - 
```bash
plink --bfile GSA_DM_CKD_validate_clean --pheno GSA_DM_CKD_validate.txt --score ./PRScs_output/GSA_DM_CKD_pst_eff_a1_b0.5_phi1e-04.txt 2 4 6 header sum --out GSA_DM_CKD_validate_PRScs

```

- 

- 

- plink2 extract chrM
	 - 
```bash
plink --vcf AxiomGT1_norm.vcf --update-name ../../../../TPMI_var_id_change.txt --update-ids ../../../../TPMI_samplename_change_A797_202211.txt --output-chr chrM --double-id --impute-sex --make-bed --out NCGM_0928_000202
plink2 --bfile NCGM_0928_000202/vcf/NCGM_0928_000202 --update-name /data4/TPMI_GWAS/TPMI_data_all_adjusted/TPMI_var_id_change.txt --update-ids /data4/TPMI_GWAS/TPMI_data_all_adjusted/TPMI_samplename_change_A797_202211.txt --chr 26 --output-chr chrMT --make-bed --out chrMT/NCGM_0928_000202_chrMT
plink2 --bfile B0018_20220624_20221116/vcf/B0018_20220624_20221116 --update-name /data4/TPMI_GWAS/TPMI_data_all_adjusted/TPMI_var_id_change.txt --update-ids /data4/TPMI_GWAS/TPMI_data_all_adjusted/TPMI_samplename_change_A797_202211.txt --chr 26 --output-chr chrMT --make-bed --out chrMT/B0018_20220624_20221116_chrMT

```

- vcf to plink & update var id
	 - 
```bash
plink --vcf AxiomGT1.norm.vcf.gz --double-id --impute-sex --make-bed --out NCGM-0928-000195
plink --bfile B0001_20200117_20200406 --merge-list files.txt --make-bed --out TPMI_b1tob22_APT
plink --bfile TPMI_NCGM_b1_temp1 --update-name TPMI_var_id_change.txt --make-bed --out TPMI_NCGM_b1
plink --bfile TPMI_NCGM_b1_temp1 --update-ids TPMI_samplename_change_A433_20210129.txt --make-bed --out TPMI_NCGM_b1

```

- plink Extract a subset of individuals
	 - 
```bash
plink --tfile NCGM-0928-000195 --keep TPMI_b1_test.txt --recode transpose --out TPMI_b1_test
plink --bfile NCGM-0928-000195 --keep TPMI_b1_test.txt --recode vcf-iid --out TPMI_OUTPUT

```

- plink logistic model with Alternate cov and phe
	 - 
```bash
plink --bfile TPMI_SLE_GWAS --covar SLE_caco.cov --covar-name sex,age --pheno SLE_caco.cov --pheno-name SLE --logistic --maf 0.05 --hwe 0.001 --geno 0.05 --adjust --out SLE_caco_clean
plink --bfile SLE_base_cleaned --covar SLE_base_cov.cov --covar-name sex,age --pheno SLE_base_cov.cov --pheno-name SLE --logistic --maf 0.01 --hwe 0.001 --geno 0.05 --adjust --out SLE_base_clean
plink --bfile SLE_target_cleaned chr 1-22 --covar SLE_target_cov.cov --covar-name sex,age --pheno SLE_target_cov.cov --pheno-name SLE --logistic --maf 0.01 --hwe 0.001 --geno 0.05 --adjust --out SLE_target_clean
plink2 --bfile impute_postqc_merge_rsid --covar V_PDR_train.cov --covar-name sex,age --pheno V_PDR_train.cov --pheno-name caco --glm hide-covar --maf 0.01 --hwe 0.001 --geno 0.05 --out V_PDR_train 
plink2 --bfile TPMI_58K_VGHTC_breast_cancer --covar TPMI_breast_cancer.cov --covar-name age --pheno TPMI_breast_cancer.cov --pheno-name breast_cancer --glm hide-covar --maf 0.01 --hwe 0.00001 --geno 0.05 --out breast_cancer 
plink2 --vcf TPMI_RA_caco_202306.vcf --maf 0.01 --hwe 0.00001 --geno 0.05 --export vcf-4.2 id-paste=iid --out TPMI_RA_caco_202306_qc

```

- plink normalize left align
	 - 1: normalize:
		 - 
```bash
bcftools norm -m-any x.vcf -Ov > Norm.vcf

```

	 - 2: left align:
		 - 
```bash
bcftools norm -f genome.fa -o Norm.Aligned.vcf Norm.vcf

```

	 - 3: Then in plink/1.9:
		 - 
```bash
plink --vcf Norm.Aligned.vcf --make-bed --out binary --allow-no-sex

```

- 取代檔案中文字
	 - 
```bash
sed -i 's/_TWB2.CEL//g' TPMI_b1tob33_all_chrMT.fam
sed -i 's/_TPM.CEL//g' TPMI_b1tob33_all_chrMT.fam
sed -i 's/.CEL//g' TPMI_b1tob33_all_chrMT.fam
sed -i 's/_TWB2.CEL//g' NCGM_0928_000195.fam
sed -i 's/_TPM.CEL//g' NCGM_0928_000195.fam
sed -i 's/.CEL//g' NCGM_0928_000195.fam
sed -i 's/_TWB2.CEL//g' NCGM_0928_000296.fam
sed -i 's/_TPM.CEL//g' NCGM_0928_000296.fam
sed -i 's/.CEL//g' NCGM_0928_000296.fam
sed -i 's/_TWB2.CEL//g' B0014_20210729_20211007_apt_advnorm.fam
sed -i 's/_TPM.CEL//g' B0014_20210729_20211007_apt_advnorm.fam
sed -i 's/.CEL//g' B0014_20210729_20211007_apt_advnorm.fam
sed -i 's/_TWB2.CEL//g' TTPC_0001.fam
sed -i 's/_TPM.CEL//g' TTPC_0001.fam
sed -i 's/.CEL//g' TTPC_0001.fam

```
