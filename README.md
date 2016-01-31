# README: Getting and Cleaning Data Course Project

## Overview
This repo contains a single function (`summarize_health_data`), found in
the `run_analysis.R` file. This function takes a single argument with is
a path to the 
[UCI Health Data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
, relative to the current working directory.

It will return a summary of the UCI Health Data that only includes mean and
standard deviation observations, summarized by subject and activity type.
See the `codebook.txt` for further details.

## Dependencies
The `summarize_health_data` function relies on the
[dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
package. Please make sure you have this package installed prior to running
code from this project to avoid errors.
