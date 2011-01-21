# Oauned

Rails Engine that lets you become an OAuth Provider.

## Installation

You can use the latest gem which is on rubygems.

    gem install oauned

Don't forget to add it to your Gemfile !

Then, you must create the local models.

    rails g oauned:install

This will create three models in your application : `Application`, `Authorization`, `Connection`  
You'll need a fourth one, which is not created : `User`. The authentication management gem you're using should be creating it, not us.

You can easily rename those models. Just change their name and the relations names between them.

A route is also created.

    scope '/oauth' { oauned_routing }

What's important is the call to `oauned_routing`. Wherever you call this method in your routes, the oauth routes will be created.  
They can be created several times but it's not really advised.  
In the above case, they'll be created in the `/oauth` path.

You can now start your rails server, and start connecting to your application using OAuth.

## Controller Helpers

There are several controller helpers intended to allow you to manage your oauth connections.

- deny_auth - This is a class method. When called, the specified actions won't be accessible while using OAuth.  
`deny_oauth, :only => :index`  
The `:only` and `:except` options are available.

- oauth_user - This represents the oauth_user. You almost never need to use it.
- current_user - This method usually represents your user, whether he's connected "normally" or via OAuth.
- oauth_allowed? - Has oauth been allowed or denied for the current action ?

## Personnalize the view

When a user tries to connect via OAuth, he'll see a page asking for acceptation. You can personalize this page.  
Create the file `app/views/oauned/oauth/index.html.erb` (or any rendering engine you wish to use other than erb) and put your content in it.  
You can find the default view at [app/views/oauned/oauth/index.html.erb](https://github.com/dmathieu/oauned/blob/master/app/views/oauned/oauth/index.html.erb).

## Let the users create and manage applications

OAuned manages only user authentication. It's your task to allow your users to create new applications and provide them an interface to see what applications they've accepted.  
To do that, you can manipulate the models directly.

* **Application** - Represents any application created.
* **Connection** - Represents a connection between a user and an application.

The **Authorization** model is used only to authorize the user when establishing the connection. You shouldn't use it.

## Contributing

We're open to any contribution. It has to be tested properly though.

* [Fork](http://help.github.com/forking/) the project
* Do your changes and commit them to your repository
* Test your changes. We won't accept any untested contributions (except if they're not testable).
* Create an [issue](https://github.com/dmathieu/oauned/issues) with a link to your commits.

## Maintainers

* Damien MATHIEU (http://github.com/dmathieu)

## License
MIT License. Copyright 2010 Damien MATHIEU. http://dmathieu.com