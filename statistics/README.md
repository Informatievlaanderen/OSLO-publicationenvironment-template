# template for generated repository
This directory contains the template for calculating statistics on the generated repository.

Publication owners should configure this and maintain the files in this directory as part of the publication flow activities.

It contains a CIRCLECI flow that will execute the scripts in the directory report when a commit has happend to the generated repository.

## Setup instructions

1. create a new repository generated-statistics
2. create a deploy key and make that the CIRCLECI on generated repository can commit on the generated-statistics repository.
   For detailed instructions on GitHub deploy key creation and management, consult the setup information of this repository.
3. adapt the config.yml file in the directory circleci to include the fingerprints
4. adapt the statistics/config.json file with the statistics repository and git user information
5. activate CIRCLECI on the generated repository


## Test instructions

1. publish a new application profile (or any action that results in a change of a specification and results in an updated statistics).
2. after the finalisation of the CIRCLECI flow on this commit, a followup CIRCLECI should happen on the generated-repository 


## TODO

- test the CIRCLECI configuration and deployment instructions for private statistics repository
- do not copy intermediate files of the aggregated statistics
- (feature) create a evolution statistics: 
     - difference compared last month 
     - difference compared last 12 months (a year back in time)
