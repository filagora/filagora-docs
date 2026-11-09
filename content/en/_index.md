---
title: Filagora Developer Docs
linkTitle: Filagora
---

{{< blocks/cover title="Filagora" image_anchor="top" height="auto" >}}
<div class="mx-auto">
  <p class="lead mt-3">A modular forum, CMS, memberships and community toolkit for Laravel 13 and Filament 5, as independent packages you install one at a time.</p>
  <a class="btn btn-lg btn-primary me-3 mb-4" href="{{< relref "/docs/getting-started" >}}">Get started</a>
  <a class="btn btn-lg btn-secondary mb-4" href="{{< relref "/docs/concepts" >}}">How it fits together</a>
</div>
{{< /blocks/cover >}}

{{% blocks/lead color="primary" %}}
Every package is a Filament plugin with its own repository, version, config file and tests. Dependencies run one way and are mostly optional, so a host takes only the pieces it needs.
{{% /blocks/lead %}}

{{% blocks/section color="white" type="row" %}}
{{% blocks/feature icon="fa-diagram-project" title="Architecture" url="/docs/concepts/architecture/" %}}
How the packages depend on each other, and the conventions they all share.
{{% /blocks/feature %}}
{{% blocks/feature icon="fa-box-open" title="Packages" url="/docs/packages/" %}}
One reference page per package: install, configuration, commands and extension points.
{{% /blocks/feature %}}
{{% blocks/feature icon="fa-code-branch" title="Contributing" url="/docs/contributing/" %}}
Testing, CI, releases and how this documentation site is built.
{{% /blocks/feature %}}
{{% /blocks/section %}}
