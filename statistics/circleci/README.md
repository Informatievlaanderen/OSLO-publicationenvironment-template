# Continuous Integration / Continuous Deployment setup.

The used CI/CD environment is [CIRCLECI](https://circleci.com).

Generic documentation about the configuration language and the possibilities of CircleCI can be found [here](https://circleci.com/docs/).

## The statistics CI/CD
This CI/CD is the source code for calculating the statistics. It is developed as a chained workflow. 
When writing into the generated repository, the step https://github.com/Informatievlaanderen/OSLO-publicationenvironment-template/blob/4.0/.circleci/config.yml#L758 copies
this configuration on the generated repository.
The commit on the generated repository will thus trigger a new CI/CD execution that will 
work in the context of the generated repository.

This approach allow to disconnect the concerns (correct publication and calculating statistics) in two independent flows. 

To enable the statistics calculation, in short:

1. enable CircleCI processing on the generated repository
2. create a ssh key that can write into the statistics repository
3. configure this key in the CircleCI steup of the generated repository
4. configure the config.yml with the parameters described below.

These steps are the same as the one to connect the publication repository with the generated repository.
For a more elaborated explanation, consult that setup documentation.

## Parameters
The CircleCI configuration must be adapted with the real values for the publication environment.

|PARAMETER in config.yml|attribute in config.json|description|
|---|---|---|
| `$$STATISTICSREPOFINGERPRINT`     | - | The ssh key fingerprints for the statistics repository. See generic deployment instructions at [README.md](../config/README.md) |
| `$$STATISTICSREPO`     | - | The git url of the statistics repository |
