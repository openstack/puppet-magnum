Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-magnum.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

magnum
======

#### Table of Contents

1. [Overview - What is the magnum module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with magnum](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)
8. [Release Notes - Release notes for the project](#release-notes)
9. [Repository - The project source code repository](#repository)

Overview
--------

The magnum module is a part of [OpenStack](https://opendev.org/openstack), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects not part of the core software.  The module itself is used to flexibly configure and manage the container service for OpenStack.

Module Description
------------------

The magnum module is a thorough attempt to make Puppet capable of managing the entirety of magnum.  This includes manifests to provision region specific endpoint and database connections.  Types are shipped as part of the magnum module to assist in manipulation of configuration files.

Setup
-----

**What the magnum module affects**

* [Magnum](https://docs.openstack.org/magnum/latest/), the container service for OpenStack.

### Installing magnum

magnum is not currently in Puppet Forge, but is anticipated to be added soon.  Once that happens, you'll be able to install magnum with:

```shell
puppet module install openstack/magnum
```

### Beginning with magnum

To utilize the magnum module's functionality you will need to declare multiple resources. This is not an exhaustive list of all the components needed, we recommend you consult and understand the [core openstack](http://docs.openstack.org) documentation.

Implementation
--------------

### magnum

magnum is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
-----------

* All the magnum types use the CLI tools and so need to be run on the magnum node.

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-magnum/graphs/contributors

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-magnum

Repository
----------

* https://opendev.org/openstack/puppet-magnum
