# Continuous Integration / Continuous Deployment setup.

The used CI/CD environment is [CIRCLECI](https://circleci.com).

Generic documentation about the configuration language and the possibilities of CircleCI can be found [here](https://circleci.com/docs/).


# activating CircleCI 
To enable the CI/CD execution by CircleCI, one has first to login into CircleCI web application and grant CircleCI the rights to monitor the repository.
When enabled, each commit will initiate the execution of the [CircleCI configuration](./config.yml). 


# configuration CircleCI
The toolchain execution is described as a CircleCI workflow, called `generate_documentation`.
The workflow consists of a sequence of CircleCI jobs, each consisting of CircleCI steps.
A job is executed in a Docker container containing the content of this repository.
The Docker containers are based on public accessible Docker images. 
These Docker images provide specific software for the job, extending the appropriate public CircleCI image.

The executed steps within a job are either based on the specific configuration in the CircleCI language (e.g. checkout, attach_workspace, ...) or execute a script residing in this repository (i.e. the steps with `run`).
The scripts simplify the steps in in the CircleCI configuration.
Therefore these scripts can also be considered part of the CircleCI configuration.

## Parameters
The CircleCI configuration must be adapted with the real values for the publication environment.
These values should be conform with the values in `/config/config.json`.

|PARAMETER in config.yml|attribute in config.json|description|
|---|---|---|
| `$$GENERATEDREPO`         |generatedrepository.repository | the name of the generated repository |
| `$$GITURL-GENERATEDREPRO` | - | The ssh url to clone the generated repository |
| `$$SSHKEYFINGERPRINT`     | - | The ssh key fingerprints. See deployment instructions at [README.md](../config/README.md) |
| `$$GITUSEREMAIL`          | -  | The email of the git user that commits the change to the generated repository. Example "info@data.specs.org"|
| `$$GITUSERNAME`           | -  | The user name of the git user that commits the change to the generated repository Example "Circle CI Builder"|
| `$${DEV,TEST,PROD}HOSTNAME` | domain,hostname | the hostnames on which the branches in the generated repository are being published. The default branch-names are `dev`,`test`,`production`. |




# Tips & Tricks

The jobs share their work via the step commands `attach_workspace` and `persist_to_workspace`.
At the start of a job the outcome of the previous job is attached and after the execution of the job the result is written out.
By using the same directory `/tmp/workspace` throughout the CircleCI workflow a virtual shared disk is created.

When jobs are executed in parallel, then one has to avoid that the same directory is written by both jobs, otherwise the next job that combines the result of both jobs will initiate an error.


# Performance considerations

The performance of the CircleCI is determined by the following elements:

 - the time to checkout the GitHub repositories specified in the publication points
 - the size of the virtual shared disk 
 - the length of the longest path throughout the workflow
 - the size of the generated repository

All these elements have in common: the performance of the network. 
In the first and last case, it is limited by the download speed from GitHub.com to the CircleCI.com operational environment.
In the second and third case it is the internal network speed within the CircleCI.com operational environment.
On the unit values one has no influence, this is determined by CircleCI. 
But the scripts are made smart to reduce the impact of these elements. 






