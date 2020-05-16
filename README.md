# EDMFrame

EDMframe is an open source framework for efficient edge data management strategies. It consists of (1) a novel semi-automatic mechanism for recovery of incomplete time series, managing a recovery cycle that ensures detection and forecasting of each gap; (2) an edge storage management mechanism keeping only necessary amount of data for predictive analytics; (3) a mediator component that finds a trade-off between gap size and necessary range of historical data based on projection recovery maps. Preliminary results for (1) and (2) are shown in [1] and [2]. The latest version includes new features such as the mediator component, showing a complete data path through the EDMFrame. The complete resilient edge data management framework will be published in the IEEE Transactions on Services Computing [3].

The current EDMFrame is developed in R programming language and requires additional packages such as: readr, tseries, forecast, extrafont, readxl, pryrm, zoo.

DATA
--
The proposed algorithms are evaluated on sensor-based time series data coming from real-world IoT systems, namely:
* Smart homes - containing traces from the Smart* project (S. Barker, A. Mishra, D. Irwin, E. Cecchet, P. Shenoy, and J. Albrecht,
“Smart*: An open data set and tools for enabling research in sustainable homes,” SustKDD, August, vol. 111, p. 112, 2012.) for optimization of energy consumption smart homes design, obtained by UMass Trace Repository (http://traces.cs.umass.edu/).
* Smart buildings - containing various measurements coming from the monitoring system of Austria’s largest Plus-Energy Office High-Rise Building.

ACKNOWLEDGMENTS 
--
The work described in this article has been funded through Rucon project (Runtime Control in Multi Clouds), FWF Y 904 START-Programm 2015 and supported with Ivan Lujic's netidee scholarship by the Internet Foundation Austria. The authors would like to thank staff at TU Wien's Plus-Energy Office High-Rise Building, especially to Thomas Bednar and Alexander David on valuable discussions and the Federal Real Estate Company (BIG) for providing data sources.

CITATION
--
- [1] Lujic, Ivan, Vincenzo De Maio, and Ivona Brandic. "Adaptive recovery of incomplete datasets for edge analytics." 2018 IEEE 2nd International Conference on Fog and Edge Computing (ICFEC). IEEE, 2018.
- [2] Lujic, Ivan, Vincenzo De Maio, and Ivona Brandic. "Efficient edge storage management based on near real-time forecasts." 2017 IEEE 1st International Conference on Fog and Edge Computing (ICFEC). IEEE, 2017.
- [3] Lujic, Ivan, Vincenzo De Maio, and Ivona Brandic. "Resilient Edge Data Management Framework." IEEE Transactions on Services Computing (2019).

*******************************************************************
This repository is consisted of the following separated .R files:

- **fill_gaps_original.R** - aims to to remove potential outliers and reconstruct incomplete data sets. It contains an automated function that automatically recovers multiple gaps within the dataset.
- **b_1_data_recovery_mechanism.R** - represents data recovery mechanism including call of fill_gaps().
- **FindStableClusters.R** - aims to find stable clusters of forecast accuracies.
- **FindAppropriateCluster.R** - aims to find an appropriate cluster that satisfies the requested threshold taking as few data as possible contained in stable clusters.
- **b_1_edge_storage_management.R** - the adaptive algorithm that implements design principles for edge storage management including function calls of prior functions: FindStableClusters and FindAppropriateCluster.
- **b_1_PRM.R** - represents data recovery mechanism based on projection recovery maps (PRM).
- **fill_gaps_MTR_based_on_PRM.R** - data recovery procedure using multiple technique recovery (MTR) scenario.
- **fill_gaps_STR.R** - data recovery procedure using single technique recovery (STR) scenario.
- **Mediator_FindAppropriateCluster.R** - finding appropriate cluster based on PRM.
- **Mediator_FindStableClusters.R** - finding stable clusters based on PRM.
- **PRM_calculation_b_1.R** - calculating PRM for selected dataset.

*******************************************************************
Diese Arbeit wurde mit einem netidee Stipendium gefördert.  
This work was supported with a netidee scholarship.  

![Image of netidee](https://www.netidee.at/themes/Netidee/images/netidee-logo-color.svg)

*******************************************************************
