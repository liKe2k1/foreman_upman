# ForemanUpman

This plugin gives you some basic update functions to manage your Debian-like Hosts with Foreman.
 

## Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins


#### Ubuntu / Debian instructions

_**Not yet published**_

``apt-get install ruby-foreman-upman``


#### Manual

```
git clone https://github.com/liKe2k1/foreman_upman.git

# In your Foreman application open
vi bundle.d/Gemfile.local.rb

# Add this
gem 'ajax-datatables-rails'
gem 'html2text'
gem 'foreman_upman', :path => '../foreman_upman'

# Run bundle install
bin/bundle install

# Preompile assets
bin/rake assets:precompile

# Run database migrations
RAILS_ENV=production bin/rake db:migrate
```


####

## Usage

#### Channels

#### Repositories

#### Errata

#### Configuration

#### Host synchronization

#### Install updates

#### Plan updates

#### Mask packages

If you have some application running where you cant restart them ad-hoc, you can mask packages.

They will ignored by the automatic update process. 




## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) 2019 Tobias Ehrig

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

