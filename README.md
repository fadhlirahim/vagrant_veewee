Vagrant, veewee, chef-solo & knife-solo stuff
=================================
Where I explore the usage of Vagrant, veewee and knife-solo.

Prerequisite before usage: Install VirtualBox first. This repo uses Virtualbox 4.1.2 & vagrant 0.8.7

Although vagrant has the built-in integration with chef, I wanted to use a tool (using knife-solo) if I wanted to deploy
my server configurations to any servers in the future.


Vagrant & Veewee
===================

Vagrant helps you easily create VM's using VirtualBox. 
This way, you can create servers to deploy your code to & closely
simulate the servers to your production servers.

using veewee: (for easy configuration & build of VMS)
The best thing about veewee is that it gives you templates for your baseboxes

These commands pretty much covers everything you need to know about vagrant.

	gem install vagrant
	gem install vewee

list out all the templates/baseboxes available from veewee

	vagrant basebox templates

To create your VM VirtualBox basebox

	vagrant basebox define 'ubuntu1104' 'ubuntu-11.04-server-amd64'

To build the whole freaking server from iso file. It will d/l iso file into your local machine.
pretty long wait. go get a coffee + exercise.

	vagrant basebox build 'ubuntu1104'

Runs a test to check everything was built ok

	vagrant basebox validate 'ubuntu1104'

Package your basebox into an actual reusable VirtualBox box.

	vagrant basebox export 'ubuntu1104'

You can create many boxes or servers base on 'ubuntu1104.box'. Examples:

	vagrant box add 'webserver' 'ubuntu1104.box'
 	vagrant box add 'db' 'ubuntu1104.box'

Run init, it will create a Vagrantfile. This configuration file pretty much tells what should the VM contains

	vagrant init 'webserver'

Runs the server on Virtualbox
	
	vagrant up
 
Logging in to the vm

	vagrant ssh

Remove VM from VirtualBox.

	vagrant destroy



After that, you can pretty much configure your VM's environment,
even make it multi-environment VM's in one config file. 

Server provisioning is done using chef-solo or puppet. I'm leaning towards chef-solo.

Next thing is understanding how to start about with creating cookbooks.


Chef-solo
=============

Chef is a server configuration & provisioning tool. Written in ruby.
Basically it means you can code your server stack.

They have 2 modes using chef. Using chef server or chef-solo.

From my understanding, chef-solo means everything is kept in your local machine.

Really good video using chef-solo:
http://www.youtube.com/watch?v=1G6bd4b91RU

Other useful links:

https://github.com/opscode/cookbooks

http://jonathanotto.com/blog/chef-tutorial-in-minutes.html

http://blog.carbonfive.com/2011/08/03/think-globally-stage-locally/

Notes:

All cookbooks are inside mykitchen/cookbooks


Using knife-solo
================

Note: You don't have to use knife-solo to deploy to your VirtualBox using vagrant,
but it's good exercise to know these steps if you want to configure to other servers
You can read knife-solo source code here: https://github.com/matschaffer/knife-solo

Commands :
	gem install knife-solo
	

	knife configure -r . --defaults
	
		The following screen will come out:
		WARNING: No knife configuration file found
		*****

		You must place your client key in:
		  /Users/fadhlirahim/.chef/fadhlirahim.pem
		Before running commands with Knife!

		*****

		You must place your validation key in:
		  /etc/chef/validation.pem
		Before generating instance data with Knife!

		*****
		Configuration file written to /Users/fadhlirahim/.chef/knife.rb

To create skeleton chef-solo setup:

	knife kitchen mykitchen
	
A skeleton app will be created

	mykitchen
	├── cookbooks
	├── data_bags
	├── nodes
	├── roles
	├── site-cookbooks
	└── solo.rb
	
To create nginx cookbook

  knife cookbook create nginx -o cookbooks

Note: -o cookbooks tells it to create nginx cookbook in directory

	mykitchen
	├── cookbooks
		|-- nginx
	├── data_bags
	├── nodes
	├── roles
	├── site-cookbooks
	└── solo.rb

To prepare the targeted server or node, we have to make sure the 
target server has chef & ruby installed. The following commands helps u
to do that:

	knife prepare vagrant@33.33.33.10

Since chef-solo doesn't have any interaction with a Chef Server, 
you'll need to specify node-specifc attributes in a JSON file. This can 
be located on the target system itself, or it can be stored on a 
remote server such as S3, or a web server on your network.

Within the JSON file, you'll also specify the recipes that Chef should run 
in the "run_list". An example JSON file

In this example, look into /nodes/33.33.33.10.json. 
We're just setting up nginx in this example:

	{ "run_list": ["recipe[nginx]"] }

	
Then, edit your cookbook nginx recipe at.

	mykitchen
	├─ cookbooks
		|- nginx
		  |- recipes/default.rb

Inside default.rb
	# This tells to install the nginx package
	package 'nginx'
	
	# This shows the service status and we tell it to start nginx
	service 'nginx' do
	  supports [:status]
	  action :start
	end

	
Then to deploy using knife-solo

	knife cook vagrant@33.33.33.10
	
And you can go to your browser and fill in the URL you deploy it too
and then you can see the default "Welcome to Nginx" comes out.

If you're deploying to a VM using vagrant, make sure you forward port 80 to any
port than you want and can view it in your local machine browser.

Note:

I've created a ruby file called dna.rb inside mykitchen/nodes. You can run

	ruby dna.rb

And this will generate dna.json file for you. This file will also be used by Vagrant configuration so you don't have to write specifically for vagrant and still want to retain a node json file to use outside vagrant.



TODO
====
Update will relevant cookbooks at put them in mykitchen and update the dna.rb accordingly



