# OSLO-publicationenvironment-template
This is a template for the OSLO publication environment.



## deployment instructions
After the template has initiated a publication environment, the setup has to be completed with additional configuration.

1. Create the corresponding generated repository. A plain empty repository is sufficient
2. Read the configuration instructions in
    - [config/README.md](./config/README.md)
    - [./circleci/README.md](./circleci/README.md)
3. Follow the instructions and adapt and setup the configurations for one hostname (e.g. for the development hostname) 
    - adapt thus the configuration files to your context
    - activate CircleCI processing
4. Select a demo thema repository containing a valid data specification for testing purposes, and configure the first publication point.
5. address any technical error, until the demo publication point is successfully processed and resulted in an expected commit in the generated repository.
6. remove any boilerplate documentation files that is superflusious.
