# README
Didier Brassard
2025-01-23

- [Introduction](#introduction)
- [Quick links](#quick-links)
- [Codes](#codes)
- [Acknowledgement](#acknowledgement)
- [References](#references)
- [Session Info](#session-info)

# Introduction

This repository includes the material to reproduce the manuscript of:
*Estimating the Effect of Adhering to the Recommendations of the 2019
Canada’s Food Guide on Health Outcomes in Older Adults: Protocol for a
Target Trial Emulation*

The raw data used for this project were obtained from [Health Canada
(2022)](https://open.canada.ca/data/en/info/0490749d-b0b0-410a-9577-a903c6cec2be).

# Quick links

- [**JMIR Research Protocol\***: official
  article](http://dx.doi.org/10.2196/65182)
- [**medRxiv**: Pre-print version of the
  study](https://doi.org/10.1101/2024.05.29.24308054)
- [**GitHub**: Main article (code, text, figures and
  tables)](https://didierbrassard.github.io/NuAge_protocol/9.1-Manuscript.html)
- [**GitHub**: Supplemental
  material](https://didierbrassard.github.io/NuAge_protocol/9.2-Supplement.html)

> \*Suggested citation: Brassard D, Presse N, Chevalier S. Estimating
> the Effect of Adhering to the Recommendations of the 2019 Canada’s
> Food Guide on Health Outcomes in Older Adults: Protocol for a Target
> Trial Emulation. JMIR Res Protoc 2025;14:e65182.
> [doi:10.2196/65182](http://dx.doi.org/10.2196/65182)

# Codes

<div id="jbygqjuoxb" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
  &#10;  

| Description of R and QMD codes |                                                                                 |        |                                                |
|--------------------------------|---------------------------------------------------------------------------------|--------|------------------------------------------------|
| Name                           | Description                                                                     | Time   | Link                                           |
| 1.0-Data_preparation.R         | Raw data cleaning and processing to generate Health Canada diet simulation data | \<1min | <a href="1.0-Data_preparation.R">Open code</a> |
| 9.1-Manuscript.qmd             | Quarto document used to generate the text, figures and tables of the protocol   | \<1min | <a href="9.1-Manuscript.qmd">Open code</a>     |
| 9.2-Supplement.qmd             | Quarto document used to generate the supplemental material of the protocol      | \<1min | <a href="9.2-Supplement.qmd">Open code</a>     |

</div>

# Acknowledgement

This project is supported by a [Canadian Institute of Health Research
Fellowship to Didier Brassard
(MFE-181852)](https://webapps.cihr-irsc.gc.ca/decisions/p/project_details.html?applId=455011&lang=en).

The general set-up and folder tree of this project is based on work by
Figueiredo, Scherer, and Cabral (2022).

# References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-figueiredo2022" class="csl-entry">

Figueiredo, L., C. Scherer, and J. S. Cabral. 2022. “A Simple Kit to Use
Computational Notebooks for More Openness, Reproducibility, and
Productivity in Research.” Journal Article. *PLoS Comput Biol* 18 (9):
e1010356. <https://doi.org/10.1371/journal.pcbi.1010356>.

</div>

<div id="ref-healthcanada2022" class="csl-entry">

Health Canada. 2022. “Simulated Composite Diets.” Government Document.
Open Government Portal.
<https://open.canada.ca/data/en/dataset/0490749d-b0b0-410a-9577-a903c6cec2be>.

</div>

</div>

# Session Info

<details>
<summary>
Expand for details
</summary>

    [1] "2025-01-23 10:35:00 EST"

    R version 4.3.1 (2023-06-16)
    Platform: x86_64-apple-darwin20 (64-bit)
    Running under: macOS Sonoma 14.7.1

    Matrix products: default
    BLAS:   /Library/Frameworks/R.framework/Versions/4.3-x86_64/Resources/lib/libRblas.0.dylib 
    LAPACK: /Library/Frameworks/R.framework/Versions/4.3-x86_64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0

    locale:
    [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

    time zone: America/Toronto
    tzcode source: internal

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    other attached packages:
    [1] ggtext_0.1.2      ggflowchart_1.0.0 ggplot2_3.5.1     gt_0.11.1        
    [5] purrr_1.0.2       tidyr_1.3.1       dplyr_1.1.4      

    loaded via a namespace (and not attached):
     [1] gtable_0.3.6      jsonlite_1.8.9    compiler_4.3.1    tidyselect_1.2.1 
     [5] Rcpp_1.0.13-1     xml2_1.3.6        scales_1.3.0      yaml_2.3.10      
     [9] fastmap_1.2.0     here_1.0.1        R6_2.5.1          commonmark_1.9.2 
    [13] generics_0.1.3    knitr_1.49        tibble_3.2.1      rprojroot_2.0.4  
    [17] munsell_0.5.1     pillar_1.9.0      rlang_1.1.4       utf8_1.2.4       
    [21] xfun_0.49         sass_0.4.9        cli_3.6.3         withr_3.0.2      
    [25] magrittr_2.0.3    digest_0.6.37     grid_4.3.1        gridtext_0.1.5   
    [29] rstudioapi_0.17.1 markdown_1.13     base64enc_0.1-3   lifecycle_1.0.4  
    [33] vctrs_0.6.5       evaluate_1.0.1    glue_1.8.0        fansi_1.0.6      
    [37] colorspace_2.1-1  rmarkdown_2.29    tools_4.3.1       pkgconfig_2.0.3  
    [41] htmltools_0.5.8.1

</details>
