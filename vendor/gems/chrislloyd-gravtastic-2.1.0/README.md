<center>The Super Fantastic Way Of Having Gravatars</center>
============================================================

<center><small>by the veritable [Chris Lloyd](http://chrislloyd.com.au)</small></center>

So you have a hyper-connected social leveraging app and you've heard the kids talking about these [Gravatars](http://gravatar.com). Well! You've come to the right place.

In 5 minutes add Gravatarms (or sum such) to your project. Works in Rails, Merb _and_ plain ol' Ruby. Lets get started.

Install
-------

    sudo gem install gravtastic


Usage
-----

Add this to your `environment.rb`:

    config.gem 'gravtastic', :version => '>= 2.1.0'

Next, give your model a Gravatar:

    class User
      is_gravtastic!
    end

And you are done! In your views you can now see pretty Gravatars.

    %img{:src => @user.gravatar_url}

If you want to change the image, you may want to do this:

    %img{:src => @user.gravatar_url(:rating => 'R', :secure => true)}

That will show R rated Gravatars over a secure connection. That could get awful boring, doing it _each_ time, over and over throughout your app. How about we provide an app wide default? In your model, just change the `is_gravtastic!` line.

    is_gravtastic :author_email, :secure => true,
                                 :filetype => :gif,
                                 :size => 120

Now all your Gravatars will come from a secure connection, be a GIF and be 120x120px. The email will also come from the `author_email` field, not the default `email` field. Don't worry, your not locked into these defaults though. You can override them by passing options to `#gravatar_url` like before.

**Plain Jane Ruby**

So you just have a regular ol' Ruby app? No ActiveRecord? Awwww...

    require 'gravtastic'
    class BoringUser
      include Gravtastic
      is_gravtastic!
    end

And wallah! That works exactly the same as in Rails! Now all instances of the BoringUser class will have `#gravatar_url` methods.


Fixin' Shit Fer Yerself
-----------------------

Fork the project, submit a pull request and I'll get to it straight away. Or you can just view the source like:

    git clone git://github.com/chrislloyd/gravtastic.git


Props
-----
* [Xavier Shay](http://rhnh.net) and others for [Enki](http://enkiblog.com) (the reason this was originally written)
* [Matthew Moore](http://www.matthewpaulmoore.com/) for helpful suggestions and for submitting it to the official list of Gravatar implementations.
* [Vincent Charles](http://vincentcharles.com/) For some documentation in a previous version.


License
-------

Copyright (c) 2009 Chris Lloyd.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
