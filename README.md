# EDMFrame

EDMframe is an open source framework for efficient edge data management strategies. Preliminary results are shown in [1] and [2]. The current version is upgraded and includes new features such as the mediator process managed projection recovery maps to support
efficient data recovery. 

The current EDMFrame is developed in R programming language and requires additional packages such as: readr, tseries, forecast, extrafont, readxl, pryrm, zoo.

CITATION:
[1] I. Lujic, V. De Maio and I. Brandic, "Adaptive Recovery of Incomplete Datasets for Edge Analytics," 2018 IEEE 2nd International Conference on Fog and Edge Computing (ICFEC), Washington, DC, 2018, pp. 1-10.
[2] I. Lujic, V. D. Maio and I. Brandic, "Efficient Edge Storage Management Based on Near Real-Time Forecasts," 2017 IEEE 1st International Conference on Fog and Edge Computing (ICFEC), Madrid, 2017, pp. 21-30.

DATA:
The proposed algorithms are evaluated on sensor-based time series data coming from real-world IoT systems, namely:
* Smart homes - it contains traces from the Smart* project (S. Barker, A. Mishra, D. Irwin, E. Cecchet, P. Shenoy, and J. Albrecht,
“Smart*: An open data set and tools for enabling research in sustainable homes,” SustKDD, August, vol. 111, p. 112, 2012.) for optimization of energy consumption smart homes design, obtained by UMass Trace Repository (http://traces.cs.umass.edu/).
* Smart buildings - it contains various measurements coming from the monitoring system of Austria’s largest Plus-Energy Office High-Rise Building.

ACKNOWLEDGMENTS 
The work described in this article has been funded through a netidee scholarship by the Internet Foundation Austria and Rucon project (Runtime Control in Multi Clouds), FWF Y 904 START-Programm 2015. The authors would like to thank all stuff members at TU Wien's Plus-Energy Office High-Rise Building and the Federal Real Estate Company (BIG) for providing data sources.
