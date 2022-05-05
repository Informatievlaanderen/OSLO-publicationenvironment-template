This directory contains the static parts of the website that is being produced.

 - [index.html](./index.html): the root page of the website
 - [cms](./cms): aka content management system, a directory containing the supportive technical content such as images, icons, and more.
 - [robots.txt](./robots.txt): the file describing the instructions for bots scraping the publication environment

 
The website generator creates two directories
  -  /doc : the (versioned) data specifications according to the publication points specified in the config directory.
  -  /ns  : the namespace for persistent URIs 

The publication environment assumes the creation of _persistent URIs_ for a term according to the pattern

   `https://{domain}/ns/{vocabulary-path}#{reference}`

where 
   - {domain}: the domain on which the URIs are published
   - {vocabulary-path} : the path on which the vocabulary is publishes. Usually it is a single element as `mobility` but it can be also more complicated e.g. `mobility/trains` 
   - {reference} : the unique, local reference of the term within the vocabulary.

This pattern is in accordance to the [Flemish Standard for Persistent Identifiers](). 
This rules are in accordance with the [Belgian Government Standard for Persistent Identifiers]().
Both standards implement the 10 rules for persistent identifiers by SEMIC.

The webservice proxy, a component deployed in the [publication environment](/documentation/README.md). must ensure the required behavior (content negotation/dereferencing) expressed in those standards for the URIs following the above pattern. 

In order to limit security breaches, but still offer editors  a quick way to add static content without requiring technical support, the following rules have been made:
   - 'cms' is an open space which will be served by the proxy as `https:{domain}/cms/`. Editors are welcome to contribute to this space with html pages and static content to share content on the publication environment.
   - 'id', 'doc' and 'ns' are reserved paths for supporting persistent identifiers
   - 'standaarden'  is reserved path for supporting the registry of data specifications

The implemented proxy component might additionally add more reservations and usage guidelines for paths. 
But that is beyond this template.


 




