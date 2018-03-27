
.libPaths()

.libPaths("~/.conda/envs/qiime2_workshop/lib/R/library/")

.libPaths()

getwd()

# Change to our data directory. 
# setwd("$WORK/qiime2-tut/phyloseq_db") # replace $WORK with the full path
# getwd() # Check again

# list all the files under our data directoy
list.files()

# Load required packages
library(phyloseq)
#library(ggplot2)
library(tidyverse)
#library(vegan)

# Show the help documentation for the function import_qiime()
?import_qiime

?plot_bar

?import_qiime

# Prepare file paths
baseDir <- getwd() #make sure you are in the right directory
otufile <- paste(baseDir, "table-with-taxonomy.tsv", sep = "/")
mapfile <- paste(baseDir, "soil-metadata.tsv", sep = "/")
treefile <- paste(baseDir, "tree.nwk", sep = "/")
refseqfile <- paste(baseDir, "dna-sequences.fasta", sep = "/")

otufile

# Create a phyloseq object using import_qiime() function
myData <- import_qiime(otufile, mapfile, treefile, refseqfile)

myData

tax_table(myData) %>% head()

sample_data(myData) %>% count(Type)

get_variable(myData, "Type") %>% unique()

any(sample_sums(myData) == 0)
sum(sample_sums(myData) == 0)

prune_samples(sample_sums(myData) == 0, myData) %>% sample_names()

any(taxa_sums(myData) == 1)
sum(taxa_sums(myData) == 1)

prune_taxa(taxa_sums(myData) == 1, myData) %>% tax_table()

# combine your phyloseq object into a dataframe, so you can 
# use it to make graphics with ggplot2.
myDataMdf <- psmelt(myData)

myDataMdf %>% head()

# Create a two-column dataframe
myDataSDT = data.frame(TotalReads = sort(sample_sums(myData), TRUE), 
                       sorted = 1:nsamples(myData))

myDataSDT %>% head()

myDataSDT %>% summarise(TotalReads = sum(TotalReads))

# Create a bar plot to show the sequence depth
ggplot(myDataSDT, aes(x = sorted, y = TotalReads)) + 
    geom_bar(color = "red", stat = "identity")

ggplot(myDataSDT, aes(TotalReads)) + geom_histogram(binwidth = 20)

myDataTTC = data.frame(nreads = sort(taxa_sums(myData), TRUE), 
                       sorted = 1:ntaxa(myData))

myDataTTC %>% head()

myDataTTC %>% summarise(TotalReads = sum(nreads))

title = "Total number of reads"
ggplot(myDataTTC, aes(x = sorted, y = nreads)) + 
    geom_bar(color = "red", stat = "identity", title = title)

myDataPRE <- apply(otu_table(myData),
               MARGIN = 1, # rows
               FUN = function(x){sum(x > 0)})
head(myDataPRE)

myDataPRE <- data.frame(Prevalence = myDataPRE, 
                    TotalCounts = taxa_sums(myData), 
                    tax_table(myData))
head(myDataPRE)

ggplot(myDataPRE, aes(Prevalence)) + geom_histogram()

ggplot(myDataPRE, aes(Prevalence, TotalCounts)) + geom_point(alpha = 0.3) + scale_y_log10() + scale_x_log10()

# Get the most abundance 5 phyla, and then redo the scatter plot
nPhylum <- 5
#myDataPRE %>% 
#    group_by(Phylum) %>% 
#    summarise(n = n()) %>% 
#    arrange(desc(n))

top5Phylum <- myDataPRE %>% 
    group_by(Phylum) %>% 
    summarise(n = n()) %>% 
    arrange(desc(n)) %>% 
    top_n(nPhylum, n) %>%
    pull(Phylum)
top5Phylum

myDataPRE_TOP5 <- myDataPRE %>%
    filter(Phylum %in% top5Phylum)
myDataPRE_TOP5

ggplot(myDataPRE_TOP5, aes(Prevalence, TotalCounts, color = Phylum)) + geom_point(alpha = 0.3) + scale_y_log10() + xlim(0,20)

# plot_bar
plot_bar(myData, x = "Phylum", fill = "Phylum", facet_grid = ~Type)

plot_bar(myData, x = "Phylum", fill = "Phylum", facet_grid = ~Type) +
    geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack")

# Plot particular Phylum
myDataPhylum <- subset_taxa(myData, Phylum == "Acidobacteria")

plot_bar(myDataPhylum, x = "Family", fill = "Family", facet_grid = ~Type) +
    geom_bar(aes(color = Family, fill = Family), stat = "identity", position = "stack")

# Plot the top 5
myDataTop5 <- subset_taxa(myData, Phylum %in% top5Phylum)

plot_bar(myDataTop5, x = "Type", fill = "Phylum", facet_grid = ~Phylum) +
    geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack")

# Plot the relative abundance
myDataRtemp <- transform_sample_counts(myDataTop5, function(x) x / sum(x) )

plot_bar(myDataRtemp, x = "Sample", fill = "Phylum") +
    geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack")

phyRemoved <- c("", "OD1", "OP3", "SC4", "TM6", "TM7", "WS3", "Proteobacteria")
myDataTopRemoved <- subset_taxa(myData, !is.na(Phylum) & !(Phylum %in% phyRemoved))

myDataTopRemoved <- subset_samples(myDataTopRemoved, Type == "bulk soil")

myDataTopRemoved <- subset_samples(myDataTopRemoved, sample_sums(myDataTopRemoved) > 0)

myDataTopRemoved

myDataTopRemoved.RT <- transform_sample_counts(myDataTopRemoved, function(x) x / sum(x) )

plot_bar(myDataTopRemoved.RT, x = "Sample", fill = "Phylum") +
    geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack")

plot_bar(myDataTopRemoved.RT, x = "Sample", fill = "Phylum", ) +
    geom_bar(aes(color = Phylum, fill = Phylum), stat = "identity", position = "stack") +
    labs(title = "Relative abundance", subtitle = "Figure x:", x = "Sample (bulk soil)", y = "Relative abundance") +
    coord_flip() +
    theme_classic()

?plot_richness

# indices <- c("Observed", "Chao1", "ACE", "Shannon", "Simpson", "InvSimpson", "Fisher")
indices <- c("Observed", "Chao1", "Shannon")
plot_richness(myData, x= "Type", color = "Type", measures = indices) +
    geom_boxplot(aes(fill = Type), alpha = 0.2)

p <- plot_richness(myData, x = "Type", color = "Type", measures = indices) +
    geom_jitter(aes(color = Type), alpha = 0.5, size = 2)

p$layers

p$layers <- p$layers[-(1:2)]

p$layers

p + geom_boxplot(aes(fill = Type), alpha = 0.3)

plot_richness(myData, x= "NitrogenLevel", color = "NitrogenLevel", measures = indices) +
    geom_boxplot(aes(fill = NitrogenLevel),alpha = 0.2)

#get the information 
alphaDiversity <- estimate_richness(myData, measures = indices)

alphaDiversity %>% rownames_to_column() %>% arrange(desc(Observed)) %>% head()

# Check the distribution
par(mfrow = c(2, 2))
hist(alphaDiversity$Chao1, main = "Chao richness", xlab = "", breaks = 20)
hist(alphaDiversity$Shannon, main = "Shannon diversity", xlab = "", breaks = 20)
qqnorm(alphaDiversity$Chao1, main = "Chao: Normal Q-Q Plot")
qqline(alphaDiversity$Chao1, col = 2)
qqnorm(alphaDiversity$Shannon, main = "Shannon: Normal Q-Q Plot")
qqline(alphaDiversity$Shannon, col = 3)

#Normality test using Shapiro-Wilk’s test
shapiro.test(alphaDiversity$Chao1)
shapiro.test(alphaDiversity$Shannon)

# run Kruskal-Wallis test
alphaDiversity.Sample <- alphaDiversity %>% 
    rownames_to_column() %>%
    left_join(sample_data(myData), by = c("rowname" = "X.SampleID")) 

head(alphaDiversity.Sample)

alphaDiversity.Sample %>%
    kruskal.test(Chao1 ~ Type, data=.)

alphaDiversity.Sample %>%
    kruskal.test(Shannon ~ Type, data=.)

# Multiple pairwise-comparison between groups
pairwise.wilcox.test(alphaDiversity.Sample$Chao1, alphaDiversity.Sample$Type, p.adjust.method = "BH")
pairwise.wilcox.test(alphaDiversity.Sample$Shannon, alphaDiversity.Sample$Type, p.adjust.method = "BH")

# ANOVA
aovChao <- alphaDiversity.Sample %>%
    aov(Chao1 ~ Type, .)
aovShannon <- alphaDiversity.Sample %>%
    aov(Shannon ~ Type, .)
summary(aovChao)
summary(aovShannon)

TukeyHSD(aovChao)
TukeyHSD(aovShannon)

?plot_ordination

# Filtering
myData.2 <- prune_samples(sample_sums(myData) > 0, myData)
phyRemoved <- c("", "OD1", "OP3", "SC4", "TM6", "TM7", "WS3")
myData.2 <- subset_taxa(myData.2, !is.na(Phylum) & !Phylum %in% phyRemoved)
myData.2

myData.2.t <- transform_sample_counts(myData.2, function(x) x / sum(x) )
myData.2.ft <- filter_taxa(myData.2.t, function(x) var(x) > 1e-5, TRUE)

myData.2.ft

myData.2.ft.ord <- ordinate(myData.2.ft, method = "NMDS", distance = "bray")

# Samples
plot_ordination(myData.2.ft, myData.2.ft.ord, type = "samples", color="Type")

myData.2.ft.wuf <- ordinate(myData.2.ft, method = "PCoA", distance ="wunifrac")

plot_ordination(myData.2.ft, myData.2.ft.wuf, color = "Type")

plot_ordination(myData.2.ft, myData.2.ft.wuf, color = "Type") + 
    stat_ellipse(type = "norm", linetype = 2) +
    theme_bw()

plot_tree(myData.2.ft)

myData.2.ft.g = tax_glom(myData.2.ft, "Phylum")
myData.2.ft.g

plot_tree(myData.2.ft.g, color = "Type", shape = "Phylum", ladderize = "left", justify = "left", label.tips = "Phylum")
