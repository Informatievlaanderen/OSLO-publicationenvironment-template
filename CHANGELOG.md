# Changelog 

# version 3.0
- initial version of the template based on the OSLO toolchain 3.0
- make version value according to semver.

# version 3.0.1
- make ea-to-rdf extraction logs more readible
- halt on error in ea-to-rdf extraction process.
- publish translation support files

# version 3.0.2
- fix the upgrade_config.sh script to not change the configuration when the configuration contains a valid translation block.

# version 3.0.3
- add documentation on the Docker images used
- version fix the Docker images
- re-iniate template variable in CircleCI config
- add xsd generation configuration 
- add extra message in case downloading from GitHub fails
- fix mapping for vocabulary definition

# version 3.0.4
- upgrading configs from toolchain 2.0 to toolchain 3.0 bugfix
- html-renderer: bugfix, language aware title in translation config block is taken into account.

# version 3.0.5
- add scripts to validate the presence of each publication point in the generated repository
- integrate the scripts in the last step of CircleCI artefact_create
- make triggerall option to rebuild only the changed publication points when switched off
- fix issues with English vocabulary template 
- fix external dependency failure of ruby tool linkeddata by bumping the ruby image version 

# version 3.0.6
- improve development mode 
- remove old script findPublicationsToUpdate.sh2
- introduce improvement case of wegenenenverkeer.data.vlaanderen.be 
    copy only the parts from the Thema repository that are relevant for the processing of the publication point.
    I.e. not the directories codelijsten and site-skeleton subdirectories of other specifications 

# version 3.1.0
- bumped the number as this contains a major revision in the structure of the CircleCI config. 
  The change requires substantial adaptations to the config (mainly reducing the number of parameters).
  To indicate this effort a new major release number is created.
- reduced the amount of adaptations that a toolchain deployer has to do the CircleCI config:
     - add attributes to encode information can be moved to /config/config.json
     - add a new script to clone a repository
- upgraded to the latest CircleCI docker base images
- update_sshconfig.sh has a missing handling of the first argument

# version 3.1.1
- add support for statistics
- add documentation reference for Personal Access Tokens (PAT)

# version 3.1.2
- bump image version numbers to latest
- add parameter interpretation for generators:
   - script defaults are overwritten by config.json config
   - config.json defaults are overwritten by publication point config
- add freeze and unfreeze supporting scripts


# version 4.0.0
- Move away from the Java based OSLO toolchain to the Typescript based OSLO toolchain.
- used libraries:
  * https://www.npmjs.com/package/@oslo-flanders/core
  * https://www.npmjs.com/package/@oslo-flanders/ea-uml-extractor
  * https://www.npmjs.com/package/@oslo-flanders/ea-converter
  * https://www.npmjs.com/package/@oslo-flanders/stakeholders-converter
  * https://www.npmjs.com/package/@oslo-flanders/shacl-template-generator
  * https://www.npmjs.com/package/@oslo-flanders/rdf-vocabulary-generator
  * https://www.npmjs.com/package/@oslo-flanders/jsonld-context-generator
  * https://www.npmjs.com/package/@oslo-flanders/json-webuniversum-generator
  * https://www.npmjs.com/package/@oslo-flanders/html-respec-generator
  * https://www.npmjs.com/package/@oslo-flanders/html-generator
  * https://www.npmjs.com/package/@oslo-flanders/examples-generator

Version 4.0.0 is conceptually the same as version 3.x.y. but because it reimplements the
core tools: the UML extractor and the artefact generators, the change is a major update.
From a user perspective, the same publicationpoints and config are being supported.
But the whole CI/CD flow has been adapted in a distructive manner.
Upgrading from version 3.x.y to 4.x.y is thus a non-trivial task.

# version 4.0.1
- improvements in the CI/CD
- adding monitoring setup
- include more strictness checks
- adding statistics + configuration instructions 
- add supporting tools
- replace the specific configuration values in the CI/CD with generic templates
- Make the statistics csv processing more robust
- include the latest templates 

# version 4.0.2
- circleci statitistics improvement

